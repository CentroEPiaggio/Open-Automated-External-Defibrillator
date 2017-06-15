classdef psoc_talker
    properties
        s           % Serial port
        message     % Message to send to the psoc
        verbose     % Decide wether the class should give or not some feedback
    end %   end of properties

    methods

        function obj = psoc_talker(com, m, v)
            try
                obj.s = serial(com, 'Baudrate', 9600);
                fopen(obj.s);
            catch
                obj.s = NaN;
                disp(['Could not init ' com ' port'])
                disp(instrfind)
                return;
            end
            if (nargin < 3)
                obj.verbose = false;
            else
                obj.verbose = v;
                endolaaonfsflnd
            end
            if (nargin < 2)
                obj.message = [];
                return;
            end
            obj.message = m;
            return;
        end % end of constructor

        function delete(obj)
            try
                fclose(obj.s);
            catch
            end
            delete(obj.s);
            return;
        end % end of delete

        function success = reload(obj)
            if (strcmp(obj.s.Status,'open'))
                try
                    fclose(obj.s);
                catch
                    disp('Could not close')
                    success = false;
                    return;
                end
            end
            try
                fopen(obj.s);
            catch
                disp('Could not re-open')
                success = false;
                return;
            end
            success = true;
            return;
        end % end of reload

        function success = sendsingle(obj)
            % Outdated function
            % Send data one by one
            time = tic;
            success = false;
            % Check and open connection
            if (~strcmp(obj.s.status, 'open'))
                if (~obj.reload)
                    return;
                end
            end
            n = length(obj.message);
            for k = 1:n
                % Send one 16-bit element per iteration
                try
                    fwrite(obj.s, obj.message(k), 'int16');
                catch
                    disp([num2str(toc(time)) ' : Could not write']);
                    return;
                end

                % Wait for the psoc to read it
                while (obj.s.BytesToOutput ~= 0)
                end
            end
            success = true;
            if (obj.verbose)
                disp([num2str(toc(time)) ' : Finished']);
            end
        end % end of send

        function success = send(obj)
            time = tic;
            success = false;
            % Check and open connection
            if (~strcmp(obj.s.status, 'open'))
                if (~obj.reload)
                    return;
                end
            end
            t = tic;
            while (obj.s.BytesAvailable ~= 0 ...
                || ~strcmp(obj.s.TransferStatus,'idle'))
                % Timeout 6sec
                if (toc(t) > 10)
                    message = NaN;
                    disp([num2str(toc(time)) ' : Psoc is busy']);
                    % Received no reply
                    return;
                end
            end
            % n is the length of the message to send
            n = length(obj.message);
            % The buffer is not unlimited, m is the number of 16-bit elements the
            % buffer can store.
            m = obj.s.OutputBufferSize / 2;
            % Message Index
            MI = 0;

            while ( n > 0 )
                % Repeat until all the elements of the message are sent

                % Each iteration send m elements, the last iteration send the
                % remaining n elements.
                if ( m > n )
                    m = n;
                end

                % Try to send data
                try
                    fwrite(obj.s, obj.message(MI+1 : MI + m ), 'int16');
                catch
                    disp([num2str(toc(time)) ' : Could not write']);
                    return;
                end

                % Update the message index and the remaining message length
                MI = MI + m;
                n = n - m;

                % Wait for the psoc to read it all
                while (obj.s.BytesToOutput ~= 0)
                end
            end
            % Success
            success = true;
            % Visual feedback
            if (obj.verbose)
                disp([num2str(toc(time)) ' : Finished']);
            end
        end % end of send

        function success = sendchar(obj, cha)
            % Send a single character to the psoc
            time = tic;
            success = false;
            % Check and open connection
            if (~strcmp(obj.s.status, 'open'))
                if (~obj.reload)
                    return;
                end
            end
            % if the message is longer than a single character, return false
            if (length(cha) > 1)
                disp('This method should only be used to send one character')
                return;
            end
            try
                fwrite(obj.s, cha);
            catch
                disp([num2str(toc(time)) ' : Could not write']);
                return;
            end
            success = true;

            if (obj.verbose)
                disp([num2str(toc(time)) ' : Finished']);
            end
        end % end of send

        function [message] = receive(obj)
            time = tic;
            % Check and open connection
            if (~strcmp(obj.s.status, 'open'))
                if (~obj.reload)
                    return;
                end
            end
            t = tic;
            while ( obj.s.BytesAvailable == 0  ) %|| obj.s.BytesToOutput ~= 0
                % Timeout 6sec
                if (toc(t) > 10)
                    message = NaN;
                    disp([num2str(toc(time)) ' : Psoc is busy']);
                    % Received no reply
                    return;
                end
            end
            % Read the message head
            % First byte is data width: 8, 16, or 32 bit
            [out] = fread(obj.s, 3)';
            bit = out(1);
            % Second and third byte are message length
            n = byte2word([out(2) out(3)]);
            if (n<0)
                n = byte2word([out(3) out(2)]);
            end
            % Initialize message
            message = [];
            % Read the message
            while (true)
                % Wait for data to be ready
                t = tic;
                while (obj.s.BytesAvailable == 0)
                    % Timeout 6sec
                    if (toc(t) > 6)
                        message = NaN;
                        display([num2str(toc(time)) ' : Timeout']);
                        return;
                    end
                end

                % Calculate how many bytes of the buffer still belong to this
                % message
                if (obj.s.BytesAvailable + length(message) > n * bit/8)
                    m =  n*bit/8 - length(message);
                else
                    m = obj.s.BytesAvailable;
                end

                % Try to read the buffer
                try
                    message = [message fread(obj.s, m)'];
                catch
                    disp([num2str(toc(time)) ' : Could not read']);
                    return;
                end

                % Have we done?
                if (length(message) == n * bit/8)
                    break;
                end
            end

            % 16 and 32 bit data need reconstruction.
            if (bit == 16)
                message = byte2word(message);
            elseif (bit == 32)
                message = byte2long(message);
            end

            if (obj.verbose)
                disp([num2str(toc(time)) ' : Finished']);
            end
        end % end of receive

    end % end of methods
end % end of class

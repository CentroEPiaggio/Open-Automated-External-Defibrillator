%% clean workspace
clear
close all
clc


%% Make the list of available signals in the folder
initialpath = pwd;
path = pwd;
dat_list = dir([path '\*.dat']);
n = size(dat_list, 1);

%% Infinite loop
while 1==1

    %% draw menu
    clc
    disp('Available signals :')
    for k = 1:n
        disp(dat_list(k).name)
    end
    disp('Select')
    disp('1) Change folder')
    disp('2) Evaluate Rhythm')
    disp('3) Load .mat file')
    disp('4) Evaluate Rhythm via PSoC')
    disp('0) Exit')
    in = input('Selection : ');

    switch in
        case 0
            %% Just exit
            break;
        case 1
            %% Clear screen
            clc
            % Show old path
            disp(['Old path : ' path])
            % Select new path
            path = input('New path : ','s');
            cd(path);
            % Load new list
            dat_list = dir([path '\*.dat']);
            n = size(dat_list, 1);
            % go back to main menu
            continue;

        case 2
            %% Clear screen
            clc
            % Show avaliable signals
            disp('Available signals :')
            for k = 1:n
                disp([num2str(k) ' - ' dat_list(k).name]);
            end
            % Allow selection
            in = input('Select a signal (0 for all) : ');

            if( in > 0 && in <= n )
                %% Display single signal results
                [SCA, results, values, ecgf] = OAED_ECGanalysis( dat_list(in) );
                %% Save results
                in = input('Save results? (Y/N) : ', 's');
                if(strcmp(lower(in), 'y'))
                    name = strcat( ...
                        dat_list(k).name(1: find( dat_list(k).name=='.' ) -1),...
                        '_rhythm.mat' );
                        try
                            save(name, 'ecgf', 'SCA', 'results', 'values');
                            disp('Successfully saved');
                        catch
                            disp('Cannot save, did you check permissions?');
                        end
                end
            elseif( in == 0 )
                %% Display all available results, cannot save in this mode
                OAED_ECGanalysis( dat_list );
            end
            close all
            continue;
        case 3
            %% Clear screen
            clc
            % Show avaliable matfiles
            disp('Available mat-files :')
            mat_list = dir([path '\*.mat']);
            for k = 1:size(mat_list, 1)
                disp([num2str(k) ' - ' mat_list(k).name]);
            end
            % Allow selection
            in = input('Select a matfile : ');
            %% Load
            if( in > 0 && in < size(mat_list, 1))
                load( mat_list(k).name );

            end
            continue;
        case 4
            disp('To be added');
            continue;
    end
end
% clear some variables
clear in k n path dat_list
% return to initial path
cd(initialpath)

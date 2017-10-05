function h = stimtrain(h,opt)

% mods needed: use settings to define port number


switch h.Settings.stimcontrol

    case 'labjack'
        % pulse train instruction
        for pr = 1:h.Settings.npulses_train % train
            Error = ljud_AddRequest(ljHandle,LJ_ioPUT_DIGITAL_BIT,4,1,0,0);
            Error_Message(Error)

            Error = ljud_AddRequest(ljHandle,LJ_ioPUT_WAIT,4,round((1000000/h.Settings.p_freq)/2),0,0);
            Error_Message(Error)

            Error = ljud_AddRequest(ljHandle,LJ_ioPUT_DIGITAL_BIT,4,0,0,0);
            Error_Message(Error)

            Error = ljud_AddRequest(ljHandle,LJ_ioPUT_WAIT,4,round((1000000/h.Settings.p_freq)/2),0,0);
            Error_Message(Error)
        end
        %Execute the stimulus train
        Error = ljud_GoOne(ljHandle);
        Error_Message(Error)
        %ljud_GetResult(ljHandle, LJ_ioGET_DIGITAL_BIT, 7, @Value)
        
    case 'audioplayer'
        if ~exist('opt','var')
            opt = 'run';
        end
        
        switch opt
            case 'run'
                h=sinwave(h);
                h.Seq.aud = audioplayer(h.Seq.stimseq', h.Settings.fs);
                play(h.Seq.aud);
                %sound(h.Seq.stimseq', h.Settings.fs, 16);
                %pause(0.2)
            
            case 'create'
                h=sinwave(h);
                h.Seq.aud = audioplayer(h.Seq.stimseq', h.Settings.fs);
            
            case 'start'
                play(h.Seq.aud);
                h.playstart = GetSecs;
                
            case 'pause'
                pause(h.Seq.aud);

            case 'resume'
                resume(h.Seq.aud);

            case 'stop'
                stop(h.Seq.aud);
                
            case 'getsample'
                h.currentsample=get(h.Seq.aud,'CurrentSample');
                h.totalsamples=get(h.Seq.aud,'TotalSamples');
        end
        
    case 'PsychPortAudio'
        switch opt
            case 'setup'
                h = PTBaudio(h);
                
            case 'getsample'
                s = PsychPortAudio('GetStatus', h.pahandle);
                if s.Active == 1
                    h.currentsample=s.ElapsedOutSamples;
                    %h.totalsamples=;
                end
                
            case 'create' 
                h=sinwave(h);
                %if strcmp(h.Settings.design,'trials')
                %    PsychPortAudio('FillBuffer', h.pahandle, h.Seq.stimseq);
                %    
                %elseif strcmp(h.Settings.design,'continuous')
                %    h.pabuffer = PsychPortAudio('CreateBuffer', h.pahandle, h.Seq.stimseq);% Engine still running on a schedule?
                %   
                %end
                
            case 'start' 
                if strcmp(h.Settings.design,'trials')
                    PsychPortAudio('FillBuffer', h.pahandle, h.Seq.stimseq);
                    PsychPortAudio('Start', h.pahandle, 1, 0, 1);

                elseif strcmp(h.Settings.design,'continuous')
                    h.pabuffer = PsychPortAudio('CreateBuffer', h.pahandle, h.Seq.stimseq);
                   
                    s = PsychPortAudio('GetStatus', h.pahandle);
                    if s.Active == 0 %&& ~isfield(h,'i') % new run
                        PsychPortAudio('UseSchedule', h.pahandle, 1, length(h.Seq.signal));
                        PsychPortAudio('AddToSchedule', h.pahandle, h.pabuffer);
                        h.playstart = PsychPortAudio('Start', h.pahandle, 0, 0, 1);
                    %elseif s.Active == 0 
                    %    error('increase ntrialsahead in Settings')
                    else
                        PsychPortAudio('AddToSchedule', h.pahandle, h.pabuffer);
                        disp('new trial(s) added to schedule')
                    end
                end
        end
end

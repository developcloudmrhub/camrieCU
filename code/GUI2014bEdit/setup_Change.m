function setup_Change(pos, inputInfoOld)

addpath(genpath([pwd,'\Bin\']));
addpath(genpath([pwd,'\SeqDev\']));

addr = pwd;

% Set file selection path
fileAddr = pwd;


% load('SeqEditDel.mat');
% load('SeqEditDel.mat');
% load('InputInfoLoad.mat');
% clear inputCmd;
writeSeqEdit(pos, inputInfoOld);
load('ReplSeq.mat');

    %% --- Executes on hSeqGen_Button.
   
    
    
        global interSeqData inputInfo;
                
        %cd(addr);
        
%         tempAddr = pwd;
        
%         path(path,[pwd,'\SeqDev\Functions\']);
%         path(path,[pwd,'\SeqDev\Bin\']);
        
%         RF.FA = str2double(get(hRF_FA,'String')); % Degrees
        
        RF.FA = cRF_FA;
%         [MagMat, PhsMat,index] = TxMagPhsGUI(Tx.Num,Tx.MagMat,Tx.PhsMat,RF.FA);
        index = 1;
        
        cMagMat = 1;
        cPhsMat = 0;
        
        if index ~= 0
            Tx.MagMat = cMagMat;
            Tx.PhsMat = cPhsMat;
            Tx.Num = cTxNum;
            
%             Tx.Num = 4;
%             Tx.MagMat = [1;12;1;2];
%             Tx.PhsMat = [0;0;0;1];
            
            
            Rx.Num = cRxNum;
            
            
%             set(hTx,'Enable','off');
%             set(hRx,'Enable','off');
%             
            %cd([tempAddr '\SeqDev\User']);
        
%             TE = str2double(get(hTE,'String')); %ms
            TE = cTE;
%             TR = str2double(get(hTR,'String')); %ms
            TR = cTR;
%             TI.duration = str2double(get(hTI,'string')); %ms
            TI.duration = cTI;
%             MatSize.value = get(hMatSize,'value');
            MatSize.value(1) = cMatSizeFE;
            MatSize.value(2) = cMatSizePE;
%             FOV.value = get(hFOV,'value'); %mm
            FOV.value(1) = cFOVFE;
            FOV.value(2) = cFOVPE;
%             RF.Duration = str2double(get(hRF_Duration,'String')); %ms
            RF.Duration = cRFDuration;
%             RF.Num = str2double(get(hRF_Num,'String'));
            RF.Num=cRFPts;
%             RF.Shape = get(hRF_Shape,'Value');
            RF.Shape = cRFShape;
            
%             ADC.BW = str2double(get(hADC_Freq,'String')); %kHz
            ADC.BW = cBW;

%             GradOn.ss = get(hSS,'Value'); %gradients are specified in mT/m, but here it is a on/off flag.
            GradOn.ss = cSS;
%             GradOn.fe = get(hFE,'Value');
            GradOn.fe = cFE;
%             GradOn.pe = get(hPE,'Value');
            GradOn.pe = cPE;
            
%             temp = get(hPEDirectMenu,'String'); peDirectoin = temp(get(hPEDirectMenu,'Value')); clear temp;

            peDirect = cell(2,1);
            peDirect(1) = {'P--A'};
            peDirect(2) = {'L--R'};
            
            peDirectoin = peDirect(cPEDirect);

%             dummy = str2double(get(hDummyNum,'String'));
            dummy = cdummy;

%             slice.TH = str2double(get(hGeoSliceTH,'String'))/1000;
            slice.TH = csliceTH/1000;
            
            valuesw = cSliceOrientation;
            
            
            
%             switch get(hOrientationMenu,'Value')
            switch valuesw
                case 1
                    slice.offset = (inputInfo.currentZ - inputInfo.ctrZ)*inputInfo.widZ/1000;
                case 2
                    slice.offset = (inputInfo.currentX - inputInfo.ctrX)*inputInfo.widX/1000;
                case 3
                    slice.offset = (inputInfo.currentY - inputInfo.ctrY)*inputInfo.widY/1000;
            end;
            
%             tempNum = get(hSeqType,'Value');
            tempNum = cSeqType;
%             load('SeqTypes.mat');
%             tempStr = get(hSeqType,'String');
            
            
            %MatSize.handle = hMatSize;
            %FOV.handle = hFOV;
            
%             load('SeqEdit.mat', 'hMatSize_Pop', 'hFOV_Pop');
            
%             interSeqData = SeqInterfaceOut(cell2mat(tempStr(tempNum)),...
%                 tempNum,TE,TR,MatSize,hMatSize_Pop,FOV,hFOV_Pop,RF,ADC,GradOn,dummy,slice,TI);
            
            interSeqData = SeqInterfaceOutCMD(cell2mat(tempStr(tempNum)),...
                tempNum,TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice,TI);
            
%             set(hSeqPlot,'Enable','on');
            
            %cd([tempAddr '\SeqDev\Bin']);

            interSeqData = checkSeqProt(interSeqData);
%             finalSeqData = combineSeq(interSeqData,get(hOrientationMenu,'Value'),peDirectoin,dummy); %
            finalSeqData = combineSeq(interSeqData,cSliceOrientation,peDirectoin,dummy); %

            expSeq(finalSeqData,dummy,Tx,Rx); %

            % inputCmd{5,1}=''; inputCmd{5,2}=''; % B1+ FileName
            % inputCmd{6,1}=''; inputCmd{6,2}=''; % E1+ FileName
            % inputCmd{7,1}=''; inputCmd{7,2}=''; % B1- FileName
            % inputCmd{8,1}=''; inputCmd{8,2}=''; % E1- FileName
            
%             if ~isempty(inputCmd{1,1}) && ~isempty(inputCmd{2,1})
%                 set(hRun,'Enable','on');
%             end;

%             set(hExpSeqEdit,'String',get(hStudyName,'String'),'FontAngle','normal');
%             inputCmd{4,2} = [get(hStudyName,'String'),'.seqn'];
%             inputCmd{4,1} = [addr,'\Protocols\',get(hStudyName,'String'),'\']; %%---

%             set(hSeqPlot,'Enable','on');

%             set(hMode,'Enable','on');
%             tempMode = get(hMode,'Value');
%             switch tempMode
%                 case {1,2}
%                     set(hB0Edit,'Enable','on');
%                     set(hExpDB0,'Enable','on');
                    
%                     set(hExpB1m,'Enable','on');
%                     tempStr = get(hExpB1mEdit,'String');

%                         set(hExpB1mEdit,'String','Homogeneous or B1- Filename(s)','FontAngle','italic');
%                         clear inputCmd{7,1} inputCmd{7,2};
                    
%                     set(hExpGx,'Enable','on');
%                     set(hExpGy,'Enable','on');
%                     set(hExpGz,'Enable','on');

%                     set(hExpB1p,'Enable','on');
%                     set(hExpB1m,'Enable','on');
%                     set(hExpB1pEdit,'String','Homogeneous or B1+ Filename(s)','FontAngle','italic');
%                     clear inputCmd{5,1} inputCmd{5,2};
                    
%                     set(hExpE1p,'Enable','off');
                    % set(hExpE1pEdit,'String','E1+ Filename(s)','FontAngle','italic');
                    % clear inputCmd{6,1} inputCmd{6,2};
                    
%                     set(hExpE1m,'Enable','off');
                    % set(hExpE1mEdit,'String','E1- Filename(s)','FontAngle','italic');
                    % clear inputCmd{6,1} inputCmd{6,2};

%                     set(hNumIso,'Enable','on');
%                     set(hThread,'Enable','on');

%                 case 3
%                     set(hB0Edit,'Enable','off');
%                     set(hExpDB0,'Enable','off');
                                       
%                     set(hExpGx,'Enable','off');
%                     set(hExpGy,'Enable','off');
%                     set(hExpGz,'Enable','off');

%                     set(hExpB1p,'Enable','on');
%                     set(hExpB1m,'Enable','off');
                    
%                     set(hExpE1p,'Enable','on');
                    % set(hExpE1pEdit,'String','E1+ Filename(s)','FontAngle','italic');
                    % clear inputCmd{6,1} inputCmd{6,2};
                    
%                     set(hExpE1m,'Enable','off');
                    % set(hExpE1mEdit,'String','E1- Filename(s)','FontAngle','italic');
                    % clear inputCmd{8,1} inputCmd{8,2};
                    
%                     set(hNumIso,'Enable','off');
%                     set(hThread,'Enable','on');

%                 case 4
%                     set(hB0Edit,'Enable','off');
%                     set(hExpDB0,'Enable','off');
                                        
%                     set(hExpB1m,'Enable','off');
%                     set(hExpB1mEdit,'String','Homogeneous or B1- Filename(s)','FontAngle','italic');
%                     clear inputCmd{7,1} inputCmd{7,2};
                    
%                     set(hExpGx,'Enable','off');
%                     set(hExpGy,'Enable','off');
%                     set(hExpGz,'Enable','off');

%                     set(hExpB1p,'Enable','off');
%                     set(hExpB1pEdit,'String','Homogeneous or B1+ Filename(s)','FontAngle','italic');
%                     clear inputCmd{5,1} inputCmd{5,2};
                    
%                     set(hExpE1p,'Enable','off');
                    % set(hExpE1pEdit,'String','E1+ Filename(s)','FontAngle','italic');
                    % clear inputCmd{6,1} inputCmd{6,2};
                    
%                     set(hExpE1m,'Enable','on');
                    % set(hExpE1mEdit,'string','E1- Filename(s)','FontAngle','italic');        
                    % clear inputCmd{8,1} inputCmd{8,2};
                    
%                     set(hNumIso,'Enable','off');
%                     set(hThread,'Enable','off');
%             end;

%             if ~isempty(inputCmd{1,1}) && ~isempty(inputCmd{2,1})
%                 set(hRun,'Enable','on');
%             end;
        end

end
            
    %% Export Sequence Function
    function expSeq(finalSeqData,dummy,Tx,Rx)
        
%         tempStr = get(hStudyName,'String');
        tempStr = 'NewStart';
        
        addr1= 'E:\Giuseppe\Giuseppe\NYU\PSUdoMRI Cloud\GUI2014b';
        
        cd([addr1,'\Protocols\',tempStr]);
        
        fid=fopen([tempStr,'.seqn'],'w');

        fwrite(fid,finalSeqData.totalNum,'float32');
        fwrite(fid,Tx.Num,'float32');
        fwrite(fid,Rx.Num,'float32');
        
        % Time
        if dummy > 0
            fwrite(fid,length(finalSeqData.Dummy.Time.value),'float32');
            fwrite(fid,finalSeqData.Dummy.Time.repeat,'float32');
            fwrite(fid,finalSeqData.Dummy.Time.value,'float32');
        end;
        fwrite(fid,length(finalSeqData.Main.Time.value),'float32');
        fwrite(fid,finalSeqData.Main.Time.repeat,'float32');
        fwrite(fid,finalSeqData.Main.Time.value,'float32');
        
        % ADC
        if dummy > 0
            fwrite(fid,length(finalSeqData.Dummy.ADC.value),'float32');
            fwrite(fid,finalSeqData.Dummy.ADC.repeat,'float32');
            fwrite(fid,finalSeqData.Dummy.ADC.value,'float32');
        end;
        fwrite(fid,length(finalSeqData.Main.ADC.value),'float32');
        fwrite(fid,finalSeqData.Main.ADC.repeat,'float32');
        fwrite(fid,finalSeqData.Main.ADC.value,'float32');
        
        % RF
        if dummy > 0
            for m=1:Tx.Num
                fwrite(fid,size(finalSeqData.Dummy.RF.value,2),'float32');
                fwrite(fid,finalSeqData.Dummy.RF.repeat,'float32');
                for n=1:size(finalSeqData.Dummy.RF.value,2)
                    fwrite(fid,real(finalSeqData.Dummy.RF.value(m,n)*Tx.MagMat(m)*exp(1i*Tx.PhsMat(m)/180*pi)),'float32');
                    fwrite(fid,imag(finalSeqData.Dummy.RF.value(m,n)*Tx.MagMat(m)*exp(1i*Tx.PhsMat(m)/180*pi)),'float32');
                    fwrite(fid,finalSeqData.Dummy.DFreq.value(m,n),'float32');
                end;
            end;
        end;
        
        temp = 0;
        for m=1:Tx.Num
            fwrite(fid,size(finalSeqData.Main.RF.value,2),'float32');
            fwrite(fid,finalSeqData.Main.RF.repeat,'float32');
            if Tx.Num == size(finalSeqData.Main.RF.value,1)
                for n=1:size(finalSeqData.Main.RF.value,2)
                    fwrite(fid,real(finalSeqData.Main.RF.value(m,n)*Tx.MagMat(m)*exp(1i*Tx.PhsMat(m)/180*pi)),'float32');
                    fwrite(fid,imag(finalSeqData.Main.RF.value(m,n)*Tx.MagMat(m)*exp(1i*Tx.PhsMat(m)/180*pi)),'float32');
                    fwrite(fid,finalSeqData.Main.DFreq.value(n),'float32');
                    temp = temp + 1;
                end;
            else
                for n=1:size(finalSeqData.Main.RF.value,2)
                    fwrite(fid,real(finalSeqData.Main.RF.value(n)*Tx.MagMat(m)*exp(1i*Tx.PhsMat(m)/180*pi)),'float32');
                    fwrite(fid,imag(finalSeqData.Main.RF.value(n)*Tx.MagMat(m)*exp(1i*Tx.PhsMat(m)/180*pi)),'float32');
                    fwrite(fid,finalSeqData.Main.DFreq.value(n),'float32');
                    temp = temp + 1;
                end;
            end;
        end;
        
        % Gx
        if dummy > 0
            fwrite(fid,length(finalSeqData.Dummy.Gx.value),'float32');
            fwrite(fid,finalSeqData.Dummy.Gx.repeat,'float32');
            fwrite(fid,finalSeqData.Dummy.Gx.value,'float32');
        end;
        fwrite(fid,length(finalSeqData.Main.Gx.value),'float32');
        fwrite(fid,finalSeqData.Main.Gx.repeat,'float32');
        fwrite(fid,finalSeqData.Main.Gx.value,'float32');
        
        % Gy
        if dummy > 0
            fwrite(fid,length(finalSeqData.Dummy.Gy.value),'float32');
            fwrite(fid,finalSeqData.Dummy.Gy.repeat,'float32');
            fwrite(fid,finalSeqData.Dummy.Gy.value,'float32');
        end;
        fwrite(fid,length(finalSeqData.Main.Gy.value),'float32');
        fwrite(fid,finalSeqData.Main.Gy.repeat,'float32');
        fwrite(fid,finalSeqData.Main.Gy.value,'float32');
        
        % Gz
        if dummy > 0
            fwrite(fid,length(finalSeqData.Dummy.Gz.value),'float32');
            fwrite(fid,finalSeqData.Dummy.Gz.repeat,'float32');
            fwrite(fid,finalSeqData.Dummy.Gz.value,'float32');
        end;
        fwrite(fid,length(finalSeqData.Main.Gz.value),'float32');
        fwrite(fid,finalSeqData.Main.Gz.repeat,'float32');
        fwrite(fid,finalSeqData.Main.Gz.value,'float32');
        
        fclose(fid);
        
        %cd(addr);
        
        msgbox('Sequence File Generated.','modal');
    end


        
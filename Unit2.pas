unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, inifiles, Vcl.Samples.Spin,
  Vcl.ActnMan, Vcl.ActnColorMaps, VCLTee.TeCanvas, Vcl.ComCtrls, OmniRig_TLB,
  Vcl.Buttons;

type
  TsettingsForm = class(TForm)
    btnSave: TButton;
    btnClose: TButton;
    labSaveInfo: TLabel;
    PageControl1: TPageControl;
    TabDXCluster: TTabSheet;
    TabLogIntegration: TTabSheet;
    Colors: TTabSheet;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label6: TLabel;
    cbOwnSpotColorize: TCheckBox;
    colBoxOwnSpot: TColorBox;
    colBoxSpotMouseMove: TColorBox;
    cbSpotMouseMoveColorize: TCheckBox;
    cbSpotInLog: TCheckBox;
    colBoxSpotInLog: TColorBox;
    cbSpotLotwEqsl: TCheckBox;
    cbEarlySpot: TCheckBox;
    colBoxEarlySpot: TColorBox;
    colBoxRegularSpot: TColorBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    colBoxMainFreqPanel: TColorBox;
    btnDefaultFreqPanColor: TButton;
    btnGreennyFreqPanColor: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    gbAALogIntegration: TGroupBox;
    txtAalAddr: TLabeledEdit;
    txtAalPort: TLabeledEdit;
    cbAALogIntegrationEnabled: TCheckBox;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    txtDXCUsername: TLabeledEdit;
    txtDXCPort: TLabeledEdit;
    txtStationCallsign: TLabeledEdit;
    spSpotMaxNumber: TSpinEdit;
    txtDXCHost: TComboBox;
    chkAllowSpotSelect: TCheckBox;
    chkDXCAutoConnect: TCheckBox;
    Label8: TLabel;
    Label5: TLabel;
    colBoxScale: TColorBox;
    TabGeneralOptions: TTabSheet;
    GroupBox4: TGroupBox;
    cbOmniRigEnabled: TCheckBox;
    radGrpRigNum: TRadioGroup;
    cbSetSpotFrequencyToTRX: TCheckBox;
    Panel1: TPanel;
    Label7: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label9: TLabel;
    colBoxCATFreqColor: TColorBox;
    Label12: TLabel;
    Label13: TLabel;
    GroupBox5: TGroupBox;
    cbHiRes: TCheckBox;
    cboxSpotSelectBgColor: TColorBox;
    cbAdditionalInfoFromCall: TCheckBox;
    FileOpenDialog1: TFileOpenDialog;
    SpeedButton1: TSpeedButton;
    txtPathToPrefixLst: TEdit;
    Label14: TLabel;
    cbSetCallsignToAALog: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure txtDXCPortKeyPress(Sender: TObject; var Key: Char);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure spSpotMaxNumberChange(Sender: TObject);
    procedure cbAALogIntegrationEnabledClick(Sender: TObject);
    procedure cbOwnSpotColorizeClick(Sender: TObject);
    procedure cbSpotMouseMoveColorizeClick(Sender: TObject);
    procedure cbSpotInLogClick(Sender: TObject);
    procedure colBoxMainFreqPanelChange(Sender: TObject);
    procedure btnDefaultFreqPanColorClick(Sender: TObject);
    procedure btnGreennyFreqPanColorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure chkAllowSpotSelectClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure colBoxScaleChange(Sender: TObject);
    procedure cbHiResClick(Sender: TObject);
    procedure cbOmniRigEnabledClick(Sender: TObject);
    procedure radGrpRigNumClick(Sender: TObject);
    procedure ParamsChangeEvent(Sender: TObject; RigNumber, Params: Integer);
    procedure RigTypeChangeEvent(Sender: TObject; RigNumber: Integer);
    procedure StatusChangeEvent(Sender: TObject; RigNumber: Integer);
    procedure setRigNumber(RigNum: Integer);
    procedure KillRigControl;
    procedure CreateRigControl();
    procedure setTRXFrequency(freqToSet : string);
    procedure UpdateUIValues();
    procedure cbAdditionalInfoFromCallClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure createPrefixLstParser();
    procedure cbSetCallsignToAALogClick(Sender: TObject);
  private
    OmniRig: TOmniRigX;
    ActiveRigNumber: Integer;

    { Private declarations }
  public
    maxSpotsNumber : integer;
    currentOmniRigFreq : integer;
    currentOmniRigFreqTxt : string;

    { Public declarations }
  end;

var
  settingsForm : TsettingsForm;
     currentOmniRigFreq : integer;
     currentOmniRigFreqTxt : string;
     currentOmniRigType : string;
     currentOmniRigStatus : string;
     currentOmniRigStatusBarTxt : string;

implementation

uses Unit1, IdGlobal;

{$R *.dfm}


procedure TsettingsForm.setRigNumber(RigNum : integer);
begin
ActiveRigNumber := RigNum;
End;

procedure TsettingsForm.KillRigControl;
begin
  try
    currentOmniRigFreq := 0;
    currentOmniRigFreqTxt := '0';
    currentOmniRigStatusBarTxt := 'TRX: disconnected';
    currentOmniRigType := 'None';
    currentOmniRigStatus := '---';
    OmniRig.Disconnect;
    FreeAndNil(OmniRig);
  except end;
End;

procedure TsettingsForm.UpdateUIValues();
begin
FrequencyVisualForm.StatusBar1.Panels[3].Text := currentOmniRigStatusBarTxt;
FrequencyVisualForm.frequencyPaintBox.Refresh;
DebugOutput('UpdateUIValues called');
End;


function ModeName(Mode: integer): string;
begin
  case Mode of
    PM_CW_U,
    PM_CW_L:   Result := 'CW';
    PM_SSB_U:  Result := 'USB';
    PM_SSB_L:  Result := 'LSB';
    PM_DIG_U,
    PM_DIG_L:  Result := 'DIG';
    PM_AM:     Result := 'AM';
    PM_FM:     Result := 'FM';
    else       Result := 'Unknown';
    end;
End;

procedure TsettingsForm.ParamsChangeEvent(Sender: TObject; RigNumber, Params: Integer);
begin
  if OmniRig = nil then Exit;

  if RigNumber = ActiveRigNumber then begin
    case ActiveRigNumber of
      1:
        if OmniRig.Rig1.Status = ST_ONLINE then begin
            currentOmniRigFreq := OmniRig.Rig1.GetRxFrequency;
            currentOmniRigFreqTxt := FloatToStrF(currentOmniRigFreq/1000, ffFixed, 9, 2);
            currentOmniRigStatusBarTxt := 'TRX #1: '+OmniRig.Rig1.RigType+', '+ModeName(OmniRig.Rig1.Mode)+' - '+currentOmniRigFreqTxt;
        end else begin
            currentOmniRigFreq := 0;
            currentOmniRigFreqTxt := '0';
            currentOmniRigStatusBarTxt := 'TRX #1: (' +OmniRig.Rig1.RigType+'): '+ OmniRig.Rig1.StatusStr;
        end;

      2:
        if OmniRig.Rig2.Status = ST_ONLINE then begin
            currentOmniRigFreq := OmniRig.Rig2.GetRxFrequency;
            currentOmniRigFreqTxt := FloatToStrF(currentOmniRigFreq/1000, ffFixed, 9, 2);
            currentOmniRigStatusBarTxt := 'TRX #2: '+OmniRig.Rig2.RigType+', '+ModeName(OmniRig.Rig2.Mode)+' - '+currentOmniRigFreqTxt;
            //DebugOutput('Status updated: '+currentOmniRigStatusBarTxt);
        end else begin
            currentOmniRigFreq := 0;
            currentOmniRigFreqTxt := '0';
            currentOmniRigStatusBarTxt := 'TRX #2 (' +OmniRig.Rig2.RigType+'): '+ OmniRig.Rig2.StatusStr;
        end;
    end;
    UpdateUIValues();
    end;
End;


procedure TsettingsForm.RigTypeChangeEvent(Sender: TObject; RigNumber: Integer);
begin
  if OmniRig = nil then Exit;

  //display the radio model
  if RigNumber = ActiveRigNumber then
    case ActiveRigNumber of
      1: currentOmniRigType := OmniRig.Rig1.RigType;
      2: currentOmniRigType := OmniRig.Rig2.RigType;
    end;
    Label9.Caption := currentOmniRigType;

End;

procedure TsettingsForm.StatusChangeEvent(Sender: TObject; RigNumber: Integer);
begin
  if OmniRig = nil then Exit;

  //display the status string
  if RigNumber = ActiveRigNumber then
    case ActiveRigNumber of
      1: currentOmniRigStatus := OmniRig.Rig1.StatusStr;
      2: currentOmniRigStatus := OmniRig.Rig2.StatusStr;
    end;
    Label11.Caption := currentOmniRigStatus;

End;

procedure TsettingsForm.CreateRigControl();
begin
  OmniRig := TOmniRigX.Create(settingsForm);
  try
    OmniRig.Connect;
    OmniRig.OnRigTypeChange := RigTypeChangeEvent;
    OmniRig.OnStatusChange := StatusChangeEvent;
    OmniRig.OnParamsChange := ParamsChangeEvent;

    //Check OmniRig version: in this demo we want V.1.1 to 1.99
    if OmniRig.InterfaceVersion < $0101 then Abort;
    if OmniRig.InterfaceVersion > $0199 then Abort;

    //show rig type, current status, and parameters
    RigTypeChangeEvent(nil, ActiveRigNumber);
    StatusChangeEvent(nil, ActiveRigNumber);
    ParamsChangeEvent(nil, ActiveRigNumber, 0);
  except
    KillRigControl();
    DebugOutput('Unable to create the Omnirig object');
  end;
End;

procedure TsettingsForm.setTRXFrequency(freqToSet : string);
var
freq : integer;
begin
DebugOutput('Set simplex mode called:' + IntToStr(freq));
freq := trunc(StrToFloat(freqToSet)*1000);

  if (OmniRig = nil) or ((OmniRig.Rig1.Status <> ST_ONLINE) AND (OmniRig.Rig2.Status <> ST_ONLINE)) then Exit;
  case ActiveRigNumber of
    1:
      if OmniRig.Rig1.Status = ST_ONLINE then begin
        OmniRig.Rig1.SetSimplexMode(freq);
      end;

    2:
      if OmniRig.Rig2.Status = ST_ONLINE then begin
        OmniRig.Rig2.SetSimplexMode(freq);
      end;
    end;

    currentOmniRigFreq := freq;
    currentOmniRigFreqTxt := freqToSet;

    UpdateUIValues();
End;

procedure TsettingsForm.createPrefixLstParser();
begin
  try
    frequencyVisualForm.createCallParser(txtPathToPrefixLst.Text);
    Label14.Caption := 'Prefix.lst file is valid';
    Label14.Font.Color := clGreen;
  except
    Label14.Caption := 'Valid Prefix.lst file is needed';
    Label14.Font.Color := clRed;
  end;
End;

procedure TsettingsForm.SpeedButton1Click(Sender: TObject);
begin
if FileOpenDialog1.Execute then begin
  txtPathToPrefixLst.Text := FileOpenDialog1.FileName;
  createPrefixLstParser();
end;
End;

procedure TsettingsForm.radGrpRigNumClick(Sender: TObject);
begin
if (OmniRig <> nil) then begin
  ActiveRigNumber := radGrpRigNum.ItemIndex+1;
  RigTypeChangeEvent(nil, ActiveRigNumber);
  ParamsChangeEvent(nil, ActiveRigNumber, 0);
  StatusChangeEvent(nil, ActiveRigNumber);
end;
End;


procedure TsettingsForm.chkAllowSpotSelectClick(Sender: TObject);
begin
if not settingsForm.chkAllowSpotSelect.Checked then
  if lastSelectedSpotLabel <> nil then
    lastSelectedSpotLabel.selected := false;

if (chkAllowSpotSelect.Checked) then
  FrequencyVisualForm.frequencyPaintBox.Hint := 'Left click - select spot, Right click - deselect spot.'+#10#13+'Shift+Left click - spot down, Shift+Right - up. Alt+Click - delete spot. Ctrl + Click - additional menu.';

end;

procedure TsettingsForm.btnCloseClick(Sender: TObject);
begin
settingsForm.Close;
End;

procedure TsettingsForm.btnDefaultFreqPanColorClick(Sender: TObject);
begin
colBoxMainFreqPanel.Selected := $00471B15;
colBoxMainFreqPanelChange(self);
end;

procedure TsettingsForm.btnGreennyFreqPanColorClick(Sender: TObject);
begin
colBoxMainFreqPanel.Selected := $00404000;
colBoxMainFreqPanelChange(self);
end;

procedure TsettingsForm.btnSaveClick(Sender: TObject);
var
  iniFile : TIniFile;
begin
iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;

try
  with iniFile, settingsForm do begin
    WriteInteger('DXCluster', 'DXCPort', StrToInt(txtDXCPort.Text));
    WriteInteger('DXCluster', 'MaxSpots', spSpotMaxNumber.Value);
    WriteInteger('DXCluster', 'OwnSpotColor', colBoxOwnSpot.Selected);
    WriteInteger('DXCluster', 'MouseMoveSpotColor', colBoxSpotMouseMove.Selected);
    WriteInteger('DXCluster', 'EarlySpotColor', colBoxEarlySpot.Selected);
    WriteInteger('MainSettings', 'MainFreqPanColor', colBoxMainFreqPanel.Selected);
    WriteInteger('DXCluster', 'RegularSpotColor', colBoxRegularSpot.Selected);
    WriteInteger('MainSettings', 'ScaleColor', colBoxScale.Selected);
    WriteInteger('MainSettings', 'CATFreqColor', colBoxCATFreqColor.Selected);

    WriteString('DXCluster', 'DXCHost', txtDXCHost.Text);
    WriteString('DXCluster', 'DXCUsername', txtDXCUsername.Text);
    WriteString('DXCluster', 'StationCallsign', txtStationCallsign.Text);
    WriteString('DXCluster', 'AALogAddr', txtAalAddr.Text);
    WriteString('DXCluster', 'AALogPort', txtAalPort.Text);
    WriteString('MainSettings', 'PrefixLstPath', txtPathToPrefixLst.Text);

    WriteBool('MainSettings', 'ShowAdditionalInfo', cbAdditionalInfoFromCall.Checked);
    WriteBool('MainSettings', 'HighResScreen', cbHiRes.Checked);
    WriteBool('DXCluster', 'DXCAutoConnect', chkDXCAutoConnect.Checked);
    WriteBool('DXCluster', 'AALogIntegrationEnabled', cbAALogIntegrationEnabled.Checked);
    WriteBool('DXCluster', 'OwnSpotColorize', cbOwnSpotColorize.Checked);
    WriteBool('DXCluster', 'SpotMouseMoveColorize', cbSpotMouseMoveColorize.Checked);
    WriteBool('DXCluster', 'SpotInLogColorize', cbSpotInLog.Checked);
    WriteBool('DXCluster', 'SpotLotwEqslColorize', cbSpotLotwEqsl.Checked);
    WriteBool('DXCluster', 'EarlySpotColorize', cbEarlySpot.Checked);
    WriteBool('MainSettings', 'AllowSpotSelect', chkAllowSpotSelect.Checked);
    WriteBool('MainSettings', 'SendCallsignToAALog', cbSetCallsignToAALog.Checked);

    WriteBool('OmniRigSettings', 'Enabled', cbOmniRigEnabled.Checked);
    WriteBool('OmniRigSettings', 'SetSpotFrequencyToTRX', cbSetSpotFrequencyToTRX.Checked);
    WriteInteger('OmniRigSettings', 'ActiveNum', radGrpRigNum.ItemIndex);
  end;

  labSaveInfo.Visible := true;
  FrequencyVisualForm.btnDXCConnect.Hint := txtDXCHost.Text;
  Application.ProcessMessages;
  sleep(250);
finally
  iniFile.Free;
  labSaveInfo.Visible := false;
  settingsForm.Close;
  FrequencyVisualForm.stationCallsign := trim(txtStationCallsign.Text);
  maxSpotsNumber := spSpotMaxNumber.Value;
end;

End;

procedure TsettingsForm.Button1Click(Sender: TObject);
begin
colBoxMainFreqPanel.Selected := $004F4F4F;
colBoxMainFreqPanelChange(self);
end;

procedure TsettingsForm.Button2Click(Sender: TObject);
begin
colBoxMainFreqPanel.Selected := $00000000;
colBoxMainFreqPanelChange(self);
end;

procedure TsettingsForm.Button3Click(Sender: TObject);
begin
colBoxMainFreqPanel.Selected := $005B241C;
colBoxMainFreqPanelChange(self);
end;

procedure TsettingsForm.Button4Click(Sender: TObject);
begin
colBoxMainFreqPanel.Selected := $00000040;
colBoxMainFreqPanelChange(self);
end;

procedure TsettingsForm.cbAALogIntegrationEnabledClick(Sender: TObject);
begin
gbAALogIntegration.Enabled := cbAALogIntegrationEnabled.Checked;
txtAalAddr.Enabled := cbAALogIntegrationEnabled.Checked;
txtAalPort.Enabled := cbAALogIntegrationEnabled.Checked;
Label4.Enabled := cbAALogIntegrationEnabled.Checked;
cbSpotInLog.Enabled := cbAALogIntegrationEnabled.Checked;
cbSpotLotwEqsl.Enabled := cbAALogIntegrationEnabled.Checked;
colBoxSpotInLog.Enabled := cbAALogIntegrationEnabled.Checked;
cbSetCallsignToAALog.Enabled := cbAALogIntegrationEnabled.Checked;
FrequencyVisualForm.menuLabelRequestAALogData.Enabled := cbAALogIntegrationEnabled.Checked;
End;

procedure TsettingsForm.cbAdditionalInfoFromCallClick(Sender: TObject);
begin
txtPathToPrefixLst.Enabled := cbAdditionalInfoFromCall.Checked;
SpeedButton1.Enabled := cbAdditionalInfoFromCall.Checked;
End;

procedure TsettingsForm.cbHiResClick(Sender: TObject);
begin
if cbHiRes.Checked then begin
  spaceAdjustValue := 50;
  longLine := 39;
  shortLine := 26;
  freqMarkerFontSize := 9;
  textShiftValueHB := 27;
  textShiftValueLB := 19;

  textXPosDPICorr := 5;

  StartYPosDPICorr := 4;
  EndYPosDPICorr := 26;

  UnderFreqDPICorr := 1;
  PenWidthDPICorr := 3;
  frequencyVisualForm.frequencyPaintBoxTop.Height := 65;
end else begin
  spaceAdjustValue := 120;
  longLine := 24;
  shortLine := 14;
  freqMarkerFontSize := 8;
  textShiftValueHB := 13;
  textShiftValueLB := 8;

  textXPosDPICorr := 2;

  StartYPosDPICorr := 2;
  EndYPosDPICorr := 15;

  UnderFreqDPICorr := 1;
  PenWidthDPICorr := 1;
  frequencyVisualForm.frequencyPaintBoxTop.Height := 40;
end;

frequencyVisualForm.spacerScrollChange(FrequencyVisualForm);
end;

procedure TsettingsForm.cbOmniRigEnabledClick(Sender: TObject);
begin
GroupBox4.Enabled := cbOmniRigEnabled.Checked;
radGrpRigNum.Enabled := cbOmniRigEnabled.Checked;
Label7.Enabled := cbOmniRigEnabled.Checked;
Label9.Enabled := cbOmniRigEnabled.Checked;
Label10.Enabled := cbOmniRigEnabled.Checked;
Label11.Enabled := cbOmniRigEnabled.Checked;
cbSetSpotFrequencyToTRX.Enabled := cbOmniRigEnabled.Checked;
cbSetCallsignToAALog.Enabled := cbOmniRigEnabled.Checked;

if cbOmniRigEnabled.Checked then begin
  ActiveRigNumber := radGrpRigNum.ItemIndex+1;
  CreateRigControl();

end else begin

  if (OmniRig <> nil) then begin
    KillRigControl();
    FrequencyVisualForm.StatusBar1.Panels[3].Text := 'TRX: disconnected';
  end;
end;

radGrpRigNumClick(settingsForm);
end;

procedure TsettingsForm.cbOwnSpotColorizeClick(Sender: TObject);
begin
colBoxOwnSpot.Enabled := cbOwnSpotColorize.Checked;
End;

procedure TsettingsForm.cbSetCallsignToAALogClick(Sender: TObject);
begin
cbSetSpotFrequencyToTRX.Checked := false;
cbSetSpotFrequencyToTRX.Enabled := not cbSetCallsignToAALog.Checked;
End;

procedure TsettingsForm.cbSpotInLogClick(Sender: TObject);
begin
colBoxSpotInLog.Enabled := cbSpotInLog.Checked;
end;

procedure TsettingsForm.cbSpotMouseMoveColorizeClick(Sender: TObject);
begin
colBoxSpotMouseMove.Enabled := cbSpotMouseMoveColorize.Checked;
end;

procedure TsettingsForm.colBoxMainFreqPanelChange(Sender: TObject);
begin
//FrequencyVisualForm.Panel5.Color := colBoxMainFreqPanel.Selected;
FrequencyVisualForm.frequencyPaintBoxTop.Color := colBoxMainFreqPanel.Selected;
FrequencyVisualForm.frequencyPaintBox.Color := colBoxMainFreqPanel.Selected;
FrequencyVisualForm.TransparentColorValue := colBoxMainFreqPanel.Selected;
End;

procedure TsettingsForm.colBoxScaleChange(Sender: TObject);
begin
FrequencyVisualForm.frequencyPaintBoxTop.Refresh;
End;

procedure TsettingsForm.FormCreate(Sender: TObject);
var
iniFile : TIniFile;
begin
currentOmniRigFreq := 0;
currentOmniRigFreqTxt := '0';
iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
try
  with iniFile, settingsForm do begin
    spSpotMaxNumber.Value := ReadInteger('DXCluster', 'MaxSpots', 200);
    txtAalAddr.Text := ReadString('DXCluster', 'AALogAddr', '127.0.0.1');
    txtDXCHost.Text := ReadString('DXCluster', 'DXCHost', 'dxc.kfrr.kz');
    txtDXCUsername.Text := ReadString('DXCluster', 'DXCUsername', '');
    txtStationCallsign.Text := ReadString('DXCluster', 'StationCallsign', '');
    txtPathToPrefixLst.Text := ReadString('MainSettings', 'PrefixLstPath', '');

    chkDXCAutoConnect.Checked := ReadBool('DXCluster', 'DXCAutoConnect', false);
    cbOwnSpotColorize.Checked := ReadBool('DXCluster', 'OwnSpotColorize', true);
    cbSpotMouseMoveColorize.Checked := ReadBool('DXCluster', 'SpotMouseMoveColorize', true);
    cbAALogIntegrationEnabled.Checked := ReadBool('DXCluster', 'AALogIntegrationEnabled', false);
    cbEarlySpot.Checked := ReadBool('DXCluster', 'EarlySpotColorize', false);
    chkAllowSpotSelect.Checked := ReadBool('MainSettings', 'AllowSpotSelect', true);
    cbHiRes.Checked := ReadBool('MainSettings', 'HighResScreen', true);
    cbAdditionalInfoFromCall.Checked := ReadBool('MainSettings', 'ShowAdditionalInfo', false);
    cbSetCallsignToAALog.Checked := ReadBool('MainSettings', 'SendCallsignToAALog', false);

    cbOmniRigEnabled.Checked := ReadBool('OmniRigSettings', 'Enabled', false);
    radGrpRigNum.ItemIndex := ReadInteger('OmniRigSettings', 'ActiveNum', 0);
    cbSetSpotFrequencyToTRX.Checked := ReadBool('OmniRigSettings', 'SetSpotFrequencyToTRX', false);

    txtDXCPort.Text := IntToStr(ReadInteger('DXCluster', 'DXCPort', 8000));
    txtAalPort.Text := IntToStr(ReadInteger('DXCluster', 'AALogPort', 3541));
    colBoxOwnSpot.Selected := ReadInteger('DXCluster', 'OwnSpotColor', clYellow);
    colBoxSpotMouseMove.Selected := ReadInteger('DXCluster', 'MouseMoveSpotColor', clLime);
    colBoxEarlySpot.Selected := ReadInteger('DXCluster', 'EarlySpotColor', clRed);
    colBoxMainFreqPanel.Selected := ReadInteger('MainSettings', 'MainFreqPanColor', $00471B15);
    colBoxRegularSpot.Selected := ReadInteger('DXCluster', 'RegularSpotColor', clWhite);
    colBoxScale.Selected := ReadInteger('MainSettings', 'ScaleColor', clWhite);
    colBoxCATFreqColor.Selected := ReadInteger('MainSettings', 'CATFreqColor', clRed);
  end;

  colBoxMainFreqPanelChange(self);
  colBoxScaleChange(self);

  FrequencyVisualForm.btnDXCConnect.Hint := txtDXCHost.Text;
  FrequencyVisualForm.stationCallsign := trim(txtStationCallsign.Text);
  maxSpotsNumber := spSpotMaxNumber.Value;

  if FrequencyVisualForm.chkTransparentForm.Checked then
    FrequencyVisualForm.TransparentColorValue := colBoxMainFreqPanel.Selected;

  if chkDXCAutoConnect.Checked then
    FrequencyVisualForm.btnDXCConnect.OnClick(self);

  cbAALogIntegrationEnabledClick(self);
  chkAllowSpotSelectClick(self);

  FileOpenDialog1.DefaultFolder := ExtractFilePath(Application.ExeName);

  if Length(txtPathToPrefixLst.Text) < 5 then
    txtPathToPrefixLst.Text := ExtractFilePath(Application.ExeName)
  else
    createPrefixLstParser();

    cbHiResClick(self);
finally
  iniFile.Free;
end;
End;

procedure TsettingsForm.spSpotMaxNumberChange(Sender: TObject);
begin
maxSpotsNumber := spSpotMaxNumber.Value;
End;

procedure TsettingsForm.txtDXCPortKeyPress(Sender: TObject; var Key: Char);
begin
if not (Key in ['0'..'9', #8]) then Key:=#0;
End;

END.

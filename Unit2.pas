unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, inifiles, Vcl.Samples.Spin,
  Vcl.ActnMan, Vcl.ActnColorMaps, VCLTee.TeCanvas, Vcl.ComCtrls, OmniRig_TLB;

type
  TsettingsForm = class(TForm)
    btnSave: TButton;
    btnClose: TButton;
    labSaveInfo: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
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
    cbSendCallFreqToAALog: TCheckBox;
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
    TabSheet3: TTabSheet;
    cbHiRes: TCheckBox;
    GroupBox4: TGroupBox;
    cbOmniRigEnabled: TCheckBox;
    radGrpRigNum: TRadioGroup;
    cbSetSpotFrequencyToTRX: TCheckBox;
    Panel1: TPanel;
    Label7: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label9: TLabel;
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
  private
    procedure CreateRigControl(RigNumber: Integer);
    procedure KillRigControl;
    { Private declarations }
  public
    maxSpotsNumber : integer;
    currentOmniRigFreq : integer;
    currentOmniRigFreqTxt : string;
    OmniRig: TOmniRigX;

    procedure ParamsChangeEvent(Sender: TObject; RigNumber, Params: Integer);
    procedure RigTypeChangeEvent(Sender: TObject; RigNumber: Integer);
    procedure StatusChangeEvent(Sender: TObject; RigNumber: Integer);
    procedure setTRXFrequency(freqToSet : string);
    { Public declarations }
  end;

var
  settingsForm : TsettingsForm;

implementation

uses Unit1;

{$R *.dfm}

procedure TsettingsForm.setTRXFrequency(freqToSet : string);
var
freq : integer;
begin
freq := trunc(StrToFloat(freqToSet)*1000);

  if (OmniRig = nil) or (OmniRig.Rig2.Status <> ST_ONLINE) then Exit;
  case radGrpRigNum.ItemIndex+1 of
    1:
      if OmniRig.Rig1.Status = ST_ONLINE then begin
        OmniRig.Rig1.SetSimplexMode(freq);
      end;

    2:
      if OmniRig.Rig2.Status = ST_ONLINE then begin
        OmniRig.Rig2.SetSimplexMode(freq);
      end;
    end;
End;

procedure TsettingsForm.chkAllowSpotSelectClick(Sender: TObject);
begin
if not settingsForm.chkAllowSpotSelect.Checked then
  if lastSelectedSpotLabel <> nil then
    lastSelectedSpotLabel.selected := false;
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

    WriteString('DXCluster', 'DXCHost', txtDXCHost.Text);
    WriteString('DXCluster', 'DXCUsername', txtDXCUsername.Text);
    WriteString('DXCluster', 'StationCallsign', txtStationCallsign.Text);
    WriteString('DXCluster', 'AALogAddr', txtAalAddr.Text);
    WriteString('DXCluster', 'AALogPort', txtAalPort.Text);

    WriteBool('MainSettings', 'HighResScreen', cbHiRes.Checked);
    WriteBool('DXCluster', 'SendSpotDataToAALog', cbSendCallFreqToAALog.Checked);
    WriteBool('DXCluster', 'DXCAutoConnect', chkDXCAutoConnect.Checked);
    WriteBool('DXCluster', 'AALogIntegrationEnabled', cbAALogIntegrationEnabled.Checked);
    WriteBool('DXCluster', 'OwnSpotColorize', cbOwnSpotColorize.Checked);
    WriteBool('DXCluster', 'SpotMouseMoveColorize', cbSpotMouseMoveColorize.Checked);
    WriteBool('DXCluster', 'SpotInLogColorize', cbSpotInLog.Checked);
    WriteBool('DXCluster', 'SpotLotwEqslColorize', cbSpotLotwEqsl.Checked);
    WriteBool('DXCluster', 'EarlySpotColorize', cbEarlySpot.Checked);
    WriteBool('MainSettings', 'AllowSpotSelect', chkAllowSpotSelect.Checked);
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
cbSendCallFreqToAALog.Enabled := cbAALogIntegrationEnabled.Checked;
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
  frequencyVisualForm.frequencyPaintBoxTop.Height := 55;
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

radGrpRigNumClick(settingsForm);
end;

procedure TsettingsForm.cbOwnSpotColorizeClick(Sender: TObject);
begin
colBoxOwnSpot.Enabled := cbOwnSpotColorize.Checked;
End;

procedure TsettingsForm.cbSpotInLogClick(Sender: TObject);
begin
colBoxSpotInLog.Enabled := cbSpotInLog.Checked;
end;

procedure TsettingsForm.cbSpotMouseMoveColorizeClick(Sender: TObject);
begin
colBoxSpotMouseMove.Enabled := cbSpotMouseMoveColorize.Checked;
end;

procedure TsettingsForm.KillRigControl;
begin
  try
    currentOmniRigFreq := 0;
    currentOmniRigFreqTxt := '0';
    FreeAndNil(OmniRig);
  except end;
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
end;


//------------------------------------------------------------------------------
//                         OmniRig event handling
//------------------------------------------------------------------------------
procedure TsettingsForm.ParamsChangeEvent(Sender: TObject; RigNumber, Params: Integer);
begin
  if OmniRig = nil then Exit;

  case RigNumber of
    1:
      if OmniRig.Rig1.Status = ST_ONLINE then begin
//        Label9.Caption := IntToStr(OmniRig.Rig1.GetRxFrequency);
          currentOmniRigFreq := OmniRig.Rig1.GetRxFrequency;
          currentOmniRigFreqTxt := FloatToStrF(currentOmniRigFreq/1000, ffFixed,9,2);
          FrequencyVisualForm.StatusBar1.Panels[3].Text := 'TRX: '+OmniRig.Rig1.RigType+', '+ModeName(OmniRig.Rig1.Mode)+', '+currentOmniRigFreqTxt;
          FrequencyVisualForm.frequencyPaintBox.Refresh;
//        Label11.Caption := ModeName(OmniRig.Rig1.Mode);
      end;

    2:
      if OmniRig.Rig2.Status = ST_ONLINE then begin
//        Label9.Caption := IntToStr(OmniRig.Rig2.GetRxFrequency);
          currentOmniRigFreq := OmniRig.Rig2.GetRxFrequency;
          currentOmniRigFreqTxt := FloatToStrF(currentOmniRigFreq/1000, ffFixed,9,2);
          FrequencyVisualForm.StatusBar1.Panels[3].Text := 'TRX: '+OmniRig.Rig2.RigType+', '+ModeName(OmniRig.Rig2.Mode)+', '+currentOmniRigFreqTxt;
          FrequencyVisualForm.frequencyPaintBox.Refresh;
//        Label11.Caption := ModeName(OmniRig.Rig2.Mode);
      end;
    end;
End;

procedure TsettingsForm.radGrpRigNumClick(Sender: TObject);
begin
try KillRigControl(); except end;
CreateRigControl(radGrpRigNum.ItemIndex+1);
End;

procedure TsettingsForm.RigTypeChangeEvent(Sender: TObject; RigNumber: Integer);
begin
  if OmniRig = nil then Exit;

  //display the radio model
  case RigNumber of
    1: Label9.Caption := OmniRig.Rig1.RigType;
    2: Label9.Caption := OmniRig.Rig2.RigType;
    end;
End;

procedure TsettingsForm.StatusChangeEvent(Sender: TObject; RigNumber: Integer);
begin
  if OmniRig = nil then Exit;

  //display the status string
  case RigNumber of
    1: Label11.Caption := OmniRig.Rig1.StatusStr;
    2: Label11.Caption := OmniRig.Rig2.StatusStr;
    end;
End;

procedure TsettingsForm.CreateRigControl(RigNumber: Integer);
begin
  //create and configure the OmniRig object
  OmniRig := TOmniRigX.Create(Self);
  try
    OmniRig.Connect;
    //listen to OmniRig events
    OmniRig.OnRigTypeChange := RigTypeChangeEvent;
    OmniRig.OnStatusChange := StatusChangeEvent;
    OmniRig.OnParamsChange := ParamsChangeEvent;

    //Check OmniRig version: in this demo we want V.1.1 to 1.99
    if OmniRig.InterfaceVersion < $0101 then Abort;
    if OmniRig.InterfaceVersion > $0199 then Abort;

    //show rig type, current status, and parameters
    RigTypeChangeEvent(nil, RigNumber);
    StatusChangeEvent(nil, RigNumber);
    ParamsChangeEvent(nil, RigNumber, 0);
  except
    KillRigControl;
    MessageDlg('Unable to create the Omnirig object', mtError, [mbOk], 0);
  end;
End;

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

    chkDXCAutoConnect.Checked := ReadBool('DXCluster', 'DXCAutoConnect', false);
    cbOwnSpotColorize.Checked := ReadBool('DXCluster', 'OwnSpotColorize', true);
    cbSpotMouseMoveColorize.Checked := ReadBool('DXCluster', 'SpotMouseMoveColorize', true);
    cbAALogIntegrationEnabled.Checked := ReadBool('DXCluster', 'AALogIntegrationEnabled', false);
    cbEarlySpot.Checked := ReadBool('DXCluster', 'EarlySpotColorize', false);
    chkAllowSpotSelect.Checked := ReadBool('MainSettings', 'AllowSpotSelect', true);
    cbSendCallFreqToAALog.Checked := ReadBool('MainSettings', 'SendSpotDataToAALog', true);
    cbHiRes.Checked := ReadBool('MainSettings', 'HighResScreen', true);

    txtDXCPort.Text := IntToStr(ReadInteger('DXCluster', 'DXCPort', 8000));
    txtAalPort.Text := IntToStr(ReadInteger('DXCluster', 'AALogPort', 3541));
    colBoxOwnSpot.Selected := ReadInteger('DXCluster', 'OwnSpotColor', clYellow);
    colBoxSpotMouseMove.Selected := ReadInteger('DXCluster', 'MouseMoveSpotColor', clLime);
    colBoxEarlySpot.Selected := ReadInteger('DXCluster', 'EarlySpotColor', clRed);
    colBoxMainFreqPanel.Selected := ReadInteger('MainSettings', 'MainFreqPanColor', $00471B15);
    colBoxRegularSpot.Selected := ReadInteger('DXCluster', 'RegularSpotColor', clWhite);
    colBoxScale.Selected := ReadInteger('MainSettings', 'ScaleColor', clWhite);
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

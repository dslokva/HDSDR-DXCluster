unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, inifiles, Vcl.Samples.Spin,
  Vcl.ActnMan, Vcl.ActnColorMaps, VCLTee.TeCanvas;

type
  TsettingsForm = class(TForm)
    btnSave: TButton;
    btnClose: TButton;
    GroupBox1: TGroupBox;
    txtDXCUsername: TLabeledEdit;
    txtDXCPort: TLabeledEdit;
    chkDXCAutoConnect: TCheckBox;
    txtStationCallsign: TLabeledEdit;
    Label2: TLabel;
    spSpotMaxNumber: TSpinEdit;
    Label3: TLabel;
    txtDXCHost: TComboBox;
    gbAALogIntegration: TGroupBox;
    txtAalAddr: TLabeledEdit;
    txtAalPort: TLabeledEdit;
    cbAALogIntegrationEnabled: TCheckBox;
    GroupBox2: TGroupBox;
    cbOwnSpotColorize: TCheckBox;
    colBoxOwnSpot: TColorBox;
    colBoxSpotMouseMove: TColorBox;
    cbSpotMouseMoveColorize: TCheckBox;
    cbSpotInLog: TCheckBox;
    colBoxSpotInLog: TColorBox;
    cbSpotLotwEqsl: TCheckBox;
    cbEarlySpot: TCheckBox;
    colBoxEarlySpot: TColorBox;
    colBoxMainFreqPanel: TColorBox;
    Label1: TLabel;
    Label4: TLabel;
    btnDefaultFreqPanColor: TButton;
    btnGreennyFreqPanColor: TButton;
    Label5: TLabel;
    labSaveInfo: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
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
  private
    { Private declarations }
  public
    { Public declarations }
    maxSpotsNumber : integer;
  end;

var
  settingsForm : TsettingsForm;


implementation

uses Unit1;

{$R *.dfm}

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
    WriteInteger('DXCluster', 'MainFreqPanColor', colBoxMainFreqPanel.Selected);
    WriteString('DXCluster', 'DXCHost', txtDXCHost.Text);
    WriteString('DXCluster', 'DXCUsername', txtDXCUsername.Text);
    WriteString('DXCluster', 'StationCallsign', txtStationCallsign.Text);
    WriteString('DXCluster', 'AALogAddr', txtAalAddr.Text);
    WriteString('DXCluster', 'AALogPort', txtAalPort.Text);
    WriteBool('DXCluster', 'DXCAutoConnect', chkDXCAutoConnect.Checked);
    WriteBool('DXCluster', 'AALogIntegrationEnabled', cbAALogIntegrationEnabled.Checked);
    WriteBool('DXCluster', 'OwnSpotColorize', cbOwnSpotColorize.Checked);
    WriteBool('DXCluster', 'SpotMouseMoveColorize', cbSpotMouseMoveColorize.Checked);
    WriteBool('DXCluster', 'SpotInLogColorize', cbSpotInLog.Checked);
    WriteBool('DXCluster', 'SpotLotwEqslColorize', cbSpotLotwEqsl.Checked);
    WriteBool('DXCluster', 'EarlySpotColorize', cbEarlySpot.Checked);
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

procedure TsettingsForm.cbAALogIntegrationEnabledClick(Sender: TObject);
begin
gbAALogIntegration.Enabled := cbAALogIntegrationEnabled.Checked;
txtAalAddr.Enabled := cbAALogIntegrationEnabled.Checked;
txtAalPort.Enabled := cbAALogIntegrationEnabled.Checked;
Label4.Enabled := cbAALogIntegrationEnabled.Checked;
cbSpotInLog.Enabled := cbAALogIntegrationEnabled.Checked;
cbSpotLotwEqsl.Enabled := cbAALogIntegrationEnabled.Checked;
colBoxSpotInLog.Enabled := cbAALogIntegrationEnabled.Checked;
End;

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

procedure TsettingsForm.colBoxMainFreqPanelChange(Sender: TObject);
begin
FrequencyVisualForm.frequencyPaintBox.Color := colBoxMainFreqPanel.Selected;
end;

procedure TsettingsForm.FormCreate(Sender: TObject);
var
iniFile : TIniFile;
begin
iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
try
  with iniFile, settingsForm do begin
    txtDXCPort.Text := IntToStr(ReadInteger('DXCluster', 'DXCPort', 8000));
    txtAalPort.Text := IntToStr(ReadInteger('DXCluster', 'AALogPort', 3541));
    spSpotMaxNumber.Value := ReadInteger('DXCluster', 'MaxSpots', 250);
    txtAalAddr.Text := ReadString('DXCluster', 'AALogAddr', '127.0.0.1');
    txtDXCHost.Text := ReadString('DXCluster', 'DXCHost', 'dxc.kfrr.kz');
    txtDXCUsername.Text := ReadString('DXCluster', 'DXCUsername', '');
    txtStationCallsign.Text := ReadString('DXCluster', 'StationCallsign', '');
    chkDXCAutoConnect.Checked := ReadBool('DXCluster', 'DXCAutoConnect', false);
    cbOwnSpotColorize.Checked := ReadBool('DXCluster', 'OwnSpotColorize', true);
    cbSpotMouseMoveColorize.Checked := ReadBool('DXCluster', 'SpotMouseMoveColorize', true);
    cbAALogIntegrationEnabled.Checked := ReadBool('DXCluster', 'AALogIntegrationEnabled', false);
    cbEarlySpot.Checked := ReadBool('DXCluster', 'EarlySpotColorize', false);
    colBoxOwnSpot.Selected := ReadInteger('DXCluster', 'OwnSpotColor', clYellow);
    colBoxSpotMouseMove.Selected := ReadInteger('DXCluster', 'MouseMoveSpotColor', clLime);
    colBoxEarlySpot.Selected := ReadInteger('DXCluster', 'EarlySpotColor', clRed);
    colBoxMainFreqPanel.Selected := ReadInteger('DXCluster', 'MainFreqPanColor', $00471B15);
    colBoxMainFreqPanelChange(self);
  end;
  FrequencyVisualForm.btnDXCConnect.Hint := txtDXCHost.Text;
  FrequencyVisualForm.stationCallsign := trim(txtStationCallsign.Text);
  maxSpotsNumber := spSpotMaxNumber.Value;
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

unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, inifiles, Vcl.Samples.Spin;

type
  TsettingsForm = class(TForm)
    btnSave: TButton;
    btnClose: TButton;
    GroupBox1: TGroupBox;
    txtDXCUsername: TLabeledEdit;
    txtDXCPort: TLabeledEdit;
    chkDXCAutoConnect: TCheckBox;
    labSaveInfo: TLabel;
    txtStationCallsign: TLabeledEdit;
    Label2: TLabel;
    spSpotMaxNumber: TSpinEdit;
    Label3: TLabel;
    txtDXCHost: TComboBox;
    gbAALogIntegration: TGroupBox;
    txtAalAddr: TLabeledEdit;
    txtAalPort: TLabeledEdit;
    cbAALogIntegrationEnabled: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure txtDXCPortKeyPress(Sender: TObject; var Key: Char);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure spSpotMaxNumberChange(Sender: TObject);
    procedure cbAALogIntegrationEnabledClick(Sender: TObject);
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

procedure TsettingsForm.btnSaveClick(Sender: TObject);
var
  iniFile : TIniFile;
begin
iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;

try
  with iniFile, settingsForm do begin
    WriteInteger('DXCluster', 'DXCPort', StrToInt(txtDXCPort.Text));
    WriteInteger('DXCluster', 'MaxSpots', spSpotMaxNumber.Value);
    WriteString('DXCluster', 'DXCHost', txtDXCHost.Text);
    WriteString('DXCluster', 'DXCUsername', txtDXCUsername.Text);
    WriteString('DXCluster', 'StationCallsign', txtStationCallsign.Text);
    WriteString('DXCluster', 'AALogAddr', txtAalAddr.Text);
    WriteString('DXCluster', 'AALogPort', txtAalPort.Text);
    WriteBool('DXCluster', 'DXCAutoConnect', chkDXCAutoConnect.Checked);
    WriteBool('DXCluster', 'AALogIntegrationEnabled', cbAALogIntegrationEnabled.Checked);
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

procedure TsettingsForm.cbAALogIntegrationEnabledClick(Sender: TObject);
begin
gbAALogIntegration.Enabled := cbAALogIntegrationEnabled.Checked;
txtAalAddr.Enabled := cbAALogIntegrationEnabled.Checked;
txtAalPort.Enabled := cbAALogIntegrationEnabled.Checked;
End;

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
    cbAALogIntegrationEnabled.Checked := ReadBool('DXCluster', 'AALogIntegrationEnabled', false);
  end;
  FrequencyVisualForm.btnDXCConnect.Hint := txtDXCHost.Text;
  FrequencyVisualForm.stationCallsign := trim(txtStationCallsign.Text);
  maxSpotsNumber := spSpotMaxNumber.Value;
  if chkDXCAutoConnect.Checked then
    FrequencyVisualForm.btnDXCConnect.OnClick(self);

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

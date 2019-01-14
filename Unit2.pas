unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, inifiles;

type
  TsettingsForm = class(TForm)
    btnSave: TButton;
    btnClose: TButton;
    GroupBox1: TGroupBox;
    txtDXCUsername: TLabeledEdit;
    txtDXCHost: TLabeledEdit;
    txtDXCPort: TLabeledEdit;
    chkDXCAutoConnect: TCheckBox;
    labSaveInfo: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure txtDXCPortKeyPress(Sender: TObject; var Key: Char);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  settingsForm: TsettingsForm;


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
    WriteString('DXCluster', 'DXCHost', txtDXCHost.Text);
    WriteString('DXCluster', 'DXCUsername', txtDXCUsername.Text);
    WriteBool('DXCluster', 'DXCAutoConnect', chkDXCAutoConnect.Checked);
  end;
  labSaveInfo.Visible := true;
  FrequencyVisualForm.btnDXCConnect.Hint := txtDXCHost.Text;
  Application.ProcessMessages;
  sleep(250);
finally
  iniFile.Free;
  labSaveInfo.Visible := false;
  settingsForm.Close;
end;

End;

procedure TsettingsForm.FormCreate(Sender: TObject);
var
iniFile : TIniFile;
begin
iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
try
  with iniFile, settingsForm do begin
    txtDXCPort.Text := IntToStr(ReadInteger('DXCluster', 'DXCPort', 8000));
    txtDXCHost.Text := ReadString('DXCluster', 'DXCHost', 'dxc.kfrr.kz');
    txtDXCUsername.Text := ReadString('DXCluster', 'DXCUsername', '');
    chkDXCAutoConnect.Checked := ReadBool('DXCluster', 'DXCAutoConnect', false);
  end;
  FrequencyVisualForm.btnDXCConnect.Hint := txtDXCHost.Text;
  if chkDXCAutoConnect.Checked then
    FrequencyVisualForm.btnDXCConnect.OnClick(self);

finally
  iniFile.Free;
end;
End;

procedure TsettingsForm.txtDXCPortKeyPress(Sender: TObject; var Key: Char);
begin
if not (Key in ['0'..'9', #8]) then Key:=#0;

End;

END.

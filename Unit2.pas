unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TsettingsForm = class(TForm)
    btnSave: TButton;
    btnClose: TButton;
    GroupBox1: TGroupBox;
    txtDXCUsername: TLabeledEdit;
    txtDXCHost: TLabeledEdit;
    txtDXCPort: TLabeledEdit;
    chkDXCAutoConnect: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure txtDXCPortKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  settingsForm: TsettingsForm;

implementation

{$R *.dfm}

procedure TsettingsForm.btnCloseClick(Sender: TObject);
begin
settingsForm.Close;
End;

procedure TsettingsForm.txtDXCPortKeyPress(Sender: TObject; var Key: Char);
begin
if not (Key in ['0'..'9', #8]) then Key:=#0;

End;

END.

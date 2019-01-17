program HDSDRHelper;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {FrequencyVisualForm},
  RegExpr in 'RegExpr.pas',
  Unit2 in 'Unit2.pas' {settingsForm},
  Unit3 in 'Unit3.pas' {dxcViewForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'HDSDR-DXCluster ';
  Application.CreateForm(TFrequencyVisualForm, FrequencyVisualForm);
  Application.CreateForm(TsettingsForm, settingsForm);
  Application.CreateForm(TdxcViewForm, dxcViewForm);
  Application.Run;
end.

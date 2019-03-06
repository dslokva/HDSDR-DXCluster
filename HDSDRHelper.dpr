program HDSDRHelper;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {FrequencyVisualForm},
  RegExpr in 'RegExpr.pas',
  Unit2 in 'Unit2.pas' {settingsForm},
  Unit3 in 'Unit3.pas' {dxcViewForm},
  SpotLabel in 'SpotLabel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'HDSDR-DXCluster ';
  Application.HintPause := 250;    // 250 mSec before hint is shown
  Application.HintHidePause := 8000; // hint disappears after 3 secs
  Application.CreateForm(TFrequencyVisualForm, FrequencyVisualForm);
  Application.CreateForm(TsettingsForm, settingsForm);
  Application.CreateForm(TdxcViewForm, dxcViewForm);
  Application.Run;
end.

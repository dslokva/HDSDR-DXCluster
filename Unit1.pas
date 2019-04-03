  unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, JSons, uLkJSON, IdURI, SpotLabel,
  Vcl.ButtonGroup, Vcl.WinXCtrls, IdBaseComponent, IdComponent, IdTCPConnection, UDPServerJSONObjects,
  IdTCPClient, IdTelnet, RegExpr, IdGlobal, System.Generics.Collections, IdUDPClient, DateUtils, Math,
  Vcl.Buttons, inifiles, Vcl.Menus, IdUDPBase, IdUDPServer, IdSocketHandle, Winapi.ShellAPI, AALogClientJSONObjects,
  Vcl.ComCtrls;

type
  TSpot = class(TObject)
    DX: String;
    DE: String;
    Comment: String;
    Freq: variant;
    UTCTime: TDateTime;
    LocalTime: TDateTime;
    spotLabel : TSpotLabel;
  end;

type
  TAppender<T> = class
    class procedure Append(var Arr: TArray<T>; Value: T);
  end;

type
  TFrequencyVisualForm = class(TForm)
    Panel1: TPanel;
    Panel5: TPanel;
    frequencyPaintBox: TPaintBox;
    Panel3: TPanel;
    Panel4: TPanel;
    Label4: TLabel;
    spacerScroll: TScrollBar;
    IdTelnet1: TIdTelnet;
    labLabelsRefresh: TLabel;
    freqPanelMenu: TPopupMenu;
    isPanelHoldActive: TMenuItem;
    Panel7: TPanel;
    labPanelMode: TLabel;
    spotLabelMenu : TPopupMenu;
    Viewonqrzcom1: TMenuItem;
    Viewonqrzru1: TMenuItem;
    refreshLabelColorTimer: TTimer;
    menuLabelOnHold: TMenuItem;
    StatusBar1: TStatusBar;
    Panel6: TPanel;
    Label2: TLabel;
    Panel2: TPanel;
    Panel8: TPanel;
    btnSpotClearBand: TButton;
    btnSpotClearAll: TButton;
    Button3: TButton;
    btnDXCConnect: TButton;
    bandSwitcher: TRadioGroup;
    chkStayOnTop: TCheckBox;
    Button2: TButton;
    Bevel1: TBevel;
    Button1: TButton;
    spotCountResetTimer: TTimer;
    statusRefreshTimer: TTimer;
    chkTransparentForm: TCheckBox;
    labelSpotHint: TLabel;
    frequencyPaintBoxTop: TPaintBox;
    Panel9: TPanel;
    lbSpotTotal: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure frequencyPaintBoxPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkStayOnTopClick(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spacerScrollChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure bandSwitcherClick(Sender: TObject);
    procedure Panel4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure frequencyPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure frequencyPaintBoxMouseLeave(Sender: TObject);
    procedure btnDXCConnectClick(Sender: TObject);
    procedure IdTelnet1Connected(Sender: TObject);
    procedure IdTelnet1Disconnected(Sender: TObject);
    procedure IdTelnet1DataAvailable(Sender: TIdTelnet; const Buffer: TIdBytes);
    procedure Label2DblClick(Sender: TObject);
    procedure btnSpotClearAllClick(Sender: TObject);
    procedure btnSpotClearBandClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure isPanelHoldActiveClick(Sender: TObject);
    procedure frequencyPaintBoxContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure labPanelModeDblClick(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Viewonqrzcom1Click(Sender: TObject);
    procedure Viewonqrzru1Click(Sender: TObject);
    procedure refreshLabelColorTimerTimer(Sender: TObject);
    procedure menuLabelOnHoldClick(Sender: TObject);
    procedure spotLabelMenuPopup(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Panel8MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StatusBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spotCountResetTimerTimer(Sender: TObject);
    procedure statusRefreshTimerTimer(Sender: TObject);

    procedure chkTransparentFormClick(Sender: TObject);
    procedure frequencyPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure frequencyPaintBoxTopPaint(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    procedure SpotLabelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    function Get15MinSpotCountApprox : variant;
    procedure RefreshLineSpacer();
    procedure AddFrequencyPosition(textXPos : integer; freqValue : variant);
    procedure AllowDrag;
    procedure SpotLabelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SpotLabelMouseEnter(Sender: TObject);
    procedure SpotLabelMouseLeave(Sender: TObject);
    procedure SpotLabelContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure setFreqStartAndMode();
    procedure refreshSelectedBandEdges();
    procedure RemoveSelectedSpot(dx : string);
    function GetSpotBySelectedLabel(dx : string) : TSpot;
    procedure DeleteFirstSpot();
    procedure UpdateCallsignDetailsTable(answerData : TlkJSONobject; spotLabel : TSpotLabel);
    procedure MyShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure ColorizeSpotLabel(spotLabel: TSpotLabel);
    procedure ReColorizeAllLabels();
    procedure ChandeBandPosition(freqShift : integer);
    { Private declarations }

  public
    stationCallsign : string;
    function getSpotList() : TList<TPair<variant, TArray<TSpot>>>;
    function getSpotTotalCount() : Integer;
    function getSpotMaxCount() : Integer;
    function CheckSpotListContainsKey(spotFreq : variant) : boolean;
    function GetSpotArrayFromList(spotFreq : variant) : TArray<TSpot>;
    procedure updateSpotListArray(spotFreq : variant; spotArray : TArray<TSpot>);
    procedure setFreqAddKhz(addKhz : variant);
    procedure RepaintFrequencySpan(showLabels : boolean);
    { Public declarations }

  end;

   TRequestThread = class(TThread)
   private
    var
      answerStr : string;
      UDPRequestStr : string;
      UDPSrvHost : string;
      UDPSrvPort : TIdPort;
      IdUDPClient : TIdUDPClient;
      corrSpotLabel : TSpotLabel;

   public
     constructor Create(requestStr, udpHost : string; udpPort : TIdPort; spotLabelIn : TSpotLabel);

   protected
     procedure ProcessAnswerJSON();
     procedure Execute; override;
   end;

var
  FrequencyVisualForm : TFrequencyVisualForm;

  spaceAdjustValue, lineSpacer, boxWidth : integer;
  freqShifter, freqStart, freqAddKhz : variant;
  freqBandStart, freqBandEnd : variant;
  Xold : Integer;
  regExp : TRegExpr;
  spotList : TList<TPair<variant, TArray<TSpot>>>;
  spotBandCount : integer;
  regex1, regex2, freqText : string;
  longLine, shortLine, freqMarkerFontSize, textShiftValueLB, textShiftValueHB : integer;
  textXPosDPICorr, StartYPosDPICorr, EndYPosDPICorr, UnderFreqDPICorr, PenWidthDPICorr : integer;
  notNeedToShowPopupForFreqPanel, notNeedToShowPopupForSpotLabel : boolean;
  callsingDataFromAALog: TDictionary<String, TSimpleCallsignAnswer>;
  spotHintOldX, spotHintOldY : integer;            //while mousemove
  lastSelectedSpotLabel : TSpotLabel;
  frequencyPositionArr : array[0..8] of variant;   //shift value for store start frequency offset
  oldSpotCount : integer;
  spotCountMinuteRate : integer;
  spotCount15MinutesRateList : TList<integer>;
  showLabelsDuringPaint : boolean;

implementation

{$R *.dfm}

uses Unit2, Unit3;

constructor TRequestThread.Create(requestStr, udpHost : string; udpPort : TIdPort; spotLabelIn : TSpotLabel);
begin
  UDPSrvHost := udpHost;
  UDPSrvPort := udpPort;
  UDPRequestStr := requestStr;
  corrSpotLabel := spotLabelIn;

  inherited Create(true);
End;

procedure TFrequencyVisualForm.setFreqAddKhz(addKhz : variant);
begin
freqAddKhz := addKhz;
End;

function TFrequencyVisualForm.getSpotTotalCount() : Integer;
var
i, count : integer;
spotArray : TArray<TSpot>;

begin
count := 0;

for i := 0 to spotList.Count-1 do begin
  spotArray := spotList.Items[i].Value;
  count := count + high(spotArray) + 1;
end;
result := count;
End;

procedure TFrequencyVisualForm.menuLabelOnHoldClick(Sender: TObject);
begin

menuLabelOnHold.Checked := not menuLabelOnHold.Checked;
TSpotLabel(spotLabelMenu.PopupComponent).onHold := menuLabelOnHold.Checked;

End;

function TFrequencyVisualForm.getSpotMaxCount() : Integer;
begin
  result := settingsForm.maxSpotsNumber;
End;


procedure TFrequencyVisualForm.isPanelHoldActiveClick(Sender: TObject);
begin
if isPanelHoldActive.Checked then begin
  labPanelMode.Caption := 'Hold active';
  labPanelMode.Font.Style := [fsBold];
end else begin
  labPanelMode.Caption := 'Normal mode';
  labPanelMode.Font.Style := [];
end;

End;

function TFrequencyVisualForm.getSpotList() : TList<TPair<variant, TArray<TSpot>>>;
begin
result := spotList;
end;

procedure HideLabels(isAllLabels : boolean);
var
j, i : integer;
spotArray : TArray<TSpot>;

begin
for j := 0 to spotList.Count-1 do begin
  spotArray := spotList.Items[j].Value;
  if ((spotList.Items[j].Key >= freqBandStart) and (spotList.Items[j].Key <= freqBandEnd)) or (isAllLabels) then
  for i := low(spotArray) to high(spotArray) do
    spotArray[i].spotLabel.Visible := false;
end;

End;

procedure DestroyAllLabels();
var
j, i : integer;
spotArray : TArray<TSpot>;

begin
for j := 0 to spotList.Count-1 do begin
  spotArray := spotList.Items[j].Value;
  for i := low(spotArray) to high(spotArray) do
     spotArray[i].spotLabel.Destroy;
end;

End;

function CheckHexForHash(col: string):string;
begin
    if col[1] = '#' then
        col := StringReplace(col,'#','',[rfReplaceAll]);
    result := col;
end;

function ConvertHtmlHexToTColor(Color: String):TColor ;
var
    rColor : TColor;
begin
    Color := CheckHexForHash(Color);

    if (length(color) = 6) then begin
      {remember that TColor is bgr not rgb: so you need to switch then around}
      color := '$00' + copy(color,5,2) + copy(color,3,2) + copy(color,1,2);
      rColor := StrToInt(color);
    end;

    result := rColor;
End;

procedure FormWithoutCaption(Form: TForm);
var
FSizeCaption: Integer;
begin
  with Form do begin
    FSizeCaption := GetSystemMetrics(SM_CYCAPTION);
    SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_Style) and not WS_Caption);
    Height := Height - FSizeCaption;
  end;
End;

procedure TFrequencyVisualForm.MyShowHint(var HintStr: string; var CanShow: Boolean;  var HintInfo: THintInfo);
var
  i: integer;
begin
  for I := 0 to Application.ComponentCount-1 do begin
    if Application.Components[0] is THintWindow then begin
      with THintWindow(Application.Components[0]) do begin
        Canvas.Font.Name := 'Tahoma';
        Canvas.Font.Size := 10;
//        Canvas.Font.Charset := RUSSIAN_CHARSET;
        Canvas.Font.Style := [];
        Canvas.Brush.Color := clCream;
      end;
    end;
  end;
end;

procedure TFrequencyVisualForm.SpotLabelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
var
i,j : integer;
spotHintPoint : TPoint;
spotLabel : TSpotLabel;
spotSecDiff : Integer;
newHintStr, spotAge, spotHold : string;
spotAALogData : TSimpleCallsignAnswer;
begin

if (spotHintOldX <> X) or (spotHintOldY <> Y) then begin
  spotLabel := TSpotLabel(Sender);
  newHintStr := spotLabel.Hint;
  spotHold := '';
  if spotLabel.onHold then
    spotHold := #10#13 + '---holded---';

  spotSecDiff := SecondsBetween(now, spotLabel.receiveTime);
  spotAge := Format('%2.2d:%2.2d:%2.2d',[spotSecDiff div SecsPerHour,(spotSecDiff div SecsPerMin) mod SecsPerMin, spotSecDiff mod SecsPerMin]);
  labelSpotHint.Caption := ' '+spotLabel.Hint;

    if (settingsForm.cbAALogIntegrationEnabled.Checked) and (callsingDataFromAALog.ContainsKey(spotLabel.Caption)) then begin
        spotAALogData := callsingDataFromAALog.Items[spotLabel.Caption];

        newHintStr := ' '+newHintStr + #10#13 + ' Spot age: ' + spotAge + spotHold + #13#13 + ' From AALog: ' + #13;

        if (spotAALogData.hamName <> '') then
          newHintStr := newHintStr + ' Name: ' + (spotAALogData.hamName) + #13;
        if (spotAALogData.hamQTH <> '') then
            newHintStr := newHintStr + ' QTH: ' + (spotAALogData.hamQTH) + #13;

         newHintStr := newHintStr + ' InLog: '+spotAALogData.presentInLog + ', LoTW: '+spotAALogData.isLoTWUser + ', EQSL.cc: '+spotAALogData.isEqslUser + ' ';
    end else begin
      //todo: new request try from AALog
      newHintStr := ' '+newHintStr + #10#13 + ' Spot age: ' + spotAge + spotHold;
    end;

  spotHintPoint := TPoint.Create(spotLabel.Left+X, spotLabel.Top+Y);
  spotHintOldX := X;
  spotHintOldY := Y;
  labelSpotHint.Caption := newHintStr;
  labelSpotHint.Width := labelSpotHint.Width + 3;
  labelSpotHint.Top := spotLabel.Top + 30 + Y;

  if spotLabel.Left+spotLabel.Width+labelSpotHint.Width < frequencyPaintBox.Width then
    labelSpotHint.Left := spotLabel.Left + 25 + X
  else
    labelSpotHint.Left := spotLabel.Left - labelSpotHint.Width + X;

  labelSpotHint.Visible := true;
end;

End;

procedure TFrequencyVisualForm.SpotLabelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
spotLabel : TSpotLabel;
spot : TSpot;

begin
//Tag value is used for vertical alignment of spotLabels
spotLabel := TSpotLabel(Sender);

if Button = mbLeft then begin
  if (ssAlt in Shift) and (spotLabel.onHold = false) then
    RemoveSelectedSpot(spotLabel.Caption);
  if ssShift in Shift then
    TLabel(Sender).Tag := TLabel(Sender).Tag + 1
  else begin
    //label selected

    if (lastSelectedSpotLabel.Caption <> TSpotLabel(Sender).Caption) then begin
      if lastSelectedSpotLabel <> nil then
        lastSelectedSpotLabel.selected := false;
      TSpotLabel(Sender).selected := true;
    end else
      TSpotLabel(Sender).selected := not TSpotLabel(Sender).selected;

    lastSelectedSpotLabel := TSpotLabel(Sender);
  end;

  if settingsForm.cbOmniRigEnabled.Checked and settingsForm.cbSetSpotFrequencyToTRX.Checked then begin
    spot := GetSpotBySelectedLabel(lastSelectedSpotLabel.Caption);
    if spot <> nil then
      settingsForm.setTRXFrequency(spot.Freq);
  end;
end;

if Button = mbRight then begin
  if ssCtrl in Shift then
    notNeedToShowPopupForSpotLabel := false;

  if ssShift in Shift then begin
    notNeedToShowPopupForSpotLabel := true;
    notNeedToShowPopupForFreqPanel := true;
    if TLabel(Sender).Top >= longLine+UnderFreqDPICorr+EndYPosDPICorr then
      TLabel(Sender).Tag := TLabel(Sender).Tag - 1;
  end;

end;

//HideLabels(false);
RepaintFrequencySpan(true);
End;

procedure TFrequencyVisualForm.StatusBar1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  AllowDrag;
end;

function TFrequencyVisualForm.Get15MinSpotCountApprox : variant;
var
  i, sum : integer;
begin
sum := 0;

for i := 0 to spotCount15MinutesRateList.Count-1 do
  sum := sum + spotCount15MinutesRateList[i];

if (sum = 0) or (spotCount15MinutesRateList.Count = 0) then begin
  result := 0;
  exit;
end;

result := sum / spotCount15MinutesRateList.Count;
end;

procedure TFrequencyVisualForm.statusRefreshTimerTimer(Sender: TObject);
var
spotRateCalc : string;
begin
if not IdTelnet1.Connected then
  spotRateCalc := 'none'
else begin

  spotRateCalc := 'operating normal';
  if Get15MinSpotCountApprox > 10 then
    spotRateCalc := 'income spot rate increased! Don''t forget to hold intresting spots!';

end;

StatusBar1.Panels[2].Text := 'Last status: ' + spotRateCalc + ' (' + IntToStr(Get15MinSpotCountApprox)+ ' spots per min)';

end;

procedure TFrequencyVisualForm.SpotLabelMouseEnter(Sender: TObject);
begin
if (settingsForm.cbSpotMouseMoveColorize.Checked) then
  TSpotLabel(Sender).Font.Color := settingsForm.colBoxSpotMouseMove.Selected;
End;

procedure TFrequencyVisualForm.SpotLabelMouseLeave(Sender: TObject);
var
spotLabel : TSpotLabel;

begin
spotLabel := TSpotLabel(Sender);
ColorizeSpotLabel(spotLabel);

labelSpotHint.Visible := false;
End;

procedure TFrequencyVisualForm.chkStayOnTopClick(Sender: TObject);
begin
if chkStayOnTop.Checked then FrequencyVisualForm.FormStyle := fsStayOnTop
else FrequencyVisualForm.FormStyle := fsNormal;

End;

procedure TFrequencyVisualForm.chkTransparentFormClick(Sender: TObject);
begin
FrequencyVisualForm.TransparentColor := chkTransparentForm.Checked;
End;

procedure TFrequencyVisualForm.Createparams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := (Style or WS_POPUP) and (not WS_DLGFRAME);
End;


procedure TFrequencyVisualForm.RefreshLineSpacer();
begin
lineSpacer := spacerScroll.Position div spaceAdjustValue;
StatusBar1.Panels[1].Text := 'Scale factor: ' + IntToStr(lineSpacer);
End;

procedure TFrequencyVisualForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
iniFile : TIniFile;
begin
iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
try
  with iniFile, FrequencyVisualForm do begin
     WriteInteger('MainSettings', 'ScrollPosition', spacerScroll.Position);
     WriteInteger('MainSettings', 'SelectedBand', bandSwitcher.ItemIndex);

     WriteFloat('MainSettings', 'freqShift160', frequencyPositionArr[0]);
     WriteFloat('MainSettings', 'freqShift80', frequencyPositionArr[1]);
     WriteFloat('MainSettings', 'freqShift40', frequencyPositionArr[2]);
     WriteFloat('MainSettings', 'freqShift30', frequencyPositionArr[3]);
     WriteFloat('MainSettings', 'freqShift20', frequencyPositionArr[4]);
     WriteFloat('MainSettings', 'freqShift17', frequencyPositionArr[5]);
     WriteFloat('MainSettings', 'freqShift15', frequencyPositionArr[6]);
     WriteFloat('MainSettings', 'freqShift12', frequencyPositionArr[7]);
     WriteFloat('MainSettings', 'freqShift10', frequencyPositionArr[8]);

     WriteBool('MainSettings', 'PanelHoldActive', isPanelHoldActive.Checked);
     WriteBool('MainSettings', 'TransparentForm', chkTransparentForm.Checked);

     WriteInteger('Placement', 'MainFormTop', Top);
     WriteInteger('Placement', 'MainFormLeft', Left);
     WriteInteger('Placement', 'MainFormWidth', Width);
     WriteInteger('Placement', 'MainFormHeight', Height);
  end;
finally
  iniFile.Free;
end;

try
  IdTelnet1.Disconnect;
finally
  IdTelnet1.Free;
end;

End;

procedure TFrequencyVisualForm.FormCreate(Sender: TObject);
var
iniFile : TIniFile;

begin
// Initialize all nesessary things
frequencyPositionArr[0] := 0;
frequencyPositionArr[1] := 0;
frequencyPositionArr[2] := 0;
frequencyPositionArr[3] := 0;
frequencyPositionArr[4] := 0;
frequencyPositionArr[5] := 0;
frequencyPositionArr[6] := 0;
frequencyPositionArr[7] := 0;
frequencyPositionArr[8] := 0;

spaceAdjustValue := 50;
longLine := 39;
shortLine := 26;
freqMarkerFontSize := 9;
textShiftValueHB := 27;
textShiftValueLB := 19;
textXPosDPICorr := 5;
StartYPosDPICorr := 4;
EndYPosDPICorr := 25;
UnderFreqDPICorr := 28;
PenWidthDPICorr := 3;
RefreshLineSpacer();
freqAddKhz := 0.10;
freqStart := 3600.0;
Xold := 0;
spotBandCount := 0;
oldSpotCount := 0;

Panel5.ParentBackground := false;

regex1 := 'DX de\s([a-zA-Z0-9\\\/]+)\:?\s+([0-9.,]+)\s+([a-zA-Z0-9\\\/]+)\s(.*)?\s([0-9]{4})Z.*';
regex2 := '([0-9.,]+)\s+([a-zA-Z0-9\\\/]+)\s.*([0-9]{4})Z\s(.*)\s<([a-zA-Z0-9\\\/]+)\>';

spotList := TList<TPair<variant, TArray<TSpot>>>.Create();
callsingDataFromAALog := TDictionary<String, TSimpleCallsignAnswer>.Create;
spotCount15MinutesRateList := TList<integer>.Create();

notNeedToShowPopupForFreqPanel := false;
notNeedToShowPopupForSpotLabel := true;
lastSelectedSpotLabel := nil;

Application.OnShowHint := MyShowHint;
Application.HintColor := clCream;
labelSpotHint.Transparent := false;
labelSpotHint.Color := clCream;

showLabelsDuringPaint := false;

frequencyPaintBox.Color := $00471B15;
frequencyPaintBoxTop.Color := $00471B15;

iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
try
  with iniFile, FrequencyVisualForm do begin
    spacerScroll.Position := ReadInteger('MainSettings', 'ScrollPosition', 1070);
    bandSwitcher.ItemIndex := ReadInteger('MainSettings', 'SelectedBand', 0);

    isPanelHoldActive.Checked := ReadBool('MainSettings', 'PanelHoldActive', false);
    chkTransparentForm.Checked := ReadBool('MainSettings', 'TransparentForm', false);

    frequencyPositionArr[0] := ReadFloat('MainSettings', 'freqShift160', 0);
    frequencyPositionArr[1] := ReadFloat('MainSettings', 'freqShift80', 0);
    frequencyPositionArr[2] := ReadFloat('MainSettings', 'freqShift40', 0);
    frequencyPositionArr[3] := ReadFloat('MainSettings', 'freqShift30', 0);
    frequencyPositionArr[4] := ReadFloat('MainSettings', 'freqShift20', 0);
    frequencyPositionArr[5] := ReadFloat('MainSettings', 'freqShift17', 0);
    frequencyPositionArr[6] := ReadFloat('MainSettings', 'freqShift15', 0);
    frequencyPositionArr[7] := ReadFloat('MainSettings', 'freqShift12', 0);
    frequencyPositionArr[8] := ReadFloat('MainSettings', 'freqShift10', 0);

    Top := iniFile.ReadInteger('Placement','MainFormTop', 0);
    Left := iniFile.ReadInteger('Placement','MainFormLeft', 0);
    Width := iniFile.ReadInteger('Placement','MainFormWidth', 745);
    Height := iniFile.ReadInteger('Placement','MainFormHeight', 355);
  end;
finally
  iniFile.Free;
end;

if isPanelHoldActive.Checked then
  isPanelHoldActiveClick(FrequencyVisualForm);

if chkTransparentForm.Checked then
  chkTransparentFormClick(FrequencyVisualForm);

freqShifter := frequencyPositionArr[bandSwitcher.ItemIndex];

refreshSelectedBandEdges();
setFreqStartAndMode();

End;

procedure TFrequencyVisualForm.FormResize(Sender: TObject);
begin
boxWidth := frequencyPaintBox.Width-40;
End;

function FillJsonSimpleCallsignRequest(request : TSimpleCallsignRequest) : string;
var
  JsonRequest : TJson;
begin
try
//request #1 - check callsign existence in log
//  and   #2 - get QSO history for callsign with options (band, mode).
JsonRequest := TJson.Create();
JsonRequest.Put('requestType',  request.requestType);

with JsonRequest['requestData'].AsObject do begin
  Put('callsign', request.callsign);
  Put('band', request.band);
  Put('mode', request.mode);
  Put('dataLimit', request.dataLimit);
end;

//result - JSON string
result := JsonRequest.Stringify;
finally
//
end;
End;

function DateTimeToStrUs(dt: TDatetime): string;
var
    us: string;
begin
    //Spit out most of the result: '20160802 11:34:36.'
    Result := FormatDateTime('yyyymmdd hh":"nn":"ss"."', dt);

    //extract the number of microseconds
    dt := Frac(dt); //fractional part of day
    dt := dt * 24*60*60; //number of seconds in that day
    us := IntToStr(Round(Frac(dt)*1000000));

    //Add the us integer to the end:
    // '20160801 11:34:36.' + '00' + '123456'
    Result := Result + StringOfChar('0', 6-Length(us)) + us;
end;

procedure TRequestThread.Execute;
begin
try
  try
    IdUDPClient := TIdUDPClient.Create();
    IdUDPClient.Host := UDPSrvHost;
    IdUDPClient.Port := UDPSrvPort;
    IdUDPClient.Active := True;
    IdUDPClient.ReceiveTimeout := 7000;
    IdUDPClient.Connect;
    if IdUDPClient.Connected then begin
      randomize();
      sleep(random(200));
      IdUDPClient.Send(UDPRequestStr, IndyTextEncoding(encUTF8));
      answerStr := IdUDPClient.ReceiveString(IdTimeoutDefault, IndyTextEncoding(encOSDefault));
      //DebugOutput(answerStr);
    end;
  except
    on E: Exception do
      answerStr := '0';
  end;

finally
  if Length(answerStr) = 0 then answerStr := '0';
  Synchronize(ProcessAnswerJSON);
  //DebugOutput(DateTimeToStrUs(now) + ' - ' + answerStr);
  IdUDPClient.Active := False;
  IdUDPClient.Free;
end;
End;

procedure TRequestThread.ProcessAnswerJSON();
var
  JsonAnswer, jsData: TlkJSONobject;
  answerType : string;
begin
if answerStr = '0' then begin
  FrequencyVisualForm.ColorizeSpotLabel(corrSpotLabel);
  exit;
end;

JsonAnswer := TlkJSON.ParseText(answerStr) as TlkJSONobject;
answerType := (JsonAnswer.Field['answerType'] as TlkJSONstring).value;
jsData := JsonAnswer.Field['answerData'] as TlkJSONobject;

if (answerType = REQ_IS_IN_LOG) then
    frequencyVisualForm.UpdateCallsignDetailsTable(jsData, corrSpotLabel);

End;


procedure TFrequencyVisualForm.UpdateCallsignDetailsTable(answerData : TlkJSONobject; spotLabel : TSpotLabel);
var
  JsonAnswer : TlkJSONobject;
  isLoTWUser, isEqslUser, callsign, hamName, hamQTH : string;
   presentOnMode,  presentOnBand, presentInLog: string;
  answer : TSimpleCallsignAnswer;
begin
  callsign := (answerData.Field['callsign'] as TlkJSONstring).value;
  hamName := (answerData.Field['hamName'] as TlkJSONstring).value;
  hamQTH := (answerData.Field['hamQTH'] as TlkJSONstring).value;

  isLoTWUser := (answerData.Field['isLoTWUser'] as TlkJSONstring).value;
  isEqslUser := (answerData.Field['isEqslUser'] as TlkJSONstring).value;
  presentInLog := (answerData.Field['presentInLog'] as TlkJSONstring).value;
  presentOnBand := (answerData.Field['presentOnBand'] as TlkJSONstring).value;
  presentOnMode := (answerData.Field['presentOnMode'] as TlkJSONstring).value;

  answer := TSimpleCallsignAnswer.Create(callsign, hamName, hamQTH, isLoTWUser[1], isEqslUser[1], presentOnBand[1], presentOnMode[1], presentInLog[1]);
  if (isLoTWUser = '1') or (isEqslUser = '1') then begin
    spotLabel.isLotwEqsl := true;
   // spotLabel.Font.Style := [fsUnderline];
   // variant #1, second - simple dash line under label, that will be draw during label placement
  end;

  if presentInLog = '1' then
    spotLabel.isInLog := true;

  ColorizeSpotLabel(spotLabel);

  if not(callsingDataFromAALog.ContainsKey(callsign)) then
    callsingDataFromAALog.Add(callsign, answer);
End;


procedure SendRequestToAALog(requestStr, udpHost : string; udpPort : TIdPort; spotLabelIn : TSpotLabel);
var
  requestThread: TRequestThread;
begin
  requestThread := TRequestThread.Create(requestStr, udpHost, udpPort, spotLabelIn);
  requestThread.FreeOnTerminate := true;
  requestThread.Resume;
End;

procedure TFrequencyVisualForm.IdTelnet1Connected(Sender: TObject);
begin
StatusBar1.Panels[0].Text := 'DXCluster: connected to "' + settingsForm.txtDXCHost.Text + '", at: '+ TimeToStr(now);
//StatusBar1.Panels[0].Font.Color := clGreen;
btnDXCConnect.Caption := 'Disconnect DXC';
spotCountMinuteRate := 0;
End;

function LocalDateTimeFromUTCDateTime(const UTCDateTime: TDateTime): TDateTime;
var
  LocalSystemTime: TSystemTime;
  UTCSystemTime: TSystemTime;
  LocalFileTime: TFileTime;
  UTCFileTime: TFileTime;
begin
  DateTimeToSystemTime(UTCDateTime, UTCSystemTime);
  SystemTimeToFileTime(UTCSystemTime, UTCFileTime);
  if FileTimeToLocalFileTime(UTCFileTime, LocalFileTime)
  and FileTimeToSystemTime(LocalFileTime, LocalSystemTime) then begin
    Result := SystemTimeToDateTime(LocalSystemTime);
  end else begin
    Result := UTCDateTime;  // Default to UTC if any conversion function fails.
  end;
End;

class procedure TAppender<T>.Append;
begin
  SetLength(Arr, Length(Arr)+1);
  Arr[High(Arr)] := Value;
End;

procedure TFrequencyVisualForm.IdTelnet1Disconnected(Sender: TObject);
begin
if FrequencyVisualForm.Visible then begin
  StatusBar1.Panels[0].Text := 'DXCluster: disconnected at ' + TimeToStr(now);
  //dxcStatusLabel.Font.Color := clRed;
  btnDXCConnect.Caption := 'Connect to DXC';
end;

End;

procedure TFrequencyVisualForm.Label4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  AllowDrag;
End;

procedure TFrequencyVisualForm.Label2DblClick(Sender: TObject);
begin
if IdTelnet1.Connected then
  IdTelnet1.SendString('SH/DX 50'+CR)
end;

procedure TFrequencyVisualForm.setFreqStartAndMode();
begin
case frequencyVisualForm.bandSwitcher.ItemIndex of
 0: begin
   freqStart := 1810.00;
   freqText := '160m';
 end;
 1: begin
    freqStart := 3500.00;
    freqText := '80m';
 end;
 2: begin
    freqStart := 7000.00;
    freqText := '40m';
 end;
 3: begin
    freqStart := 10100.00;
    freqText := '30m';
 end;
 4: begin
    freqStart := 14000.00;
    freqText := '20m';
 end;
 5: begin
    freqStart := 18068.00;
    freqText := '17m';
 end;
 6: begin
    freqStart := 21100.00;
    freqText := '15m';
 end;
 7: begin
    freqStart := 24890.00;
    freqText := '12m';
 end;
 8: begin
    freqStart := 28000.00;
    freqText := '10m';
 end;
end;

End;

procedure TFrequencyVisualForm.bandSwitcherClick(Sender: TObject);
begin
  //todo: make boundaries while tuning
ChandeBandPosition(frequencyPositionArr[bandSwitcher.ItemIndex]);
End;

procedure TFrequencyVisualForm.Button1Click(Sender: TObject);
begin
FrequencyVisualForm.Close;
end;

procedure TFrequencyVisualForm.Button2Click(Sender: TObject);
begin
settingsForm.Show;
End;

procedure TFrequencyVisualForm.Button3Click(Sender: TObject);
begin
dxcViewForm.Show;
dxcViewForm.btnRefreshClick(self);
End;

procedure TFrequencyVisualForm.btnDXCConnectClick(Sender: TObject);
var
dxcAddress, dxcUsername : string;
dxcPort : integer;

begin
try
dxcAddress := trim(settingsForm.txtDXCHost.Text);
dxcPort :=  StrToInt(trim(settingsForm.txtDXCPort.Text));
dxcUsername := trim(settingsForm.txtDXCUsername.Text);

if (Length(dxcAddress) < 7) or (Length(dxcUsername) < 4)  or (dxcPort < 1000) or (dxcPort > 65535) then begin
  StatusBar1.Panels[0].Text := 'DXCluster: please check telnet settings!';
  exit;
end;

IdTelnet1.Host := dxcAddress;
IdTelnet1.Port := dxcPort;

  if IdTelnet1.Connected then
    IdTelnet1.Disconnect
  else
    IdTelnet1.Connect;



except
  on E : Exception do begin
    StatusBar1.Panels[0].Text := 'DXCluster: error, ' + E.Message;
    StatusBar1.Panels[0].Text := 'DXCluster: disconnected at ' + TimeToStr(now);
   // dxcStatusLabel.Font.Color := clRed;
  end;
end;

End;

procedure TFrequencyVisualForm.btnSpotClearAllClick(Sender: TObject);
begin
//todo: onHold labels processing
DestroyAllLabels();
spotList.Clear;
callsingDataFromAALog.Clear;
spotBandCount := 0;
oldSpotCount := 0;
RepaintFrequencySpan(false);
End;

procedure TFrequencyVisualForm.refreshSelectedBandEdges();
begin
case bandSwitcher.ItemIndex of
 0: begin
      freqBandStart := 1810.00;
      freqBandEnd := 2000.00;
    end;
 1: begin
      freqBandStart := 3500.00;
      freqBandEnd := 3800.00;
    end;
 2: begin
      freqBandStart := 7000.00;
      freqBandEnd := 7200.00;
    end;
 3: begin
      freqBandStart := 10100.00;
      freqBandEnd := 10150.00;
    end;
 4: begin
      freqBandStart := 14000.00;
      freqBandEnd := 14350.00;
    end;
 5: begin
      freqBandStart := 18068.00;
      freqBandEnd := 18168.00;
    end;
 6: begin
      freqBandStart := 21000.00;
      freqBandEnd := 21450.00;
    end;
 7: begin
      freqBandStart := 24890.00;
      freqBandEnd := 24990.00;
    end;
 8: begin
      freqBandStart := 28000.00;
      freqBandEnd := 29700.00;
    end;
end;
End;

procedure TFrequencyVisualForm.refreshLabelColorTimerTimer(Sender: TObject);
begin
ReColorizeAllLabels();
End;

procedure DeleteElement(var anArray:TArray<TSpot>; const aPosition:integer);
var
   lg, j : integer;
begin
   lg := length(anArray);
   if aPosition > lg-1 then
     exit
   else if aPosition = lg-1 then begin //if is the last element
           //if TSomeType is a TObject descendant don't forget to free it
           //for example anArray[aPosition].free;
           Setlength(anArray, lg -1);
           exit;
        end;
   for j := aPosition to lg-2 do//we move all elements from aPosition+1 left...
     anArray[j] := anArray[j+1];//...with a position
   SetLength(anArray, lg-1);//now we have one element less
   //that's all...
End;

procedure TFrequencyVisualForm.btnSpotClearBandClick(Sender: TObject);
var
j, i : integer;
key : variant;
spotArray : TArray<TSpot>;
spotLabel : TSpotLabel;
labelHolded : boolean;

begin
refreshSelectedBandEdges();
//will remove all labels for selected band
for j := spotList.Count-1 downto 0 do begin
  key := spotList.Items[j].Key;
  if (key >= freqBandStart) and (key <= freqBandEnd) then begin
    spotArray := spotList.Items[j].Value;
    labelHolded := false;
    for i := low(spotArray) to high(spotArray) do begin
      if spotArray[i].spotLabel.onHold then
        labelHolded := true
      else
        spotArray[i].spotLabel.Destroy;
    end;
    //if any label on freq is onHold then don't touch the spot marker
    if not labelHolded then
      spotList.Delete(j);
  end;
end;

spotBandCount := 0;
HideLabels(false);
RepaintFrequencySpan(true);
End;

procedure TFrequencyVisualForm.RemoveSelectedSpot(dx : string);
var
j, i : integer;
key : variant;
spotArray : TArray<TSpot>;

begin
refreshSelectedBandEdges();
//will remove only one spot on band with caption = dx
for j := 0 to spotList.Count-1 do begin
  key := spotList.Items[j].Key;
  if (key >= freqBandStart) and (key <= freqBandEnd) then begin
    spotArray := spotList.Items[j].Value;
    for i := low(spotArray) to high(spotArray) do
      if spotArray[i].spotLabel.Caption = dx then begin
        spotArray[i].spotLabel.Destroy;
        if Length(spotArray) > 1 then begin
          DeleteElement(spotArray, i);
          spotList.Items[j] := TPair<variant, TArray<TSpot>>.Create(key, spotArray);
        end else
          spotList.Delete(j);
        exit;
      end;
  end;
end;

spotBandCount := spotBandCount-1;
HideLabels(false);
RepaintFrequencySpan(true);
End;

function TFrequencyVisualForm.GetSpotBySelectedLabel(dx : string) : TSpot;
var
j, i : integer;
key : variant;
spotArray : TArray<TSpot>;

begin
refreshSelectedBandEdges();
for j := 0 to spotList.Count-1 do begin
  key := spotList.Items[j].Key;
  if (key >= freqBandStart) and (key <= freqBandEnd) then begin
    spotArray := spotList.Items[j].Value;
    for i := low(spotArray) to high(spotArray) do
      if spotArray[i].spotLabel.Caption = dx then begin
        result := spotArray[i];
        exit;
      end;
  end;
end;

result := nil;
End;

procedure TFrequencyVisualForm.frequencyPaintBoxContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
if notNeedToShowPopupForFreqPanel then
   Handled := True;
end;

procedure TFrequencyVisualForm.spotLabelContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
if notNeedToShowPopupForSpotLabel then
   Handled := True;
end;



procedure TFrequencyVisualForm.spotLabelMenuPopup(Sender: TObject);
begin
menuLabelOnHold.Checked := TSpotLabel(spotLabelMenu.PopupComponent).onHold;
end;

function TFrequencyVisualForm.CheckSpotListContainsKey(spotFreq : variant) : boolean;
var
i,j : integer;
spotArray : TArray<TSpot>;

begin
result := false;
for j := 0 to spotList.Count-1 do begin
  spotArray := spotList.Items[j].Value;
  for i := low(spotArray) to high(spotArray) do
    if spotArray[i].Freq = spotFreq then begin
      result := true;
      exit;
    end;
end;
End;

function MoveDownByEdgeCheck(spotLabel : TSpotLabel) : boolean;
var
i, j, le, re, te : integer;
spotArray : TArray<TSpot>;
begin

for j := 0 to spotList.Count-1 do begin
  spotArray := spotList.Items[j].Value;
  for i := low(spotArray) to high(spotArray) do begin
    if (spotArray[i].Freq >= freqBandStart) and (spotArray[i].Freq <= freqBandEnd) and
       (spotArray[i].spotLabel.Caption <> spotLabel.Caption) then begin
      le := spotArray[i].spotLabel.Left - textXPosDPICorr;
      re := le+spotArray[i].spotLabel.Width + textXPosDPICorr;
      te := spotArray[i].spotLabel.Top;

      if ((spotLabel.Left >= le) and (spotLabel.Left <= re) and (spotLabel.Top = te)) or
      ((spotLabel.Left+spotLabel.Width >= le) and (spotLabel.Left+spotLabel.Width <= re) and (spotLabel.Top = te)) then begin
          spotLabel.Tag := spotLabel.Tag + 1;
          result := true;
          DebugOutput('label tag - '+IntToStr(spotLabel.Tag) + ', ' + spotLabel.Caption);
          exit;
      end;
    end;
  end;
end;
result := false;
End;

procedure TFrequencyVisualForm.AddFrequencyPosition(textXPos : integer; freqValue : variant);
var
spotArray : TArray<TSpot>;
spot : TSpot;
spotCount, YPos : integer;
spotLabel : TSpotLabel;
LogBrush: TLogBrush;
hBrush1 : HBRUSH;
rect : TRect;

begin
//Memo1.Lines.Add(IntToStr(textXPos) + ' - ' + FloatToStr(freqValue));

if CheckSpotListContainsKey(freqValue) then begin
//this is a main procedure that draw spots on frequency pane
//still very fragile for DPI and Scale options (((
//DebugOutput('freqStart: '+FloatToStr(freqValue));
  spotArray := GetSpotArrayFromList(freqValue);
  if spotArray <> nil then
    with frequencyPaintBox.Canvas do begin
      Font.Size := freqMarkerFontSize;
      Font.Color := clWhite;
      spotCount := 0;
      Pen.Color := clWhite;
      Pen.Width := PenWidthDPICorr;
      LogBrush.lbStyle := BS_SOLID;
      LogBrush.lbColor := clWhite;

      //don't touch digits formulas below! :)
      for spot in spotArray do begin
        spotLabel := spot.spotLabel;

        YPos := UnderFreqDPICorr+(EndYPosDPICorr*(spotCount+spotLabel.Tag));
        spotLabel.Top := frequencyPaintBoxTop.Height+YPos;

        if bandSwitcher.ItemIndex < 4 then begin
        //LSB items
          spotLabel.Left := textXPos-spotLabel.Width-textXPosDPICorr;
          if MoveDownByEdgeCheck(spotLabel) then begin
            YPos := UnderFreqDPICorr+(EndYPosDPICorr*(spotCount+spotLabel.Tag));
            spotLabel.Top := frequencyPaintBoxTop.Height+YPos;
          end;

          MoveTo(textXPos, YPos+StartYPosDPICorr);
          LineTo(textXPos, YPos+EndYPosDPICorr-2);
          //Draw dotted line if spot is LoTW or EQSL.cc user
          if (spotLabel.isLotwEqsl) and (settingsForm.cbSpotLotwEqsl.Checked) then begin
//            spotLabel.Font.Style := [fsBold] + [fsUnderline];
            Pen.Handle := ExtCreatePen(PS_GEOMETRIC or PS_DOT, PenWidthDPICorr, LogBrush, 0, nil);
            MoveTo(textXPos-spotLabel.Width-2, YPos+EndYPosDPICorr-1);
            LineTo(textXPos, YPos+EndYPosDPICorr-1);
            Pen.Handle := ExtCreatePen(BS_SOLID, PenWidthDPICorr, LogBrush, 0, nil);
          end;
          if (spotLabel.selected) and (settingsForm.chkAllowSpotSelect.Checked) then begin
            Pen.Handle := ExtCreatePen(PS_GEOMETRIC or PS_DOT, PenWidthDPICorr, LogBrush, 0, nil);

            //paint "selected" vertical line
//            MoveTo(textXPos-spotLabel.Width-textXPosDPICorr-4, longLine+UnderFreqDPICorr+2);
//            LineTo(textXPos-spotLabel.Width-textXPosDPICorr-4, frequencyPaintBox.Height-2);
            MoveTo(textXPos, UnderFreqDPICorr+2);
            LineTo(textXPos, frequencyPaintBox.Height-2);
            //crate inner rectangle
            rect := TRect.Create(textXPos-spotLabel.Width-textXPosDPICorr+2, YPos+UnderFreqDPICorr+14,
            textXPos+textXPosDPICorr-5, frequencyPaintBox.Height-2);

//            Brush.Style := bsDiagCross;
            Brush.Style := bsFDiagonal;
            Brush.Color := clWhite;
            SetBkColor(Handle, ColorToRGB(frequencyPaintBox.Color));
            FillRect(rect);

            //check if we need to fill rect on top of label
            if spotLabel.Tag > 0 then begin
              rect := TRect.Create(textXPos-spotLabel.Width-textXPosDPICorr+2, UnderFreqDPICorr+3,
              textXPos+textXPosDPICorr-5, YPos-StartYPosDPICorr+5);
              FillRect(rect);
            end;

            //return brush settings for other elements
            Brush.Style := bsSolid;
            Brush.Color := frequencyPaintBox.Color;
            Pen.Handle := ExtCreatePen(BS_SOLID, PenWidthDPICorr, LogBrush, 0, nil);
          end;

        end else begin
        //USB items
          spotLabel.Left := textXPos+textXPosDPICorr;
          if MoveDownByEdgeCheck(spotLabel) then begin
            YPos := UnderFreqDPICorr+(EndYPosDPICorr*(spotCount+spotLabel.Tag));
            spotLabel.Top := frequencyPaintBoxTop.Height+YPos;
          end;

          Pen.Width := PenWidthDPICorr;
          Pen.Color := clWhite;
          MoveTo(textXPos, YPos+StartYPosDPICorr);
          LineTo(textXPos, YPos+EndYPosDPICorr-2);
          //Draw dotted line if spot is LoTW or EQSL.cc user
          if (spotLabel.isLotwEqsl) and (settingsForm.cbSpotLotwEqsl.Checked) then begin
//            spotLabel.Font.Style := [fsBold] + [fsUnderline];
            Pen.Handle := ExtCreatePen(PS_GEOMETRIC or PS_DOT, PenWidthDPICorr, LogBrush, 0, nil);
            MoveTo(textXPos, YPos+EndYPosDPICorr-1);
            LineTo(textXPos+spotLabel.Width+2, YPos+EndYPosDPICorr-1);
            Pen.Handle := ExtCreatePen(BS_SOLID, PenWidthDPICorr, LogBrush, 0, nil);
          end;

          if (spotLabel.selected) and (settingsForm.chkAllowSpotSelect.Checked) then begin
            Pen.Handle := ExtCreatePen(PS_GEOMETRIC or PS_DOT, PenWidthDPICorr, LogBrush, 0, nil);
            //paint two vertical lines
//            MoveTo(textXPos+spotLabel.Width+textXPosDPICorr+4, longLine+UnderFreqDPICorr+2);
//            LineTo(textXPos+spotLabel.Width+textXPosDPICorr+4, frequencyPaintBox.Height-2);
            MoveTo(textXPos, UnderFreqDPICorr+2);
            LineTo(textXPos, frequencyPaintBox.Height-2);
            //crate inner rectangle
            rect := TRect.Create(textXPos-textXPosDPICorr+5, frequencyPaintBox.Height-2,
            textXPos+spotLabel.Width+textXPosDPICorr, YPos+UnderFreqDPICorr+14);

//            Brush.Style := bsDiagCross;
            Brush.Style := bsFDiagonal;
            Brush.Color := clWhite;
            SetBkColor(Handle, ColorToRGB(frequencyPaintBox.Color));
            FillRect(rect);

            //check if we need to fill rect on top of label
            if spotLabel.Tag > 0 then begin
              rect := TRect.Create(textXPos-textXPosDPICorr+5, UnderFreqDPICorr+3,
              textXPos+spotLabel.Width+textXPosDPICorr, YPos-StartYPosDPICorr+5);
              FillRect(rect);
            end;

            //return brush settings for other elements
            Brush.Style := bsSolid;
            Brush.Color := frequencyPaintBox.Color;
            Pen.Handle := ExtCreatePen(BS_SOLID, PenWidthDPICorr, LogBrush, 0, nil);
          end;

        end;
        spotLabel.Color := frequencyPaintBox.Color+2;
        spotLabel.Visible := true;
        inc(spotCount);
      end;
      Pen.Color := clWhite;
      Pen.Width := 1;//restore pen width for next lines of frequency scale markers
      spotBandCount := spotBandCount + spotCount;
    end;
end;

End;

procedure TFrequencyVisualForm.AllowDrag;
begin
  ReleaseCapture;
  SendMessage(FrequencyVisualForm.Handle, WM_SYSCOMMAND, 61458, 0);
End;

function FindCallInArray(spotArray : TArray<TSpot>; dx : string) : boolean;
var
i : integer;

begin
result := false;
for i := low(spotArray) to high(spotArray) do
  if spotArray[i].DX = dx then begin
    result := true;
    break;
  end;
End;

procedure TFrequencyVisualForm.deleteFirstSpot();
var
nextSpotElement, i : integer;
spotArray : TArray<TSpot>;
deleted : boolean;

begin
//most early spot - in begining of spotList
if (spotList.Count) = 0 then exit;
nextSpotElement := 0;
deleted := false;

while not deleted do begin
  spotArray := spotList.Items[nextSpotElement].Value;
  if Length(spotArray) = 1 then begin

    if not spotArray[nextSpotElement].spotLabel.onHold then begin
      spotArray[nextSpotElement].spotLabel.Destroy;
      DebugOutput('deleting spot :'+FloatToStr(spotList.Items[nextSpotElement].Key) + ' - ' + spotArray[nextSpotElement].DX + ' time: '+DateTimeToStr(spotArray[nextSpotElement].LocalTime));
      spotList.Delete(nextSpotElement);
      deleted := true;
      break;
    end else
      inc(nextSpotElement);

  end else begin

    for i := low(spotArray) to high(spotArray) do begin
      if not spotArray[i].spotLabel.onHold then begin
        spotArray[i].spotLabel.Destroy;
        DeleteElement(spotArray, i);
        spotList.Items[0] := TPair<variant, TArray<TSpot>>.Create(spotList.Items[0].Key, spotArray);
        deleted := true;
        inc(nextSpotElement);
        break;
      end else inc(nextSpotElement);
    end;

  end;
end;

End;

function TFrequencyVisualForm.GetSpotArrayFromList(spotFreq : variant) : TArray<TSpot>;
var
i : integer;
begin
result := nil;
for i := 0 to spotList.Count-1 do
  if spotList.Items[i].Key = spotFreq then begin
    result := spotList.Items[i].Value;
    break;
  end;

End;

procedure TFrequencyVisualForm.ChandeBandPosition(freqShift : integer);
begin
  setFreqStartAndMode;
  refreshSelectedBandEdges;
  freqShifter := freqShift;
  frequencyPositionArr[bandSwitcher.ItemIndex] := freqShift;
  HideLabels(true);
  RepaintFrequencySpan(true);
end;

procedure TFrequencyVisualForm.ReColorizeAllLabels();
var
j, i : integer;
spotArray : TArray<TSpot>;

begin
for j := 0 to spotList.Count-1 do begin
  spotArray := spotList.Items[j].Value;
  for i := low(spotArray) to high(spotArray) do
     ColorizeSpotLabel(spotArray[i].spotLabel);
end;

if spotList.Count > 0 then
  labLabelsRefresh.Caption := TimeToStr(now)
else
  labLabelsRefresh.Caption := 'none';

End;

procedure TFrequencyVisualForm.ColorizeSpotLabel(spotLabel: TSpotLabel);
begin
  if (spotLabel.isInLog) and (settingsForm.cbSpotInLog.Checked) then
    spotLabel.Font.Color := settingsForm.colBoxSpotInLog.Selected
  else if (SecondsBetween(now, spotLabel.receiveTime) < 180) and (settingsForm.cbEarlySpot.Checked) then
    spotLabel.Font.Color := settingsForm.colBoxEarlySpot.Selected
  else if (spotLabel.spotDE = stationCallsign) and (settingsForm.cbOwnSpotColorize.Checked) then
    spotLabel.Font.Color := settingsForm.colBoxOwnSpot.Selected
  else
    spotLabel.Font.Color := settingsForm.colBoxRegularSpot.Selected;
end;

procedure TFrequencyVisualForm.updateSpotListArray(spotFreq : variant; spotArray : TArray<TSpot>);
var
i : integer;
begin
for i := 0 to spotList.Count-1 do
  if spotList.Items[i].Key = spotFreq then begin
    spotList.Items[i] := TPair<variant, TArray<TSpot>>.Create(spotFreq, spotArray);
    break;
  end;
End;

procedure TFrequencyVisualForm.Viewonqrzcom1Click(Sender: TObject);
begin
ShellExecute(self.WindowHandle, 'open', PChar('https://www.qrz.com/lookup/'+TSpotLabel(spotLabelMenu.PopupComponent).Caption), nil, nil, SW_SHOWNORMAL);

End;

procedure TFrequencyVisualForm.Viewonqrzru1Click(Sender: TObject);
begin
ShellExecute(self.WindowHandle, 'open', PChar('https://www.qrz.ru/db/'+TSpotLabel(spotLabelMenu.PopupComponent).Caption), nil, nil, SW_SHOWNORMAL);

End;

function SystemTimeToUTC(Sys : TDateTime):TDateTime;
var TimeZoneInf : _TIME_ZONE_INFORMATION;
    SysTime,LocalTime: TSystemTime;
begin
  if GetTimeZoneInformation(TimeZoneInf) < $FFFFFFFF then
  begin
    DatetimetoSystemTime(Sys, SysTime);
    if TzSpecificLocalTimeToSystemTime(@TimeZoneInf,SysTime,LocalTime) then
      result:=SystemTimeToDateTime(LocalTime)
    else result:=Sys;
  end else result:=Sys;
end;

procedure TFrequencyVisualForm.IdTelnet1DataAvailable(Sender: TIdTelnet;
  const Buffer: TIdBytes);
var
Start, Stop : Integer;
spotFreqStr, incomeStr, hh, mm : string;
spot : TSpot;
localSpotArray : TArray<TSpot>;
fromDXCstr : string;
spotLabel : TSpotLabel;
request : TSimpleCallsignRequest;
requestStr : string;

begin
incomeStr := BytesToString(Buffer);
//Memo1.Lines.Add(' ') ; Start := 1;

if Stop = 0 then
  Stop := Pos(CR, incomeStr);

if Stop = 0 then
  Stop := Length(incomeStr) + 1;

while Start <= Length(incomeStr) do begin
  fromDXCstr := Copy(incomeStr, Start, Stop - Start);
  Start := Stop + 1;
  if Start > Length(incomeStr) then break;

  if incomeStr[Start] = LF then
    Start := Start + 1;
    Stop := Start;

  while (incomeStr[Stop] <> CR) and (Stop <= Length(incomeStr)) do
    Stop := Stop + 1;

   try
    regExp := TRegExpr.Create;
    regExp.ModifierM := true;

    //regular spot processing
    regExp.Expression := regex1;
    if regExp.Exec(fromDXCstr) then begin
        oldSpotCount := getSpotTotalCount();
        spotFreqStr := StringReplace(regExp.Match[2], '.', ',', [rfIgnoreCase, rfReplaceAll]);
        if StrToFloat(spotFreqStr) > 150001 then exit;

        spot := TSpot.Create;
        spot.DE := Trim(regExp.Match[1]);
//        spot.Freq := StrToFloat(spotFreqStr);
        spot.Freq := FormatFloat('0.00', round(StrToFloat(spotFreqStr)*10)/10);
        spot.DX := Trim(regExp.Match[3]);
        spot.Comment := Trim(regExp.Match[4]);

        hh := Copy(regExp.Match[5],1,2);
        mm := Copy(regExp.Match[5],3,2);
        spot.UTCTime := DateOf(SystemTimeToUTC(Now)) + EncodeTime(StrToInt(hh),StrToInt(mm),00,000);
        spot.LocalTime := LocalDateTimeFromUTCDateTime(spot.UTCTime);

        spotLabel := TSpotLabel.Create(Panel5, spot.DE, spot.LocalTime);
        spotLabel.Transparent := false;
        spotLabel.Color := frequencyPaintBox.Color+1;
        spotLabel.Parent := Panel5;
        spotLabel.Left := 0;
        spotLabel.Top := 0;
        spotLabel.Caption := spot.DX;
        spotLabel.Font.Color := settingsForm.colBoxRegularSpot.Selected;
        spotLabel.Font.Size := 9;
        spotLabel.Font.Style := [fsBold];
        spotLabel.Font.Pitch := fpVariable;
        spotLabel.Font.Quality := fqAntialiased;
        spotLabel.Hint := spotFreqStr + ' de '+spot.DE+' @'+DateTimeToStr(spot.LocalTime)+' '+spot.Comment;
        spotLabel.ShowHint := false;
        spotLabel.Visible := false;
        spotLabel.OnMouseUp := SpotLabelMouseUp;
        spotLabel.OnMouseEnter := SpotLabelMouseEnter;
        spotLabel.OnContextPopup := SpotLabelContextPopup;
        spotLabel.OnMouseMove := SpotLabelMouseMove;
        spotLabel.OnMouseLeave := SpotLabelMouseLeave;
        spotLabel.PopupMenu := spotLabelMenu;
        spotLabel.Tag := 0;
        spot.spotLabel := spotLabel;

        if (settingsForm.cbAALogIntegrationEnabled.Checked) then begin
          request := TSimpleCallsignRequest.Create(spot.DX, freqText, 'SSB', REQ_IS_IN_LOG);
          requestStr := FillJsonSimpleCallsignRequest(request);
          SendRequestToAALog(requestStr, settingsForm.txtAalAddr.Text, StrToInt(settingsForm.txtAalPort.Text), spotLabel);
        end else
          ColorizeSpotLabel(spotLabel);

        lbSpotTotal.Caption := IntToStr(getSpotTotalCount()) + ' / ' + IntToStr(spotBandCount);
        inc(spotCountMinuteRate);

        if CheckSpotListContainsKey(spot.Freq) then begin
          localSpotArray := GetSpotArrayFromList(spot.Freq);
          if localSpotArray <> nil then  //maybe this check is not needed?
            if not FindCallInArray(localSpotArray, spot.DX) then begin
              TAppender<TSpot>.Append(localSpotArray, spot);
              updateSpotListArray(spot.Freq, localSpotArray);
            end;
        end else begin
          spotList.Add(TPair<variant, TArray<TSpot>>.Create(spot.Freq, TArray<TSpot>.Create(spot)));
          DebugOutput('spot incoming (add):'+FloatToStr(spot.Freq) + ' - ' + spot.DX + ' time: '+DateTimeToStr(spot.LocalTime));
        end;
    end;

    //sh/dx spot processing
    regExp.Expression := regex2;
    if regExp.Exec(fromDXCstr) then begin
        oldSpotCount := getSpotTotalCount();
        spotFreqStr := StringReplace(regExp.Match[1], '.', ',', [rfIgnoreCase, rfReplaceAll]);
        if StrToFloat(spotFreqStr) > 150001 then exit;     //we don't process spot with freq more than 150 Mhz

        spot := TSpot.Create;
        spot.DE := Trim(regExp.Match[5]);
//        spot.Freq := StrToFloat(spotFreqStr);
        spot.Freq := FormatFloat('0.00', round(StrToFloat(spotFreqStr)*10)/10);
        spot.DX := Trim(regExp.Match[2]);
        spot.Comment := Trim(regExp.Match[4]);

        hh := Copy(regExp.Match[3],1,2);
        mm := Copy(regExp.Match[3],3,2);
        spot.UTCTime := DateOf(SystemTimeToUTC(Now)) + EncodeTime(StrToInt(hh),StrToInt(mm),00,000);
        spot.LocalTime := LocalDateTimeFromUTCDateTime(spot.UTCTime);

        spotLabel := TSpotLabel.Create(Panel5, spot.DE, spot.LocalTime);
        spotLabel.Transparent := false;
        spotLabel.Color := frequencyPaintBox.Color+1;
        spotLabel.Parent := Panel5;
        spotLabel.Left := 0;
        spotLabel.Top := 0;
        spotLabel.Caption := spot.DX;
        spotLabel.Font.Size := 9;
        spotLabel.Font.Color := settingsForm.colBoxRegularSpot.Selected;
        spotLabel.Font.Style := [fsBold];
        spotLabel.Font.Pitch := fpVariable;
        spotLabel.Font.Quality := fqClearTypeNatural;
        spotLabel.Hint := spotFreqStr + ' de '+spot.DE+' @'+DateTimeToStr(spot.LocalTime)+' '+spot.Comment;
        spotLabel.ShowHint := false;
        spotLabel.Visible := false;
        spotLabel.OnMouseUp := SpotLabelMouseUp;
        spotLabel.OnMouseEnter := SpotLabelMouseEnter;
        spotLabel.OnContextPopup := SpotLabelContextPopup;
        spotLabel.OnMouseMove := SpotLabelMouseMove;
        spotLabel.OnMouseLeave := SpotLabelMouseLeave;
        spotLabel.PopupMenu := spotLabelMenu;
        spotLabel.Tag := 0;
        spot.spotLabel := spotLabel;

        if (settingsForm.cbAALogIntegrationEnabled.Checked) then begin
          request := TSimpleCallsignRequest.Create(spot.DX, freqText, 'SSB', REQ_IS_IN_LOG);
          requestStr := FillJsonSimpleCallsignRequest(request);
          SendRequestToAALog(requestStr, settingsForm.txtAalAddr.Text, StrToInt(settingsForm.txtAalPort.Text), spotLabel);
        end else
          ColorizeSpotLabel(spotLabel);

        lbSpotTotal.Caption := IntToStr(getSpotTotalCount()) + ' / ' + IntToStr(spotBandCount);

        if CheckSpotListContainsKey(spot.Freq) then begin
          localSpotArray := GetSpotArrayFromList(spot.Freq);
          if localSpotArray <> nil then  //maybe this check is not needed?
            if not FindCallInArray(localSpotArray, spot.DX) then begin
              TAppender<TSpot>.Append(localSpotArray, spot);
              updateSpotListArray(spot.Freq, localSpotArray);
            end;
        end else begin
          //need to revert all list, because DXCluster shows spots in descending time manner
          //so, we simple insert every spot to begin of the list
          spotList.Insert(0, TPair<variant, TArray<TSpot>>.Create(spot.Freq, TArray<TSpot>.Create(spot)));
          DebugOutput('spot incoming (sh/dx):'+FloatToStr(spot.Freq) + ' - ' + spot.DX + ' time: '+DateTimeToStr(spot.LocalTime));
        end;
    end;

    if getSpotMaxCount < getSpotTotalCount then begin
      //delete first (most early by time) spot in list on same band//
      deleteFirstSpot();
    end;

  finally
    regExp.Free;
    HideLabels(false);
    RepaintFrequencySpan(true);
  end;
 end;

if Pos('login:',fromDXCstr) > 0 then begin
   IdTelnet1.SendString(trim(settingsForm.txtDXCUsername.Text)+CR);
end;

End;

procedure TFrequencyVisualForm.frequencyPaintBoxMouseLeave(Sender: TObject);
begin
  Xold := 0;
End;

procedure TFrequencyVisualForm.frequencyPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  horz : Integer;
begin
if (ssRight in Shift) and (not isPanelHoldActive.Checked) then begin
  if Xold > 0 then horz := X - Xold else horz := 0;
  Xold := X;
  sleep(10);
  if horz > 0 then begin
    //mouse move to right
    freqShifter := freqShifter - 1;
  end else begin
    //mouse move to left
    freqShifter := freqShifter  + 1;
  end;

  HideLabels(false);
  frequencyPositionArr[bandSwitcher.ItemIndex] := freqShifter;
  RepaintFrequencySpan(false);

  notNeedToShowPopupForFreqPanel := true;
  exit;
end;
  showLabelsDuringPaint := true;
  notNeedToShowPopupForFreqPanel := false;
End;

procedure TFrequencyVisualForm.frequencyPaintBoxMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  RepaintFrequencySpan(true);
end;

procedure AddSomeHzPositionToFreqSpan(paintBoxCanvas : TCanvas; var lineStartX, lineHeigthY : integer);
begin
  with paintBoxCanvas do begin
    MoveTo(lineStartX, 1);
    LineTo(lineStartX, lineHeigthY);

    freqStart := freqStart + freqAddKhz;

    lineStartX := lineStartX + lineSpacer div 10;
  end;
End;

procedure TFrequencyVisualForm.RepaintFrequencySpan(showLabels : boolean);
begin
showLabelsDuringPaint := showLabels;
frequencyPaintBox.Refresh;
frequencyPaintBoxTop.Refresh;
lbSpotTotal.Caption := IntToStr(getSpotTotalCount()) + ' / ' + IntToStr(spotBandCount);
End;

procedure TFrequencyVisualForm.frequencyPaintBoxPaint(Sender: TObject);
var
lineHeigth, lineStart, freqCAT : integer;

begin
spotBandCount := 0;
lineStart := 1;

case bandSwitcher.ItemIndex of
 0: freqStart := 1810.00 + freqShifter;
 1: freqStart := 3600.00 + freqShifter;
 2: freqStart := 7000.00 + freqShifter;
 3: freqStart := 10100.00 + freqShifter;
 4: freqStart := 14000.00 + freqShifter;
 5: freqStart := 18068.00 + freqShifter;
 6: freqStart := 21000.00 + freqShifter;
 7: freqStart := 24890.00 + freqShifter;
 8: freqStart := 28000.00 + freqShifter;
end;


with frequencyPaintBox.Canvas do begin
     FillRect(Rect(0, 0, frequencyPaintBox.Width, frequencyPaintBox.Height));
     Pen.Width := 1;
     Pen.Color := clWhite;
     Pen.Style := psSolid;
     Font.Color := clWhite;
     Font.Size := freqMarkerFontSize;

     while lineStart < boxWidth do begin

       if showLabelsDuringPaint then
         AddFrequencyPosition(lineStart, freqStart);

      freqCAT := freqStart * 1000;
      if freqCAT = settingsForm.currentOmniRigFreq then begin
          Pen.Color := clRed;
          Pen.Style := psDot;
          MoveTo(lineStart, StartYPosDPICorr);
          LineTo(lineStart, frequencyPaintBox.Height);
          Pen.Color := clWhite;
          Pen.Style := psSolid;
      end;

       freqStart := freqStart + freqAddKhz;
       lineStart := lineStart + lineSpacer div 10;
     end;

end;

End;

procedure TFrequencyVisualForm.frequencyPaintBoxTopPaint(Sender: TObject);
var
textShift, lineHeigth, lineStart, i : integer;
freqValueStr : String;

begin
lineStart := 1;
boxWidth := frequencyPaintBox.Width-40;

case bandSwitcher.ItemIndex of
 0: freqStart := 1810.00 + freqShifter;
 1: freqStart := 3600.00 + freqShifter;
 2: freqStart := 7000.00 + freqShifter;
 3: freqStart := 10100.00 + freqShifter;
 4: freqStart := 14000.00 + freqShifter;
 5: freqStart := 18068.00 + freqShifter;
 6: freqStart := 21000.00 + freqShifter;
 7: freqStart := 24890.00 + freqShifter;
 8: freqStart := 28000.00 + freqShifter;
end;

  with frequencyPaintBoxTop.Canvas do begin
    FillRect(Rect(0, 0, frequencyPaintBoxTop.Width, frequencyPaintBoxTop.Height));
    Pen.Width := 1;
    Pen.Color := settingsForm.colBoxScale.Selected;
    Pen.Style := psSolid;
    Font.Color := settingsForm.colBoxScale.Selected;
    Font.Size := freqMarkerFontSize;

    while lineStart < boxWidth do begin
      if textShift < 0 then textShift := 0;

      lineHeigth := shortLine;
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);

      lineHeigth := 2; //small dot
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);

      lineHeigth := shortLine div 2;
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);

      lineHeigth := 2; //small dot
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);

      lineHeigth := longLine;
      if bandSwitcher.ItemIndex > 2 then
        textShift := lineStart-textShiftValueHB
      else
        textShift := lineStart-textShiftValueLB;
      freqValueStr := FloatToStrF(freqStart, ffFixed, 5, 0);
      TextOut(textShift, lineHeigth+2, freqValueStr);

      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);

      lineHeigth := 2; //small dot
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);

      lineHeigth := shortLine div 2;
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);

      lineHeigth := 2; //small dot
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
      AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);

      for i := 1 to 3 do begin
        lineHeigth := shortLine;
        AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);

        lineHeigth := 2; //small dot
        AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
        AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
        AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
        AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);

        lineHeigth := shortLine div 2;
        AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);

        lineHeigth := 2; //small dot
        AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
        AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
        AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
        AddSomeHzPositionToFreqSpan(frequencyPaintBoxTop.Canvas, lineStart, lineHeigth);
      end;
    end;
  end;
end;

procedure TFrequencyVisualForm.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  AllowDrag;
End;

procedure TFrequencyVisualForm.Panel4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  AllowDrag;
End;

procedure TFrequencyVisualForm.Panel8MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  AllowDrag;
end;

procedure TFrequencyVisualForm.labPanelModeDblClick(Sender: TObject);
begin
isPanelHoldActive.Checked := not isPanelHoldActive.Checked;
isPanelHoldActiveClick(FrequencyVisualForm);
end;

procedure TFrequencyVisualForm.spacerScrollChange(Sender: TObject);
begin
frequencyPositionArr[bandSwitcher.ItemIndex] := freqShifter;
RefreshLineSpacer();

HideLabels(true);
RepaintFrequencySpan(true);
End;

procedure TFrequencyVisualForm.SpeedButton1Click(Sender: TObject);
begin
ChandeBandPosition(freqShifter+10);
end;

procedure TFrequencyVisualForm.SpeedButton2Click(Sender: TObject);
begin
ChandeBandPosition(0);
end;

procedure TFrequencyVisualForm.SpeedButton3Click(Sender: TObject);
begin
ChandeBandPosition((freqBandEnd - freqBandStart) div 2);
End;

procedure TFrequencyVisualForm.SpeedButton4Click(Sender: TObject);
begin
ChandeBandPosition(freqShifter-10);
End;

procedure TFrequencyVisualForm.spotCountResetTimerTimer(Sender: TObject);
begin
spotCount15MinutesRateList.Add(spotCountMinuteRate);
spotCountMinuteRate := 0;

if spotCount15MinutesRateList.Count > 15 then
  spotCount15MinutesRateList.Delete(0);
End;

END.

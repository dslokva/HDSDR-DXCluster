unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, JSons, uLkJSON, IdURI,
  Vcl.ButtonGroup, Vcl.WinXCtrls, IdBaseComponent, IdComponent, IdTCPConnection, UDPServerJSONObjects,
  IdTCPClient, IdTelnet, RegExpr, IdGlobal, System.Generics.Collections, IdUDPClient,
  Vcl.Buttons, inifiles, Vcl.Menus, IdUDPBase, IdUDPServer, IdSocketHandle, Winapi.ShellAPI, AALogClientJSONObjects;

type
  TSpotLabel = class(TLabel)
    public
      spotDE : string;
      isLotwEqsl : boolean;
      isInLog : boolean;
      constructor Create(AOwner: TComponent; spotDEStr : string);
  end;

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
    Panel2: TPanel;
    Button1: TButton;
    bandSwitcher: TRadioGroup;
    Panel5: TPanel;
    PaintBox1: TPaintBox;
    Panel3: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    spacerScroll: TScrollBar;
    IdTelnet1: TIdTelnet;
    btnDXCConnect: TButton;
    dxcStatusLabel: TLabel;
    lbScaleFactor: TLabel;
    chkStayOnTop: TCheckBox;
    cbHiRes: TCheckBox;
    Panel6: TPanel;
    lbSpotTotal: TLabel;
    Label2: TLabel;
    btnSpotClearAll: TButton;
    btnSpotClearBand: TButton;
    Button2: TButton;
    Button3: TButton;
    freqPanelMenu: TPopupMenu;
    isPanelHoldActive: TMenuItem;
    Panel7: TPanel;
    labPanelMode: TLabel;
    spotLabelMenu : TPopupMenu;
    Viewonqrzcom1: TMenuItem;
    Viewonqrzru1: TMenuItem;
    labelSpotHint: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure PaintBox1DblClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkStayOnTopClick(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spacerScrollChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure bandSwitcherClick(Sender: TObject);
    procedure Panel4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseLeave(Sender: TObject);
    procedure cbHiResClick(Sender: TObject);
    procedure btnDXCConnectClick(Sender: TObject);
    procedure IdTelnet1Connected(Sender: TObject);
    procedure IdTelnet1Disconnected(Sender: TObject);
    procedure IdTelnet1DataAvailable(Sender: TIdTelnet; const Buffer: TIdBytes);
    procedure Panel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label2DblClick(Sender: TObject);
    procedure btnSpotClearAllClick(Sender: TObject);
    procedure Label2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnSpotClearBandClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure isPanelHoldActiveClick(Sender: TObject);
    procedure PaintBox1ContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure labPanelModeDblClick(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Viewonqrzcom1Click(Sender: TObject);
    procedure Viewonqrzru1Click(Sender: TObject);
  private
    procedure SpotLabelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RepaintFrequencySpan();
    procedure RefreshLineSpacer();
    procedure AddFrequencyPosition(textXPos : integer; freqValue : variant);
    procedure AllowDrag;
    procedure SpotLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SpotLabelMouseEnter(Sender: TObject);
    procedure SpotLabelMouseLeave(Sender: TObject);
    procedure SpotLabelContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure setFreqStartAndMode();
    procedure refreshSelectedBandEdges();
    procedure RemoveSelectedSpot(dx : string);
    procedure DeleteFirstSpot();
    procedure UpdateCallsignDetailsTable(answerData : TlkJSONobject; spotLabel : TSpotLabel);
    procedure MyShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    { Private declarations }

  public
    stationCallsign : string;
    function getSpotList() : TList<TPair<variant, TArray<TSpot>>>;
    function getSpotTotalCount() : Integer;
    function getSpotMaxCount() : Integer;
    function CheckSpotListContainsKey(spotFreq : variant) : boolean;
    procedure updateSpotListArray(spotFreq : variant; spotArray : TArray<TSpot>);
    function GetSpotArrayFromList(spotFreq : variant) : TArray<TSpot>;
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
  freqShifter, freqStart, freqAddKhz : real;
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
  spotHintOldX, spotHintOldY : integer;

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


constructor TSpotLabel.Create(AOwner: TComponent; spotDEStr : string);
begin
  spotDE := spotDEStr;
  inherited Create(AOwner);
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

procedure HideAllLabels(labelVisible : boolean);
var
j, i : integer;
spotArray : TArray<TSpot>;

begin
for j := 0 to spotList.Count-1 do begin
  spotArray := spotList.Items[j].Value;
  for i := low(spotArray) to high(spotArray) do
     spotArray[i].spotLabel.Visible := not labelVisible;
end;
//todo: hide all only when band changed, change visibility only for one band
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
//todo: destroy all only when band changed, change visibility only for one band
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

procedure TFrequencyVisualForm.MyShowHint(var HintStr: string; var CanShow: Boolean;
  var HintInfo: THintInfo);
var
  i: integer;
begin
  for I := 0 to Application.ComponentCount-1 do begin
    if Application.Components[0] is THintWindow then begin
      with THintWindow(Application.Components[0]) do begin
        Canvas.Font.Name := 'Monotype Corsiva';
        Canvas.Font.Size := 10;
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
newHintStr : string;
spotAALogData : TSimpleCallsignAnswer;
begin

if (spotHintOldX <> X) or (spotHintOldY <> Y) then begin
  spotLabel := TSpotLabel(Sender);
  newHintStr := '';
  labelSpotHint.Caption := spotLabel.Hint;

  //todo: change aproach to set additional data in spotLabel to aalog answer processing thread
  if not spotLabel.Hint.Contains('From AALog') then
    if (callsingDataFromAALog.ContainsKey(spotLabel.Caption)) then begin
      spotAALogData := callsingDataFromAALog.Items[spotLabel.Caption];

      newHintStr := spotLabel.Hint + #13#13 + 'From AALog: ' + #13;

      if (spotAALogData.hamName <> '') then
        newHintStr := newHintStr + 'Name: ' + (spotAALogData.hamName) + #13;
      if (spotAALogData.hamQTH <> '') then
          newHintStr := newHintStr + 'QTH: ' + (spotAALogData.hamQTH) + #13;

       newHintStr := newHintStr + 'InLog: '+spotAALogData.presentInLog + ', LoTW: '+spotAALogData.isLoTWUser + ', EQSL.cc: '+spotAALogData.isEqslUser + ' ';

      spotLabel.Hint := newHintStr;
      labelSpotHint.Caption := newHintStr;
      labelSpotHint.Width := labelSpotHint.Width + 3;
    end;

  spotHintPoint := TPoint.Create(spotLabel.Left+X, spotLabel.Top+Y);
  spotHintOldX := X;
  spotHintOldY := Y;

  labelSpotHint.Top := spotLabel.Top + 50 + Y;
  labelSpotHint.Left := spotLabel.Left + 25 + X;

  labelSpotHint.Visible := true;
  // (ClientToScreen(spotHintPoint));
end;

End;

procedure TFrequencyVisualForm.SpotLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//Tag value is used for vertical alignment of spotLabels
if Button = mbLeft then begin
  if ssAlt in Shift then begin
    RemoveSelectedSpot(TLabel(Sender).Caption);
  end else TLabel(Sender).Tag := TLabel(Sender).Tag + 1;
end;

if Button = mbRight then begin
  if ssCtrl in Shift then begin
    notNeedToShowPopupForSpotLabel := false;
  end else begin
    notNeedToShowPopupForSpotLabel := true;
    notNeedToShowPopupForFreqPanel := true;
    if TLabel(Sender).Top >= longLine+UnderFreqDPICorr+EndYPosDPICorr then
      TLabel(Sender).Tag := TLabel(Sender).Tag - 1;
  end;
end;

HideAllLabels(true);
RepaintFrequencySpan();
End;

procedure TFrequencyVisualForm.SpotLabelMouseEnter(Sender: TObject);
begin
if (settingsForm.cbOwnSpotColorize.Checked) then
  TSpotLabel(Sender).Font.Color := settingsForm.colBoxSpotMouseMove.Selected;
End;

procedure TFrequencyVisualForm.SpotLabelMouseLeave(Sender: TObject);
var
spotLabel : TSpotLabel;

begin
spotLabel := TSpotLabel(Sender);
//own spot has more power that in log (because in some time anyone can spot he again and label will have gray color
if (spotLabel.isInLog) and (settingsForm.cbSpotInLog.Checked) then
  spotLabel.Font.Color := settingsForm.colBoxSpotInLog.Selected
else if (spotLabel.spotDE = stationCallsign) and (settingsForm.cbOwnSpotColorize.Checked) then
  spotLabel.Font.Color := settingsForm.colBoxOwnSpot.Selected

else spotLabel.Font.Color := clWhite;
labelSpotHint.Visible := false;
End;

procedure TFrequencyVisualForm.cbHiResClick(Sender: TObject);
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
  EndYPosDPICorr := 25;
  UnderFreqDPICorr := 28;
  PenWidthDPICorr := 2;
end else begin
  spaceAdjustValue := 75;
  longLine := 24;
  shortLine := 14;
  freqMarkerFontSize := 8;
  textShiftValueHB := 13;
  textShiftValueLB := 8;
  textXPosDPICorr := 2;
  StartYPosDPICorr := 2;
  EndYPosDPICorr := 13;
  UnderFreqDPICorr := 14;
  PenWidthDPICorr := 1;
end;

spacerScrollChange(FrequencyVisualForm);
End;

procedure TFrequencyVisualForm.chkStayOnTopClick(Sender: TObject);
begin
if chkStayOnTop.Checked then FrequencyVisualForm.FormStyle := fsStayOnTop
else FrequencyVisualForm.FormStyle := fsNormal;

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
lbScaleFactor.Caption := IntToStr(lineSpacer);
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
     WriteFloat('MainSettings', 'freqShift', freqShifter);
     WriteBool('MainSettings', 'HighResScreen', cbHiRes.Checked);
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
  PenWidthDPICorr := 2;
boxWidth := PaintBox1.ClientWidth-40;
RefreshLineSpacer();
freqAddKhz := 0.5;
freqStart := 3600.0;
Xold := 0;
spotBandCount := 0;
regex1 := 'DX de\s([a-zA-Z0-9\\\/]+)\:?\s+([0-9.,]+)\s+([a-zA-Z0-9\\\/]+)\s(.*)?\s([0-9]{4})Z.*';
regex2 := '([0-9.,]+)\s+([a-zA-Z0-9\\\/]+)\s.*([0-9]{4})Z\s(.*)\s<([a-zA-Z0-9\\\/]+)\>';
spotList := TList<TPair<variant, TArray<TSpot>>>.Create();
callsingDataFromAALog := TDictionary<String, TSimpleCallsignAnswer>.Create;

notNeedToShowPopupForFreqPanel := false;
notNeedToShowPopupForSpotLabel := false;

Application.OnShowHint := MyShowHint;
Application.HintColor := clCream;
labelSpotHint.Transparent := false;
labelSpotHint.Color := clCream;

PaintBox1.Color := ConvertHtmlHexToTColor('#151B47');

iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
try
  with iniFile, FrequencyVisualForm do begin
    spacerScroll.Position := ReadInteger('MainSettings', 'ScrollPosition', 1070);
    bandSwitcher.ItemIndex := ReadInteger('MainSettings', 'SelectedBand', 0);
    cbHiRes.Checked := ReadBool('MainSettings', 'HighResScreen', true);
    freqShifter := ReadFloat('MainSettings', 'freqShift', 0);
    Top := iniFile.ReadInteger('Placement','MainFormTop', 0) ;
    Left := iniFile.ReadInteger('Placement','MainFormLeft', 0);
    Width := iniFile.ReadInteger('Placement','MainFormWidth', 745);
    Height := iniFile.ReadInteger('Placement','MainFormHeight', 355);
  end;
finally
  iniFile.Free;
end;

setFreqStartAndMode();
End;

procedure TFrequencyVisualForm.FormResize(Sender: TObject);
begin
boxWidth := PaintBox1.ClientWidth-40;
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
    IdUDPClient.ReceiveTimeout := 3000; //может уменьшить?
    IdUDPClient.Connect;
    if IdUDPClient.Connected then begin
      IdUDPClient.Send(UDPRequestStr, IndyTextEncoding(encUTF8));
      answerStr := IdUDPClient.ReceiveString(IdTimeoutDefault, IndyTextEncoding(encOSDefault));
      DebugOutput(answerStr);
    end;
  except
    on E: Exception do
      answerStr := '0';
  end;

finally
  if Length(answerStr) = 0 then answerStr := '0';
  Synchronize(ProcessAnswerJSON);
  DebugOutput(DateTimeToStrUs(now) + ' - ' + answerStr);
  IdUDPClient.Active := False;
  IdUDPClient.Free;
end;
End;

procedure TRequestThread.ProcessAnswerJSON();
var
  JsonAnswer, jsData: TlkJSONobject;
  answerType : string;
begin
if answerStr = '0' then exit;

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
   //variant #1, second - simple dash line under label, that will be draw during label placement
  end;

  if presentInLog = '1' then begin
    spotLabel.isInLog := true;
    spotLabel.Font.Color := settingsForm.colBoxSpotInLog.Selected;
  end else
    if spotLabel.spotDE <> trim(settingsForm.txtStationCallsign.Text) then
      spotLabel.Font.Color := clWhite;

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
dxcStatusLabel.Caption := 'DXCluster connected';
dxcStatusLabel.Font.Color := clGreen;
btnDXCConnect.Caption := 'Disconnect DXCluster';
Beep;
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
end;

class procedure TAppender<T>.Append;
begin
  SetLength(Arr, Length(Arr)+1);
  Arr[High(Arr)] := Value;
end;

procedure TFrequencyVisualForm.IdTelnet1Disconnected(Sender: TObject);
begin
if FrequencyVisualForm.Visible then begin
  dxcStatusLabel.Caption := 'DXCluster disconnected';
  dxcStatusLabel.Font.Color := clRed;
  btnDXCConnect.Caption := 'Connect DXCluster';
end;

End;

procedure TFrequencyVisualForm.Label1MouseDown(Sender: TObject; Button: TMouseButton;
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
   freqStart := 1809.00;
   freqText := '160m';
 end;
 1: begin
    freqStart := 3599.00;
    freqText := '80m';
 end;
 2: begin
    freqStart := 7049.00;
    freqText := '40m';
 end;
 3: begin
    freqStart := 10099.00;
    freqText := '30m';
 end;
 4: begin
    freqStart := 14104.00;
    freqText := '20m';
 end;
 5: begin
    freqStart := 18109.00;
    freqText := '17m';
 end;
 6: begin
    freqStart := 21109.00;
    freqText := '15m';
 end;
 7: begin
    freqStart := 24890.00;
    freqText := '12m';
 end;
 8: begin
    freqStart := 28294.00;
    freqText := '10m';
 end;
end;

end;

procedure TFrequencyVisualForm.bandSwitcherClick(Sender: TObject);
begin
  //todo: make boundaries while tuning
setFreqStartAndMode();
spotBandCount := 0;
freqShifter := 0;

HideAllLabels(true);
RepaintFrequencySpan();

End;

procedure TFrequencyVisualForm.Button1Click(Sender: TObject);
begin
FrequencyVisualForm.Close;
End;

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

if (Length(dxcAddress) < 7) or (Length(dxcUsername) < 4)  or (dxcPort < 10) or (dxcPort < 10) then begin
  ShowMessage('Please check telnet DXCluster settings!');
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
    ShowMessage('Error: ' + E.Message);
    dxcStatusLabel.Caption := 'DXCluster disconnected';
    dxcStatusLabel.Font.Color := clRed;
  end;
end;

End;

procedure TFrequencyVisualForm.btnSpotClearAllClick(Sender: TObject);
begin
DestroyAllLabels();
spotList.Clear;
callsingDataFromAALog.Clear;
spotBandCount := 0;

RepaintFrequencySpan();
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

begin
refreshSelectedBandEdges();
//will remove all labels for selected band
for j := 0 to spotList.Count-1 do begin
  key := spotList.Items[j].Key;
  if (key >= freqBandStart) and (key <= freqBandEnd) then begin
    spotArray := spotList.Items[j].Value;
    for i := low(spotArray) to high(spotArray) do
      spotArray[i].spotLabel.Destroy;
    spotList.Delete(j);
  end;
end;

spotBandCount := 0;

HideAllLabels(true);
RepaintFrequencySpan();
End;

procedure TFrequencyVisualForm.RemoveSelectedSpot(dx : string);
var
j, i : integer;
key : variant;
spotArray : TArray<TSpot>;
removed : boolean;

begin
refreshSelectedBandEdges();
removed := false;
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
        removed := true;
        break;
      end;
  end;
  if removed then
    break;
    //LOL, but I think that this must be here.
    //Yes, I totally forgot about exit; :)
end;

spotBandCount := spotBandCount-1;
HideAllLabels(true);
RepaintFrequencySpan();
End;

procedure TFrequencyVisualForm.PaintBox1ContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
if notNeedToShowPopupForFreqPanel then
   Handled := True;
end;

procedure TFrequencyVisualForm.spotLabelContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
if notNeedToShowPopupForSpotLabel then
   Handled := True;
end;



procedure TFrequencyVisualForm.PaintBox1DblClick(Sender: TObject);
begin
Panel1.Visible := not Panel1.Visible;
End;

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


procedure TFrequencyVisualForm.AddFrequencyPosition(textXPos : integer; freqValue : variant);
var
spotArray : TArray<TSpot>;
spot : TSpot;
spotCount, YPos, spacingCorrection : integer;
spotLabel : TSpotLabel;
LogBrush: TLogBrush;

begin
if CheckSpotListContainsKey(freqValue) then begin
//this is a main procedure that draw spots on frequency pane
//still very fragile for DPI and Scale options (((
  spotArray := GetSpotArrayFromList(freqValue);
  if spotArray <> nil then
    with PaintBox1.Canvas do begin
      Font.Size := freqMarkerFontSize;
      Font.Color := clWhite;
      spotCount := 0;
      if cbHiRes.Checked then Pen.Width := 2
      else Pen.Width := 1;

       LogBrush.lbStyle := BS_SOLID;
       LogBrush.lbColor := clWhite;

      //don't touch digits formulas below! :)
      for spot in spotArray do begin
        spotLabel := spot.spotLabel;

        if spotLabel.Tag >= 1 then
          spacingCorrection := 7
        else
          spacingCorrection := 0;

        YPos := longLine+spacingCorrection+UnderFreqDPICorr+(EndYPosDPICorr*(spotCount+spotLabel.Tag));

        if bandSwitcher.ItemIndex < 4 then begin
        //LSB items
          MoveTo(textXPos, YPos+StartYPosDPICorr);
          LineTo(textXPos, YPos+EndYPosDPICorr);
          //Draw dotted line if spot is LoTW or EQSL.cc user
          if (spotLabel.isLotwEqsl) and (settingsForm.cbSpotLotwEqsl.Checked) then begin
            Pen.Handle := ExtCreatePen(PS_GEOMETRIC or PS_DASHDOT, 3, LogBrush, 0, nil);
            MoveTo(textXPos-spotLabel.Width-2, spotLabel.Top+EndYPosDPICorr+4);
            LineTo(textXPos, spotLabel.Top+EndYPosDPICorr+4);
            Pen.Handle := ExtCreatePen(PS_SOLID, 1, LogBrush, 0, nil);
          end;

          spotLabel.Left := textXPos-spotLabel.Width-textXPosDPICorr;
//          TextOut(textXPos-TextWidth(spot.DX)-6, YPos, spot.DX);
        end else begin
        //USB items
          MoveTo(textXPos, YPos+StartYPosDPICorr);
          LineTo(textXPos, YPos+EndYPosDPICorr);
          //Draw dotted line if spot is LoTW or EQSL.cc user
          if (spotLabel.isLotwEqsl) and (settingsForm.cbSpotLotwEqsl.Checked) then begin
            Pen.Handle := ExtCreatePen(PS_GEOMETRIC or PS_DASHDOT, 3, LogBrush, 0, nil);
            MoveTo(textXPos, spotLabel.Top+EndYPosDPICorr+4);
            LineTo(textXPos+spotLabel.Width+3, spotLabel.Top+EndYPosDPICorr+4);
            Pen.Handle := ExtCreatePen(PS_SOLID, 1, LogBrush, 0, nil);
          end;

          spotLabel.Left := textXPos+textXPosDPICorr;
//          TextOut(textXPos+6, YPos, spot.DX);
        end;

        spotLabel.Top := YPos;
        spotLabel.Visible := true;
        inc(spotCount);
      end;
      Pen.Width := 1;
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
i : integer;
spotArray : TArray<TSpot>;

begin
//most early spot - in begining of spotList
if (spotList.Count) = 0 then exit;

  spotArray := spotList.Items[0].Value;
  if Length(spotArray) = 1 then begin
    spotArray[0].spotLabel.Destroy;
    DebugOutput('deleting spot :'+FloatToStr(spotList.Items[0].Key) + ' - ' + spotArray[0].DX + ' time: '+DateTimeToStr(spotArray[0].LocalTime));
    spotList.Delete(0);
    exit;
  end else
    for i := low(spotArray) to high(spotArray) do begin
      spotArray[i].spotLabel.Destroy;
      DeleteElement(spotArray, i);
      spotList.Items[0] := TPair<variant, TArray<TSpot>>.Create(spotList.Items[0].Key, spotArray);
      exit;
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

procedure TFrequencyVisualForm.updateSpotListArray(spotFreq : variant; spotArray : TArray<TSpot>);
var
i : integer;
begin
for i := 0 to spotList.Count-1 do
  if spotList.Items[i].Key = spotFreq then begin
    spotList.Items[i] := TPair<variant, TArray<TSpot>>.Create(spotFreq, spotArray);
    break;
  end;
end;


procedure TFrequencyVisualForm.Viewonqrzcom1Click(Sender: TObject);
begin
ShellExecute(self.WindowHandle,'open',PChar('https://www.qrz.com/lookup/'+TSpotLabel(spotLabelMenu.PopupComponent).Caption),nil,nil, SW_SHOWNORMAL);

End;

procedure TFrequencyVisualForm.Viewonqrzru1Click(Sender: TObject);
begin
ShellExecute(self.WindowHandle,'open',PChar('https://www.qrz.ru/db/'+TSpotLabel(spotLabelMenu.PopupComponent).Caption),nil,nil, SW_SHOWNORMAL);

End;

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
//  Memo1.Lines.Strings[Memo1.Lines.Count - 1] := Memo1.Lines.Strings[Memo1.Lines.Count - 1] + Copy(incomeStr, Start, Stop - Start);
  fromDXCstr := Copy(incomeStr, Start, Stop - Start);
//  if incomeStr[Stop] = CR then
//    Memo1.Lines.Add('');

  Start := Stop + 1;
  if Start > Length(incomeStr) then Break;

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
        spotFreqStr := StringReplace(regExp.Match[2], '.', ',', [rfIgnoreCase, rfReplaceAll]);
        if StrToFloat(spotFreqStr) > 150000 then exit;

        spot := TSpot.Create;
        spot.DE := Trim(regExp.Match[1]);
        spot.Freq := StrToFloat(spotFreqStr);
        spot.DX := Trim(regExp.Match[3]);
        spot.Comment := Trim(regExp.Match[4]);

        hh := Copy(regExp.Match[5],1,2);
        mm := Copy(regExp.Match[5],3,2);
        spot.UTCTime := date+EncodeTime(StrToInt(hh),StrToInt(mm),00,000);
        spot.LocalTime := LocalDateTimeFromUTCDateTime(spot.UTCTime);

        spotLabel := TSpotLabel.Create(Panel5, spot.DE);
        spotLabel.Parent := Panel5;
        spotLabel.Left := 0;
        spotLabel.Top := 0;
        spotLabel.Caption := spot.DX;

        spotLabel.Font.Size := 9;
        if spot.DE = stationCallsign then
          spotLabel.Font.Color := clYellow
        else spotLabel.Font.Color := clWhite;

        spotLabel.Hint := spotFreqStr + ' de '+spot.DE+' @'+DateTimeToStr(spot.LocalTime)+' '+spot.Comment;
        spotLabel.ShowHint := false;
        spotLabel.Visible := false;
        spotLabel.OnMouseDown := SpotLabelMouseDown;
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
        end;

        lbSpotTotal.Caption := IntToStr(getSpotTotalCount()) + ' / ' + IntToStr(spotBandCount);

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
        if getSpotMaxCount < getSpotTotalCount then begin
           //delete first (most early by time) spot in list on same band//
           deleteFirstSpot();
        end;
    end;

    //sh/dx spot processing
    regExp.Expression := regex2;
    if regExp.Exec(fromDXCstr) then begin
        spotFreqStr := StringReplace(regExp.Match[1], '.', ',', [rfIgnoreCase, rfReplaceAll]);
        if StrToFloat(spotFreqStr) > 150000 then exit;

        spot := TSpot.Create;
        spot.DE := Trim(regExp.Match[5]);
        spot.Freq := StrToFloat(spotFreqStr);

        spot.DX := Trim(regExp.Match[2]);
        spot.Comment := Trim(regExp.Match[4]);

        hh := Copy(regExp.Match[3],1,2);
        mm := Copy(regExp.Match[3],3,2);
        spot.UTCTime := date+EncodeTime(StrToInt(hh),StrToInt(mm),00,000);
        spot.LocalTime := LocalDateTimeFromUTCDateTime(spot.UTCTime);

        spotLabel := TSpotLabel.Create(Panel5, spot.DE);
        spotLabel.Parent := Panel5;
        spotLabel.Left := 0;
        spotLabel.Top := 0;
        spotLabel.Caption := spot.DX;
        spotLabel.Font.Size := 9;

        if spot.DE = stationCallsign then
          spotLabel.Font.Color := clYellow
        else spotLabel.Font.Color := clWhite;

        spotLabel.Hint := spotFreqStr + ' de '+spot.DE+' @'+DateTimeToStr(spot.LocalTime)+' '+spot.Comment;
        spotLabel.ShowHint := false;
        spotLabel.Visible := false;
        spotLabel.OnMouseDown := SpotLabelMouseDown;
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
        end;
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

        if getSpotMaxCount < getSpotTotalCount then begin
           //delete first (most early by time) spot in list on same band//
           deleteFirstSpot();
        end;

    end;

  finally
    regExp.Free;
    HideAllLabels(true);
    RepaintFrequencySpan();
  end;
 end;

if Pos('login:',fromDXCstr) > 0 then begin
   IdTelnet1.SendString(trim(settingsForm.txtDXCUsername.Text)+CR);
end;

End;

procedure TFrequencyVisualForm.PaintBox1MouseLeave(Sender: TObject);
begin
  Xold := 0;
End;

procedure TFrequencyVisualForm.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
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
      freqShifter := freqShifter - 0.5;
    end else begin
      //mouse move to left
      freqShifter := freqShifter  + 0.5;
    end;

    HideAllLabels(true);
    RepaintFrequencySpan();

    notNeedToShowPopupForFreqPanel := true;
    exit;
  end;
  notNeedToShowPopupForFreqPanel := false;
End;

procedure TFrequencyVisualForm.RepaintFrequencySpan();
var
textShift, lineHeigth, lineStart, i : integer;
freqValueStr : String;

begin
lineStart := 1;
spotBandCount := 0;

case bandSwitcher.ItemIndex of
 0: freqStart := 1809.00 + freqShifter;
 1: freqStart := 3599.00 + freqShifter;
 2: freqStart := 7049.00 + freqShifter;
 3: freqStart := 10099.00 + freqShifter;
 4: freqStart := 14104.00 + freqShifter;
 5: freqStart := 18109.00 + freqShifter;
 6: freqStart := 21109.00 + freqShifter;
 7: freqStart := 24890.00 + freqShifter;
 8: freqStart := 28294.00 + freqShifter;
end;

with PaintBox1.Canvas do begin
     FillRect(Rect(0, 0, PaintBox1.Width, PaintBox1.Height));
     Pen.Width := 1;
     Pen.Color := clWhite;
     Pen.Style := psSolid;
     Font.Color := clWhite;
     Font.Size := freqMarkerFontSize;

     while lineStart < boxWidth do begin
       if textShift < 0 then textShift := 0;

       lineHeigth := shortLine;
       MoveTo(lineStart, 1);
       LineTo(lineStart, lineHeigth);
       AddFrequencyPosition(lineStart, freqStart);
       freqStart := freqStart + freqAddKhz;
       lineStart := lineStart + lineSpacer div 2;

       lineHeigth := shortLine div 2;
       MoveTo(lineStart, 1);
       LineTo(lineStart, lineHeigth);
       AddFrequencyPosition(lineStart, freqStart);
       freqStart := freqStart + freqAddKhz;
       lineStart := lineStart + lineSpacer div 2;

       lineHeigth := longLine;

       if bandSwitcher.ItemIndex > 2 then textShift := lineStart-textShiftValueHB
       else textShift := lineStart-textShiftValueLB;
       freqValueStr := FloatToStrF(freqStart, ffFixed, 5, 0);
       TextOut(textShift, lineHeigth+2, freqValueStr);

       MoveTo(lineStart, 1);
       LineTo(lineStart, lineHeigth);
       AddFrequencyPosition(lineStart, freqStart);
       freqStart := freqStart + freqAddKhz;
       lineStart := lineStart + lineSpacer div 2;

       lineHeigth := shortLine div 2;
       MoveTo(lineStart, 1);
       LineTo(lineStart, lineHeigth);
       AddFrequencyPosition(lineStart, freqStart);
       freqStart := freqStart + freqAddKhz;
       lineStart := lineStart + lineSpacer div 2;

       //
       for i := 1 to 3 do begin
         lineHeigth := shortLine;
         MoveTo(lineStart, 1);
         LineTo(lineStart, lineHeigth);
         AddFrequencyPosition(lineStart, freqStart);
         freqStart := freqStart + freqAddKhz;
         lineStart := lineStart + lineSpacer div 2;

         lineHeigth := shortLine div 2;
         MoveTo(lineStart, 1);
         LineTo(lineStart, lineHeigth);
         AddFrequencyPosition(lineStart, freqStart);
         freqStart := freqStart + freqAddKhz;
         lineStart := lineStart + lineSpacer div 2;
       end;
     end;
end;

lbSpotTotal.Caption := IntToStr(getSpotTotalCount()) + ' / ' + IntToStr(spotBandCount);
End;

procedure TFrequencyVisualForm.PaintBox1Paint(Sender: TObject);
begin
RepaintFrequencySpan();
End;

procedure TFrequencyVisualForm.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  AllowDrag;
End;

procedure TFrequencyVisualForm.Panel2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  AllowDrag;
End;

procedure TFrequencyVisualForm.Panel4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  AllowDrag;
End;

procedure TFrequencyVisualForm.Label2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
AllowDrag;
End;

procedure TFrequencyVisualForm.labPanelModeDblClick(Sender: TObject);
begin
isPanelHoldActive.Checked := not isPanelHoldActive.Checked;
isPanelHoldActiveClick(FrequencyVisualForm);
end;

procedure TFrequencyVisualForm.spacerScrollChange(Sender: TObject);
begin
RefreshLineSpacer();

HideAllLabels(true);
RepaintFrequencySpan();

End;

END.

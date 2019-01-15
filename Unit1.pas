unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ButtonGroup, Vcl.WinXCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdTelnet, RegExpr, IdGlobal, System.Generics.Collections,
  Vcl.Buttons, inifiles;

type
  TSpot = class
    DX: String;
    DE: String;
    Comment: String;
    Freq: variant;
    UTCTime: TDateTime;
    LocalTime: TDateTime;
    spotLabel : TLabel;
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
  private
    procedure CreateParams(var Params: TCreateParams); override;
    procedure RepaintFrequencySpan();
    procedure RefreshLineSpacer();
    procedure AddFrequencyPosition(textXPos : integer; freqValue : variant);
    procedure AllowDrag;
    procedure SpotLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SpotLabelMouseEnter(Sender: TObject);
    procedure SpotLabelMouseLeve(Sender: TObject);
    procedure refreshSelectedBandEdges();
    procedure RemoveOneSpot(dx : string);
    { Private declarations }

  public
    function getSpotList() : TDictionary<variant, TArray<TSpot>>;
    function getSpotTotalCount() : Integer;
    { Public declarations }
  end;

var
  FrequencyVisualForm : TFrequencyVisualForm;
  spaceAdjustValue, lineSpacer, boxWidth : integer;
  freqShifter, freqStart, freqAddKhz : real;
  freqBandStart, freqBandEnd : variant;
  Xold : Integer;
  regExp : TRegExpr;
  spotList : TDictionary<variant, TArray<TSpot>>;
  spotBandCount : integer;
  regex1, regex2 : string;
  longLine, shortLine, freqMarkerFontSize, textShiftValueLB, textShiftValueHB : integer;
  textXPosDPICorr, StartYPosDPICorr, EndYPosDPICorr, UnderFreqDPICorr, PenWidthDPICorr : integer;

implementation

{$R *.dfm}

uses Unit2, Unit3;


function TFrequencyVisualForm.getSpotTotalCount() : Integer;
begin
result := spotList.Count;
end;

function TFrequencyVisualForm.getSpotList() : TDictionary<variant, TArray<TSpot>>;
begin
result := spotList;
end;

procedure HideAllLabels(labelVisible : boolean);
var
i : integer;
spotArray : TArray<TSpot>;

begin
for spotArray in spotList.Values do begin
  for i := low(spotArray) to high(spotArray) do
     spotArray[i].spotLabel.Visible := not labelVisible;
end;

End;

procedure DestroyAllLabels();
var
i : integer;
spotArray : TArray<TSpot>;

begin
for spotArray in spotList.Values do begin
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

procedure TFrequencyVisualForm.SpotLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//Tag value is used for vertical alignment of spotLabels
if Button = mbLeft then begin
  if ssAlt in Shift then begin
    RemoveOneSpot(TLabel(Sender).Caption);
  end else TLabel(Sender).Tag := TLabel(Sender).Tag + 1;
end;

if Button = mbRight then
  if TLabel(Sender).Top >= longLine+UnderFreqDPICorr+EndYPosDPICorr then
    TLabel(Sender).Tag := TLabel(Sender).Tag - 1;

HideAllLabels(true);
RepaintFrequencySpan();
End;

procedure TFrequencyVisualForm.SpotLabelMouseEnter(Sender: TObject);
begin
TLabel(Sender).Font.Color := clLime;
End;

procedure TFrequencyVisualForm.SpotLabelMouseLeve(Sender: TObject);
begin
TLabel(Sender).Font.Color := clWhite;
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
end;

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
spotList := TDictionary<variant, TArray<TSpot>>.Create();

iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
try
  with iniFile, FrequencyVisualForm do begin
    spacerScroll.Position := ReadInteger('MainSettings', 'ScrollPosition', 1070);
    bandSwitcher.ItemIndex := ReadInteger('MainSettings', 'SelectedBand', 0);
    cbHiRes.Checked := ReadBool('MainSettings', 'HighResScreen', true);
    Top := iniFile.ReadInteger('Placement','MainFormTop', 0) ;
    Left := iniFile.ReadInteger('Placement','MainFormLeft', 0);
    Width := iniFile.ReadInteger('Placement','MainFormWidth', 745);
    Height := iniFile.ReadInteger('Placement','MainFormHeight', 355);
  end;
finally
  iniFile.Free;
end;
End;

procedure TFrequencyVisualForm.FormResize(Sender: TObject);
begin
boxWidth := PaintBox1.ClientWidth-40;
End;

procedure TFrequencyVisualForm.IdTelnet1Connected(Sender: TObject);
begin
dxcStatusLabel.Caption := 'DXCluster connected';
dxcStatusLabel.Font.Color := clGreen;
btnDXCConnect.Caption := 'Disconnect DXCluster';
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

procedure TFrequencyVisualForm.bandSwitcherClick(Sender: TObject);
begin
  //todo: make boundaries while tuning
case bandSwitcher.ItemIndex of
 0: freqStart := 1809.00;
 1: freqStart := 3599.00;
 2: freqStart := 7049.00;
 3: freqStart := 10099.00;
 4: freqStart := 14104.00;
 5: freqStart := 18109.00;
 6: freqStart := 21109.00;
 7: freqStart := 24890.00;
 8: freqStart := 28294.00;
end;
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
result : boolean;
dxcAddress : string;
dxcPort : integer;

begin
try
dxcAddress := trim(settingsForm.txtDXCHost.Text);
dxcPort :=  StrToInt(trim(settingsForm.txtDXCPort.Text));
if (Length(dxcAddress) < 7)  or (dxcPort < 10) or (dxcPort < 10) then begin
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

procedure TFrequencyVisualForm.btnSpotClearBandClick(Sender: TObject);
var
i : integer;
key : variant;
spotArray : TArray<TSpot>;

begin
refreshSelectedBandEdges();
//will remove all labels for selected band
for key in spotList.Keys do begin
  if (key >= freqBandStart) and (key <= freqBandEnd) then begin
    spotArray := spotList.Items[key];
    for i := low(spotArray) to high(spotArray) do
      spotArray[i].spotLabel.Destroy;
    spotList.Remove(key);
  end;
end;

spotBandCount := 0;

HideAllLabels(true);
RepaintFrequencySpan();
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
end;

procedure DeleteArrayIndex(var X: TArray<TSpot>; Index: Integer);
begin
  if Index > High(X) then Exit;
  if Index < Low(X) then Exit;
  if Index = High(X) then
  begin
    SetLength(X, Length(X) - 1);
    Exit;
  end;
  Finalize(X[Index]);
  System.Move(X[Index +1], X[Index],
  (Length(X) - Index -1) * SizeOf(TSpot) + 1);
  SetLength(X, Length(X) - 1);
end;

procedure TFrequencyVisualForm.RemoveOneSpot(dx : string);
var
i : integer;
key : variant;
spotArray : TArray<TSpot>;
removed : boolean;

begin
refreshSelectedBandEdges();
removed := false;
//will remove only one spot on band with caption = dx
for key in spotList.Keys do begin
  if (key >= freqBandStart) and (key <= freqBandEnd) then begin
    spotArray := spotList.Items[key];
    for i := low(spotArray) to high(spotArray) do
      if spotArray[i].spotLabel.Caption = dx then begin
        spotArray[i].spotLabel.Destroy;
        if Length(spotArray) > 1 then begin
          DeleteElement(spotArray, i);
          spotList.Items[key] := spotArray;
        end else
          spotList.Remove(key);
        removed := true;
        break;
      end;
  end;
  if removed then
    break;
end;

spotBandCount := spotBandCount-1;

HideAllLabels(true);
RepaintFrequencySpan();
End;

procedure TFrequencyVisualForm.PaintBox1DblClick(Sender: TObject);
begin
Panel1.Visible := not Panel1.Visible;
End;

procedure TFrequencyVisualForm.AddFrequencyPosition(textXPos : integer; freqValue : variant);
var
spotArray : TArray<TSpot>;
spot : TSpot;
spotCount, YPos : integer;
spotLabel : TLabel;

begin
if spotList.ContainsKey(freqValue) then begin
//todo: replace simple canvas callsigns text with TLabel objects
  if spotList.TryGetValue(freqValue, spotArray) then
    with PaintBox1.Canvas do begin
      Font.Size := freqMarkerFontSize;
      Font.Color := clWhite;
      spotCount := 0;
      if cbHiRes.Checked then Pen.Width := 2
      else Pen.Width := 1;

      //don't touch digits formulas below! :)
      for spot in spotArray do begin
        spotLabel := spot.spotLabel;
        YPos := longLine+UnderFreqDPICorr+(EndYPosDPICorr*(spotCount+spotLabel.Tag));

        if bandSwitcher.ItemIndex < 4 then begin
        //LSB items
          MoveTo(textXPos, YPos+StartYPosDPICorr);
          LineTo(textXPos, YPos+EndYPosDPICorr);
          spotLabel.Top := YPos;
          spotLabel.Left := textXPos-spotLabel.Width-textXPosDPICorr;
          spotLabel.Visible := true;
//          TextOut(textXPos-TextWidth(spot.DX)-6, YPos, spot.DX);
        end else begin
        //USB items
          MoveTo(textXPos, YPos+StartYPosDPICorr);
          LineTo(textXPos, YPos+EndYPosDPICorr);
          spotLabel.Top := YPos;
          spotLabel.Left := textXPos+textXPosDPICorr;
          spotLabel.Visible := true;
//          TextOut(textXPos+6, YPos, spot.DX);
        end;

        inc(spotCount);
      end;
      Pen.Width := 1;
      spotBandCount := spotBandCount + spotCount;
    end;
end;
//Memo1.Lines.Add(IntToStr(textXPos)+ '='+FloatToStrF(freqStart, ffFixed, 5, 2))

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

procedure TFrequencyVisualForm.IdTelnet1DataAvailable(Sender: TIdTelnet;
  const Buffer: TIdBytes);
var
Start, Stop, i, spotPosition: Integer;
spotFreqStr, incomeStr, hh, mm : string;
spot : TSpot;
localSpotArray : TArray<TSpot>;
fromDXCstr : string;
spotLabel : TLabel;

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
    spot := TSpot.Create;

    //regular spot processing
    regExp.Expression := regex1;
    if regExp.Exec(fromDXCstr) then begin
        spot.DE := Trim(regExp.Match[1]);

        spotFreqStr := StringReplace(regExp.Match[2], '.', ',', [rfIgnoreCase, rfReplaceAll]);
        spot.Freq := StrToFloat(spotFreqStr);

        spot.DX := Trim(regExp.Match[3]);
        spot.Comment := Trim(regExp.Match[4]);

        hh := Copy(regExp.Match[5],1,2);
        mm := Copy(regExp.Match[5],3,2);
        spot.UTCTime := date+EncodeTime(StrToInt(hh),StrToInt(mm),00,000);
        spot.LocalTime := LocalDateTimeFromUTCDateTime(spot.UTCTime);

        spotLabel := TLabel.Create(Panel5);
        spotLabel.Parent := Panel5;
        spotLabel.Left := 0;
        spotLabel.Top := 0;
        spotLabel.Caption := spot.DX;
        spotLabel.Font.Size := 9;
        spotLabel.Font.Color := clWhite;
        spotLabel.Hint := spotFreqStr + ' de '+spot.DE+' @'+DateTimeToStr(spot.LocalTime)+' '+spot.Comment;
        spotLabel.ShowHint := true;
        spotLabel.Visible := false;
        spotLabel.OnMouseDown := SpotLabelMouseDown;
        spotLabel.OnMouseEnter := SpotLabelMouseEnter;
        spotLabel.OnMouseLeave := SpotLabelMouseLeve;
        spotLabel.Tag := 0;
        spot.spotLabel := spotLabel;

        lbSpotTotal.Caption := IntToStr(getSpotTotalCount()) + ' / ' + IntToStr(spotBandCount);

        if spotList.ContainsKey(spot.Freq) then begin
          if spotList.TryGetValue(spot.Freq, localSpotArray) then
            if not FindCallInArray(localSpotArray, spot.DX) then begin
              TAppender<TSpot>.Append(localSpotArray, spot);
              spotList.Remove(spot.Freq);
              spotList.Add(spot.Freq, localSpotArray);
            end;
        end else begin
          spotList.Add(spot.Freq, TArray<TSpot>.Create(spot));
        end;
    end;

    //sh/dx spot processing
    regExp.Expression := regex2;
    if regExp.Exec(fromDXCstr) then begin
        spot.DE := Trim(regExp.Match[5]);

        spotFreqStr := StringReplace(regExp.Match[1], '.', ',', [rfIgnoreCase, rfReplaceAll]);
        spot.Freq := StrToFloat(spotFreqStr);

        spot.DX := Trim(regExp.Match[2]);
        spot.Comment := Trim(regExp.Match[4]);

        hh := Copy(regExp.Match[3],1,2);
        mm := Copy(regExp.Match[3],3,2);
        spot.UTCTime := date+EncodeTime(StrToInt(hh),StrToInt(mm),00,000);
        spot.LocalTime := LocalDateTimeFromUTCDateTime(spot.UTCTime);

        spotLabel := TLabel.Create(Panel5);
        spotLabel.Parent := Panel5;
        spotLabel.Left := 0;
        spotLabel.Top := 0;
        spotLabel.Caption := spot.DX;
        spotLabel.Font.Size := 9;
        spotLabel.Font.Color := clWhite;
        spotLabel.Hint := spotFreqStr + ' de '+spot.DE+' @'+DateTimeToStr(spot.LocalTime)+' '+spot.Comment;
        spotLabel.ShowHint := true;
        spotLabel.Visible := false;
        spotLabel.OnMouseDown := SpotLabelMouseDown;
        spotLabel.OnMouseEnter := SpotLabelMouseEnter;
        spotLabel.OnMouseLeave := SpotLabelMouseLeve;
        spotLabel.Tag := 0;
        spot.spotLabel := spotLabel;

        lbSpotTotal.Caption := IntToStr(getSpotTotalCount()) + ' / ' + IntToStr(spotBandCount);

        if spotList.ContainsKey(spot.Freq) then begin
          if spotList.TryGetValue(spot.Freq, localSpotArray) then
            if not FindCallInArray(localSpotArray, spot.DX) then begin
              TAppender<TSpot>.Append(localSpotArray, spot);
              spotList.Remove(spot.Freq);
              spotList.Add(spot.Freq, localSpotArray);
            end;
        end else begin
          spotList.Add(spot.Freq, TArray<TSpot>.Create(spot));
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
if ssRight in Shift then begin
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
  end;
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

//Memo1.Lines.Clear();
PaintBox1.Color := ConvertHtmlHexToTColor('#151B47');

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

procedure TFrequencyVisualForm.spacerScrollChange(Sender: TObject);
begin
RefreshLineSpacer();

HideAllLabels(true);
RepaintFrequencySpan();

End;

END.

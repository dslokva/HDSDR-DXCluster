unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, IdGlobal,
  System.Generics.Collections, inifiles;

type
  TdxcViewForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Panel3: TPanel;
    dxcMainTable: TStringGrid;
    Panel4: TPanel;
    Button3: TButton;
    Button2: TButton;
    Panel5: TPanel;
    btnRefresh: TButton;
    rgSortOpts: TRadioGroup;
    GroupBox1: TGroupBox;
    cb12m: TCheckBox;
    cb15m: TCheckBox;
    cb17m: TCheckBox;
    cb20m: TCheckBox;
    cb30m: TCheckBox;
    cb40m: TCheckBox;
    cb80m: TCheckBox;
    cb160m: TCheckBox;
    cb10m: TCheckBox;
    cb6m: TCheckBox;
    cb2m: TCheckBox;
    Panel6: TPanel;
    Label1: TLabel;
    lbSpotCount: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure ClearDXCMainTable;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dxcViewForm: TdxcViewForm;

implementation

{$R *.dfm}

uses Unit1;

type
  TMoveSG = class(TCustomGrid);
  TSortInfo = Record
    col: Integer;
    asc: Boolean;
    constructor Create(ACol : Integer; Aasc: Boolean);
end;

constructor TSortInfo.Create(ACol : Integer; Aasc: Boolean);
begin
  col := ACol;
  asc := Aasc;
end;

function CompareNumber(i1, i2: Double): Integer;
// Result: -1 if i1 < i2, 1 if i1 > i2, 0 if i1 = i2
begin
  if i1 < i2 then
    Result := -1
  else if i1 > i2 then
    Result := 1
  else
    Result := 0;
end;

// Compare Strings if possible try to interpret as numbers
function CompareValues(const S1, S2 : String;asc:Boolean): Integer;
var
  V1, V2 : Double;
  C1, C2 : Integer;
begin
  Val(S1, V1, C1);
  Val(S2, V2, C2);
  if (C1 = 0) and (C2 = 0) then  // both as numbers
     Result := CompareNumber(V1, V2)
  else  // not both as nubers
     Result := AnsiCompareStr(S1, S2);
  if not Asc then Result := Result * -1;

end;

procedure SortGridByCols(Grid: TStringGrid; ColOrder: array of TSortInfo; Fixed: Boolean);
var
  I, J, FirstRow: Integer;
  Sorted: Boolean;

  function Sort(Row1, Row2: Integer): Integer;
  var
    C: Integer;
  begin
    C := 0;
    Result := CompareValues(Grid.Cols[ColOrder[C].col][Row1], Grid.Cols[ColOrder[C].col][Row2],ColOrder[C].asc);
    if Result = 0 then
    begin
      Inc(C);
      while (C <= High(ColOrder)) and (Result = 0) do
      begin
        Result := CompareValues(Grid.Cols[ColOrder[C].col][Row1], Grid.Cols[ColOrder[C].col][Row2],ColOrder[C].asc);
        Inc(C);
      end;
    end;
  end;

begin
  for I := 0 to High(ColOrder) do
    if (ColOrder[I].col < 0) or (ColOrder[I].col >= Grid.ColCount) then
      Exit;

//  if Fixed then
//    FirstRow := 0
//  else
    FirstRow := Grid.FixedRows;

  J := FirstRow;
  Sorted := True;
  repeat
    Inc(J);
    for I := FirstRow to Grid.RowCount - 2 do
      if Sort(I, I + 1) > 0 then
      begin
        TMoveSG(Grid).MoveRow(i + 1, i);
        Sorted := False;
      end;
  until Sorted or (J >= Grid.RowCount + 1000);
  Grid.Repaint;
end;

procedure TdxcViewForm.ClearDXCMainTable;
var
i:integer;
begin
with dxcMainTable do
  for i := 1 to RowCount-1 do
    Rows[i].Clear;
dxcMainTable.RowCount := 2;
dxcMainTable.FixedRows := 1;
End;

procedure TdxcViewForm.btnRefreshClick(Sender: TObject);
var
spotList : TDictionary<variant, TArray<TSpot>>;
i, row : integer;
spotArray : TArray<TSpot>;
sortArray: array[0..0] of TSortInfo;
freqBandStart, freqBandEnd, spotFreq : variant;

begin
ClearDXCMainTable;
spotList := FrequencyVisualForm.getSpotList();
row := 1;

for spotArray in spotList.Values do begin
  for i := low(spotArray) to high(spotArray) do begin
    spotFreq := spotArray[i].Freq;
    if ((spotFreq >= 1810.00) and (spotFreq <= 2000.00) and not cb160m.Checked) then break else
    if ((spotFreq >= 3500.00) and (spotFreq <= 3800.00) and not cb80m.Checked) then break else
    if ((spotFreq >= 7000.00) and (spotFreq <= 7300.00) and not cb40m.Checked) then break else
    if ((spotFreq >= 10100.00) and (spotFreq <= 10500.00) and not cb30m.Checked) then break else
    if ((spotFreq >= 14000.00) and (spotFreq <= 14350.00) and not cb20m.Checked) then break else
    if ((spotFreq >= 18068.00) and (spotFreq <= 18168.00) and not cb17m.Checked) then break else
    if ((spotFreq >= 21000.00) and (spotFreq <= 21450.00) and not cb15m.Checked) then break else
    if ((spotFreq >= 24890.00) and (spotFreq <= 24990.00) and not cb12m.Checked) then break else
    if ((spotFreq >= 28000.00) and (spotFreq <= 29700.00) and not cb10m.Checked) then break else
    if ((spotFreq >= 50000.00) and (spotFreq <= 54000.00) and not cb6m.Checked) then break else
    if ((spotFreq >= 140000.00) and (spotFreq <= 148000.00) and not cb2m.Checked) then break else begin

      dxcMainTable.Cells[0,row] := spotArray[i].DE;
      dxcMainTable.Cells[1,row] := StringReplace(FloatToStrF(spotArray[i].Freq, ffFixed, 6, 2), ',', '.', [rfIgnoreCase, rfReplaceAll]);
      dxcMainTable.Cells[2,row] := spotArray[i].DX;
      dxcMainTable.Cells[3,row] := spotArray[i].Comment;
      dxcMainTable.Cells[4,row] := DateTimeToStr(spotArray[i].LocalTime);
      inc(row);
    end;
  end;
end;
dxcMainTable.RowCount := row;

case rgSortOpts.ItemIndex of
  0: sortArray[0] := TSortInfo.Create(1, true);
  1: sortArray[0] := TSortInfo.Create(4, false);
end;

SortGridByCols(dxcMainTable, sortArray, false);
lbSpotCount.Caption := IntToStr(FrequencyVisualForm.getSpotTotalCount()) + ' / ' + IntToStr(row-1);
End;

procedure TdxcViewForm.Button1Click(Sender: TObject);
begin
dxcViewForm.Close;

End;

procedure TdxcViewForm.Button2Click(Sender: TObject);
begin
if FrequencyVisualForm.IdTelnet1.Connected then
  FrequencyVisualForm.IdTelnet1.SendString('SH/DX 100'+CR)
End;

procedure TdxcViewForm.Button3Click(Sender: TObject);
begin
if FrequencyVisualForm.IdTelnet1.Connected then
  FrequencyVisualForm.IdTelnet1.SendString('SH/DX 50'+CR)
End;

procedure TdxcViewForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
iniFile : TIniFile;
begin
iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
try
  with iniFile, dxcViewForm do begin
     WriteInteger('Placement', 'dxcViewFormTop', Top);
     WriteInteger('Placement', 'dxcViewFormLeft', Left);
     WriteInteger('Placement', 'dxcViewFormWidth', Width);
     WriteInteger('Placement', 'dxcViewFormHeight', Height);
     WriteInteger('ClusterFilter', 'sortBy', rgSortOpts.ItemIndex);
     WriteBool('ClusterFilter', 'b160', cb160m.Checked);
     WriteBool('ClusterFilter', 'b80', cb80m.Checked);
     WriteBool('ClusterFilter', 'b40', cb40m.Checked);
     WriteBool('ClusterFilter', 'b30', cb30m.Checked);
     WriteBool('ClusterFilter', 'b20', cb20m.Checked);
     WriteBool('ClusterFilter', 'b17', cb17m.Checked);
     WriteBool('ClusterFilter', 'b15', cb15m.Checked);
     WriteBool('ClusterFilter', 'b12', cb12m.Checked);
     WriteBool('ClusterFilter', 'b10', cb10m.Checked);
  end;
finally
  iniFile.Free;
end;
end;

procedure TdxcViewForm.FormCreate(Sender: TObject);
var
iniFile : TIniFile;
begin
iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
try
  with iniFile, dxcViewForm do begin
    Top := iniFile.ReadInteger('Placement','dxcViewFormTop', 0) ;
    Left := iniFile.ReadInteger('Placement','dxcViewFormLeft', 0);
    Width := iniFile.ReadInteger('Placement','dxcViewFormWidth', 730);
    Height := iniFile.ReadInteger('Placement','dxcViewFormHeight', 400);
    rgSortOpts.ItemIndex := iniFile.ReadInteger('ClusterFilter','sortBy', 0);
    cb160m.Checked := iniFile.ReadBool('ClusterFilter', 'b160', false);
    cb80m.Checked := iniFile.ReadBool('ClusterFilter', 'b80', false);
    cb80m.Checked := iniFile.ReadBool('ClusterFilter', 'b80', true);
    cb40m.Checked := iniFile.ReadBool('ClusterFilter', 'b40', true);
    cb30m.Checked := iniFile.ReadBool('ClusterFilter', 'b30', false);
    cb20m.Checked := iniFile.ReadBool('ClusterFilter', 'b20', true);
    cb17m.Checked := iniFile.ReadBool('ClusterFilter', 'b17', false);
    cb15m.Checked := iniFile.ReadBool('ClusterFilter', 'b15', true);
    cb12m.Checked := iniFile.ReadBool('ClusterFilter', 'b12', false);
    cb10m.Checked := iniFile.ReadBool('ClusterFilter', 'b10', false);
  end;
finally
  iniFile.Free;
end;

dxcMainTable.Cells[0,0] := 'DX de (spotter)';
dxcMainTable.Cells[1,0] := 'Freq';
dxcMainTable.Cells[2,0] := 'DX';
dxcMainTable.Cells[3,0] := 'Comments';
dxcMainTable.Cells[4,0] := 'Local time';
End;

END.

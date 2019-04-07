//------------------------------------------------------------------------------
//The contents of this file are subject to the Mozilla Public License
//Version 1.1 (the "License"); you may not use this file except in compliance
//with the License. You may obtain a copy of the License at
//http://www.mozilla.org/MPL/ Software distributed under the License is
//distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
//or implied. See the License for the specific language governing rights and
//limitations under the License.
//
//The Original Code is CallParser.pas.
//
//The Initial Developer of the Original Code is Alex Shovkoplyas, VE3NEA.
//Portions created by Alex Shovkoplyas are
//Copyright (C) 2005 Alex Shovkoplyas. All Rights Reserved.
//------------------------------------------------------------------------------


unit CallParser;

interface

uses
  Windows, Messages, SysUtils, Classes, PrefLst;

type
  PHitEntry = ^THitEntry;
  THitEntry = TPrefixEntry;
  THitArray = array of THitEntry;

  //mask comparison result
  TPrefixMatch = (pfNE, pfLT, pfGE);
  TEndingMatch = (edNE, edP, edM, edEQ);


  TCallParser = class(TComponent)
  private
    FPrefixFile: TFileName;
    FCallFile: TFileName;
    FPrefLst: TPrefixList;
    FCallList: TStringList;
    FCall: string;
    FHitTree: THitArray;

    procedure SetPrefixFile(const Value: TFileName);
    procedure SetCallFile(const Value: TFileName);
    procedure SetCall(const Value: string);
    function FormatCall(var ACallStr: string): boolean;
    procedure ResolveCall;
    function TryMask(Entry: PPrefixEntry; TopLevel: boolean): boolean;
    procedure AddSubHits(ParentPrefix: PPrefixEntry; ParentId: integer);
    function AddHit(Entry: PPrefixEntry; ParentId: integer): PHitEntry;
    function CopmareEnding(Mask: string): TEndingMatch;
    function CopmarePrefix(Mask: string): TPrefixMatch;
    procedure PackHits;
    procedure MergePrefixData(Dst: PPrefixData; Src: PHitEntry);
  public
    HitList: THitList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsValidCall(ACall: string): boolean;
    procedure GetAdifList(Lst: TStringList);
    function GetAdifItem(AAdif: integer): TPrefixData;
    function GetAdminItem(AAdif: integer; AAdmin: string): THitList;

    property Call: string read FCall write SetCall;
  published
    property PrefixFile: TFileName read FPrefixFile write SetPrefixFile;
    property CallFile: TFileName read FCallFile write SetCallFile;
  end;

procedure Register;

function AbsPath(S: string): string;




implementation

procedure Register;
begin
  RegisterComponents('GIS', [TCallParser]);
end;


function AbsPath(S: string): string;
begin
  if ExpandFileName(S) <> S then S := ExtractFilePath(ParamStr(0)) + S;
  Result := StringReplace(S, '\\', '\', [rfReplaceAll]);
end;


{ TCallParser }

//------------------------------------------------------------------------------
//                                init
//------------------------------------------------------------------------------
constructor TCallParser.Create(AOwner: TComponent);
begin
  inherited;

  FPrefLst := TPrefixList.Create;;
  FCallList := TStringList.Create;
end;


destructor TCallParser.Destroy;
begin
  FCallList.Free;
  FPrefLst.Free;

  inherited;
end;





//------------------------------------------------------------------------------
//                                get/set
//------------------------------------------------------------------------------
procedure TCallParser.SetCallFile(const Value: TFileName);
begin
  FCallFile := Value;
  if not (csDesigning in ComponentState) then
    try FCallList.LoadFromFile(AbsPath(Value)); except end;
end;


procedure TCallParser.SetPrefixFile(const Value: TFileName);
begin
  FPrefixFile := Value;
  if not (csDesigning in ComponentState) then
    try FPrefLst.LoadFromFile(AbsPath(Value)); except end;
end;


procedure TCallParser.SetCall(const Value: string);
begin
  FCall := Value;
  HitList := nil;
  if FormatCall(FCall) then ResolveCall;
end;








//------------------------------------------------------------------------------
//                           pre-process call sign
//------------------------------------------------------------------------------
function TCallParser.FormatCall(var ACallStr: string): boolean;
const
  //endings that may indicate station characteristics
  EndingPreserve = ':R:P:M:';
  EndingIgnore = ':AM:MM:QRP:A:B:BCN:LH:';

  Digits = ['0'..'9'];
  Letters = ['A'..'Z'];
  AllowedChars = Digits + Letters + ['/'];
  SafeOneCharPrefixes = ['U','G','F','I','K','N','W'];
  OneCharPrefixes = SafeOneCharPrefixes + ['R','B','M'];
var
  i, P: integer;
  S, S1, S2, S3: string;
  Body, Ending: string;
  L: TStringList;
  IsAdif: boolean;
begin
  S := UpperCase(Trim(ACallStr));
  for i:=Length(S) downto 1 do
    if S[i] = ' ' then Delete(S, i, 1);

  //see if mapping available
  S1 := FCallList.Values[S];
  Result := S1 <> '';
  if Result then
    begin
    ACallStr := S1;
    //see if mapped to ADIF number
    IsAdif := true;
    for i:=1 to Length(ACallStr) do
      IsAdif := IsAdif  and (ACallStr[i] in ['0'..'9']);
    if IsAdif then
      ACallStr := 'ADIF' + ACallStr;
    Exit;
    end;

  // /MM does not count for DXCC
  if Copy(ACallStr, Length(ACallStr)-2, 3) = '/MM' then
    begin Result := false; Exit; end;

  // /ANT is Antarctica
  if Copy(ACallStr, Length(ACallStr)-3, 4) = '/ANT' then
    begin Result := true; ACallStr := 'ADIF013'; Exit; end;

  //check length and '/'
  if (Length(S) < 2) or (S[1] = '/') then Exit;
  if Pos('//', S) > 0 then Exit;
  if S[Length(S)] = '/' then Delete(S, Length(S), 1);
  for P:=1 to Length(S) do
    if S[p] = '/' then S[p] := ','
    else if not (S[P] in AllowedChars) then Exit;

  //split call at '/' into S1, S2, S3
  L := TStringList.Create;
  try
    L.CommaText := S;
    //remove endings
    for i:=L.Count-1 downto 1 do
      if Pos(':' + L[i] + ':', EndingIgnore) > 0 then L.Delete(i);
    //verify
    if not (L.Count in [1..3]) then Exit;
    //L -> S1,S2,S3
    S1 := L[0];
    if L.Count > 1 then S2 := L[1] else S2 := '';
    if L.Count > 2 then S3 := L[2] else S3 := '';
  finally
    L.Free;
  end;

  //verify
  if Length(S3) > 1 then Exit;


  //exceptions
  if (Copy(S1, 1, 2) = 'HK') and (S2 = '0M') then //because 0M is invalid prefix
    begin ACallStr := S1 + '/' + S2; Result := true; Exit; end;
  if (Copy(S1, 1, 2) = 'FR') and (S2 = 'G') then //because G is 1-char prefix
    begin ACallStr := S1 + '/' + S2; Result := true; Exit; end;

  //call area digit
  if (Length(S2) = 1) and (S2[1] in Digits) then
    begin
    //cannot have 2 digital endings, e.g. J49AA/5/9
    if (S3 <> '') and (S3[1] in Digits) then Exit;
    //1-char prefix: I4AA/5 (only for Italy and USA)
    //U,{R},B,G,M,F - digit is not a call area, or call area sub-divisions exist
    if (Length(S1) > 1) and (S1[2] in Digits) and (S1[1] in ['I','K','N','W','R'])
      then S1 := S1[1]
    //2-char prefix: J49AA/5,3A2AA/5, UA3AA/5
    else if (Length(S1) > 2) and (S1[3] in Digits) then SetLength(S1, 2)
    //3-char prefix: 3DA0AA/5
    else if (Length(S1) > 3) and (S1[4] in Digits) then SetLength(S1, 3)
    else Exit; //no call area digit to replace
    //replace call area
    S1 := S1 + S2;
    S2 := '';
    end;

  //WPX rule for 1-char prefixes
  if (Length(S1) = 1) and (S1[1] in OneCharPrefixes)
    then S1 := S1 + '0'
  else if (Length(S2) = 1) and (Length(S3) = 1) and  (S1[1] in OneCharPrefixes)
    then S2 := S2 + '0'
  //1 char prefixes that do not conflict with endings /P, /B, /R, /M
  else if (Length(S2) = 1) and (S2[1] in SafeOneCharPrefixes)
    then S2 := S2 + '0';

  //find body
  if (Length(S2) > 1) and (Length(S2) < Length(S1))
    then Body := S2 else Body := S1;
  if Length(Body) < 2 then Exit;

  //find ending
  if Length(S2) = 1
    then if S3 <> '' then Exit else Ending := S2
    else Ending := S3;

  //merge body and ending
  if Ending <> ''
    then ACallStr := Body + '/' + Ending
    else ACallStr := Body;

  Result := true;
end;



//------------------------------------------------------------------------------
//                                resolve
//------------------------------------------------------------------------------

procedure TCallParser.ResolveCall;
var
  i: integer;
  Arr: PPrefixArray;
  Hit: PHitEntry;
  Adf: integer;
begin
  //adif specified in the call list
  if Copy(FCall, 1, 4) = 'ADIF' then
    begin
    Adf := StrToIntDef(Copy(FCall, 5, MAXINT), 0);
    if Adf <> 0 then
      begin
      SetLength(HitList, 1);
      HitList[0] := GetAdifItem(StrToIntDef(Copy(FCall, 5, MAXINT), 0));
      Exit;
      end;
    end;

  Arr := FPrefLst.Index[Pos(FCall[1], Chars), Pos(FCall[2], Chars)];

  for i:=0 to High(Arr) do
    if TryMask(Arr[i], true) then
      begin
      Hit := AddHit(Arr[i], -1);
      AddSubHits(Arr[i], Hit.Id);
      end;

  PackHits;
end;


procedure TCallParser.AddSubHits(ParentPrefix: PPrefixEntry; ParentId: integer);
var
  i: integer;
  ChildPrefix: PPrefixEntry;
  Hit: PHitEntry;
begin
  for i:=0 to High(ParentPrefix^.Children) do
    begin
    ChildPrefix := @FPrefLst.Entries[ParentPrefix^.Children[i]];
    if TryMask(ChildPrefix, false) then
      begin
      Hit := AddHit(ChildPrefix, ParentId);
      AddSubHits(ChildPrefix, Hit.Id);
      end;
    end;
end;


function TCallParser.AddHit(Entry: PPrefixEntry; ParentId: integer): PHitEntry;
var
  Parent: PHitEntry;
begin
  //grow hitlist
  SetLength(FHitTree, Length(FHitTree) + 1);
  //copy data from matching entry to hitlist
  Result := @FHitTree[High(FHitTree)];
  Result.Data := Entry.Data;
  Result.Kind := Entry.Kind;
  //ordinal number of the hit
  Result.Id := High(FHitTree);

  //remember your parent
  Result.Parent := ParentId;
  //tell the parent about its child
  if ParentId > 0 then
    begin
    Parent := @FHitTree[ParentId];
    SetLength(Parent.Children, Length(Parent.Children) + 1);
    Parent.Children[High(Parent.Children)] := Result.Id;
    end;
end;






//------------------------------------------------------------------------------
//                        compare call to mask
//------------------------------------------------------------------------------

const
  //mapping of comparison result to boolean output

  ResultForTop: array[TPrefixMatch, TEndingMatch] of boolean =
    ((false, false, false, false),
     (true, true, true, true),
     (false, false, false, true));

  ResultForChild: array[TPrefixMatch, TEndingMatch] of boolean =
    ((false, false, false, false),
     (false, false, false, false),
     (false, false, false, true));



function TCallParser.TryMask(Entry: PPrefixEntry; TopLevel: boolean): boolean;
const
  AllowedForTop = [pfDXCC, pfNonDXCC, pfProvince, pfStation, pfCity];
  AllowedForSub = [pfProvince, pfStation, pfCity];
var
  i: integer;
  PrefixMatch: TPrefixMatch;// (pfNE, pfLT, pfGE);
  EndingMatch: TEndingMatch;// (edNE, edP, edM, edEQ);
begin
  Result := false;

  //check entry kind
  if TopLevel
    then begin if not (Entry.Kind in AllowedForTop) then Exit; end
    else begin if not (Entry.Kind in AllowedForSub) then Exit; end;

  with TStringList.Create do
    try
      CommaText := Entry.Mask;
      for i:=0 to Count-1 do
        begin
        PrefixMatch := CopmarePrefix(Strings[i]);
        EndingMatch := CopmareEnding(Strings[i]);
        if TopLevel
          then Result := ResultForTop[PrefixMatch, EndingMatch]
          else Result := ResultForChild[PrefixMatch, EndingMatch];
        if Result then Exit;
        end;
    finally
      Free;
    end;
end;


function TCallParser.CopmarePrefix(Mask: string): TPrefixMatch;
var
  p, Pp, Pm: integer;
  Call: string;
begin
  Call := FCall;

  //remove endings
  Pp := Pos('/', Call);
  Pm := Pos('/', Mask);
  if Pp > 0 then Delete(Call, Pp, MAXINT);
  if Pm > 0 then Delete(Mask, Pm, MAXINT);

  //??
  if (Mask = '') or (Call = '')
    then begin Result := pfNE; Exit; end;

  for p:=1 to Length(Call) do
    begin
    //end of mask
    if Mask = '' then begin Result := pfGE; Exit; end;
    //non-matching char
    if Pos(Call[p], FPrefLst.Chop(Mask)) < 1 then
      begin Result := pfNE; Exit; end;
    end;

  if (Mask = '') or (Mask = '.') then begin Result := pfGE; Exit; end;

  //if ".", require exact length or just prefix with no suffix
  if (Mask[Length(Mask)] = '.') and
     not (Call[Length(Call)] in ['0'..'9']) //pref only?
    then begin Result := pfNE; Exit; end;

  Result := pfLT;
end;


function TCallParser.CopmareEnding(Mask: string): TEndingMatch;
var
  Pp, Pm: integer;
begin
  Pp := Pos('/', Call);
  Pm := Pos('/', Mask);

  //in mask only
  if (Pp < 1) and (Pm > 0) then Result := edM
  //in prefix only
  else if (Pp > 0) and (Pm < 1) then
    if (Pp = Length(Call)-1) and (Call[Pp+1] in [{'A',} 'M', 'P']) //ignore common endings
      then Result := edEQ
      else Result := edP
  //none
  else if (Pp < 1) and(Pm < 1) then Result := edEQ
  //both
  else if Copy(Call, Pp, MAXINT) = Copy(Mask, Pm, MAXINT) then Result := edEQ
  else Result := edNE;
end;







//------------------------------------------------------------------------------
//                        pack data from hit tree to hit list
//------------------------------------------------------------------------------

procedure TCallParser.PackHits;
var
  i: integer;
  Hit: PPrefixData;
begin
  //exclude hits without coordinates but save their names
  for i:=High(FHitTree) downto 0 do
    if FHitTree[i].Data.Location.x = MAXINT then
      begin
      //mark as used
      FHitTree[i].Id := -1;
      if FHitTree[i].Parent >= 0 then
        //add attribute to parent
        with FHitTree[FHitTree[i].Parent].Data do
          begin
          SetLength(Attributes, Length(Attributes) + 1);
          Attributes[High(Attributes)] := FHitTree[i].Data.Territory;
          end;
      end;

  //add to output
  for i:=High(FHitTree) downto 0 do
    if FHitTree[i].Id > -1 then //if unused
      begin
      SetLength(HitList, Length(HitList) + 1);
      Hit := @HitList[High(HitList)];
      Hit.Location := POINT(MAXINT, MAXINT);
      MergePrefixData(Hit, @FHitTree[i]);
      end;

  FHitTree := nil;
end;


procedure TCallParser.MergePrefixData(Dst: PPrefixData; Src: PHitEntry);
var
  i: integer;
begin
  //mark as used
  Src.Id := -1;

  //copy title from Src to Dst
  with Src.Data do
    case Src.Kind of
      pfDXCC, pfNonDXCC:
        Dst.Territory := Territory;

      pfProvince:
        if Dst.Province = ''
          then Dst.Province := Territory
          else Dst.Province := Territory + ', ' + Dst.Province;

      pfCity:
        Dst.City := Territory;

      pfStation:
        if Location.x <> MAXINT then Dst.City := Territory;
      end;

  //set location if it was not set by the child
  if Dst.Location.x = MAXINT then Dst.Location := Src.Data.Location;

  //copy fields from Src to Dst
  if Src.Data.Location.x <> MAXINT then
    begin
    if Dst.Prefix = '' then Dst.Prefix := Src.Data.Prefix;
    if Dst.CQ = '' then Dst.CQ := Src.Data.CQ;
    if Dst.ITU = '' then Dst.ITU := Src.Data.ITU;
    if Dst.Continent = '' then Dst.Continent := Src.Data.Continent;
    if Dst.TZ = '' then Dst.TZ := Src.Data.TZ;
    if Dst.ADIF = '' then Dst.ADIF := Src.Data.ADIF;
    if Dst.ProvinceCode = '' then Dst.ProvinceCode := Src.Data.ProvinceCode;
    end;

  //copy attributes
  SetLength(Dst.Attributes, Length(Dst.Attributes) + Length(Src.Data.Attributes));
  for i:=0 to High(Src.Data.Attributes) do
    Dst.Attributes[High(Dst.Attributes)-i] := Src.Data.Attributes[High(Src.Data.Attributes)-i];

  //add missing data from Src's parents
  if Src.Parent > -1 then MergePrefixData(Dst, @FHitTree[Src.Parent]);
end;







//------------------------------------------------------------------------------
//                                util
//------------------------------------------------------------------------------
function TCallParser.IsValidCall(ACall: string): boolean;
begin
  //valid call and not adif number
  Result := FormatCall(ACall) and (StrToIntDef(ACall, 0) = 0);
end;


procedure TCallParser.GetAdifList(Lst: TStringList);
var
  i: integer;
begin
  Lst.Clear;
  for i:=0 to FPrefLst.Count-1 do
    if FPrefLst.Entries[i].Kind = pfDXCC then
      with FPrefLst.Entries[i].Data do
        Lst.Add(Format('%s=-|%s|%s', [Adif, Prefix, Territory]));
end;


function TCallParser.GetAdifItem(AAdif: integer): TPrefixData;
var
  i: integer;
begin
  FillChar(Result, SizeOf(Result), 0);

  for i:=0 to FPrefLst.Count-1 do
    if (FPrefLst.Entries[i].Kind = pfDXCC) and
       (StrToInt(FPrefLst.Entries[i].Data.ADIF) = AAdif) then
        begin
        Result := FPrefLst.Entries[i].Data;
        Exit;
        end;
end;


function TCallParser.GetAdminItem(AAdif: integer; AAdmin: string): THitList;
var
  i, p: integer;
  Data: TPrefixData;
begin
  SetLength(Result, 0);

  for i:=0 to FPrefLst.Count-1 do
    if (FPrefLst.Entries[i].Kind in [pfProvince, pfCity]) then
       if (FPrefLst.Entries[i].Data.ProvinceCode = AAdmin) then
        begin
        Data := FPrefLst.Entries[i].Data;

        p := FPrefLst.Entries[i].Parent;
        while p > -1 do
          begin
          //get missing fields from the parent
          if Data.Adif = '' then Data.Adif := FPrefLst.Entries[p].Data.Adif;
          if Data.Cq = '' then Data.Cq := FPrefLst.Entries[p].Data.Cq;
          if Data.ITU = '' then Data.ITU := FPrefLst.Entries[p].Data.ITU;
          if Data.Continent = '' then Data.Continent := FPrefLst.Entries[p].Data.Continent;
          if Data.TZ = '' then Data.TZ := FPrefLst.Entries[p].Data.TZ;
          if Data.Province = '' then Data.Province := FPrefLst.Entries[p].Data.Province;
          if Data.ProvinceCode = '' then Data.ProvinceCode := FPrefLst.Entries[p].Data.ProvinceCode;
          if Data.City = '' then Data.City := FPrefLst.Entries[p].Data.City;
          if Data.Territory = '' then Data.Territory := FPrefLst.Entries[p].Data.Territory;

          //if parent is pfDxcc, done
          if (FPrefLst.Entries[p].Kind = pfDXCC) and (StrToInt(FPrefLst.Entries[p].Data.ADIF) = AAdif) then
            begin
            SetLength(Result, Length(Result)+1);
            Result[High(Result)] := Data;
            Break;
            end;

          //upper parent
          p := FPrefLst.Entries[p].Parent;
          end;
        end;
end;


end.


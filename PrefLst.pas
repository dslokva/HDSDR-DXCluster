//------------------------------------------------------------------------------
//The contents of this file are subject to the Mozilla Public License
//Version 1.1 (the "License"); you may not use this file except in compliance
//with the License. You may obtain a copy of the License at
//http://www.mozilla.org/MPL/ Software distributed under the License is
//distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
//or implied. See the License for the specific language governing rights and
//limitations under the License.
//
//The Original Code is PrefLst.pas.
//
//The Initial Developer of the Original Code is Alex Shovkoplyas, VE3NEA.
//Portions created by Alex Shovkoplyas are
//Copyright (C) 2005 Alex Shovkoplyas. All Rights Reserved.
//------------------------------------------------------------------------------


unit PrefLst;

interface

uses
  Windows, SysUtils, Classes;

const
  Digits = '0123456789';
  Letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Chars = Digits + Letters;
  HiChar = Length(Chars);


type
  TPrefixKind = (
    // 0       1        2           3         4           5
    pfNone, pfDXCC, pfProvince, pfStation, pfDelDXCC, pfOldPrefix,
    //  6            7               8           9
    pfNonDXCC, pfInvalidPrefix, pfDelProvince, pfCity);


  PPrefixData = ^TPrefixData;
  TPrefixData = record
    //from file
    Location: TPoint;
    Territory: string;
    Prefix: string;
    CQ: string;
    ITU: string;
    Continent: string;
    TZ: string;
    ADIF: string;
    ProvinceCode: string;
    //inferred
    Province: string;
    City: string;
    Attributes: array of string;
    end;

  THitList = array of TPrefixData;


  PPrefixEntry = ^TPrefixEntry;
  PPrefixArray = array of PPrefixEntry;

  TPrefixEntry = record
    Data: TPrefixData;
    Id: integer;
    Kind: TPrefixKind;
    Level: integer;
    Mask: string;
    Parent: integer;
    Children: array of integer;
    end;

  TPrefixArray = array of TPrefixEntry;


  TPrefixList = class
  private
    procedure LoadFromStrings(List: TStringList);
    function AddEntry: PPrefixEntry;
    procedure BuildRelations;
    function ParentOf(EntryNo: integer): integer;
    procedure BuildIndex;
    procedure AddToIndex(C1, C2: Char; Entry: PPrefixEntry);
  public
    Entries: TPrefixArray;
    Count: integer;
    Index: array[1..HiChar, 1..HiChar] of PPrefixArray;
    procedure LoadFromFile(AFileName: TFileName);
    function Chop(var Str: string): string;
  end;




implementation


//------------------------------------------------------------------------------
//                            load prefix list
//------------------------------------------------------------------------------

procedure TPrefixList.LoadFromFile(AFileName: TFileName);
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    L.LoadFromFile(AFileName);
    LoadFromStrings(L);
    BuildRelations;
    BuildIndex;
  finally
    L.Free;
  end;
end;


procedure TPrefixList.LoadFromStrings(List: TStringList);
var
  Tokens: TStringList;
  Line: integer;
  EntryKind: TPrefixKind;
begin
  Entries := nil;
  Count := 0;

  if List.Count < 4 then Exit;


  Tokens := TStringList.Create;
  try
    for Line:=3 to List.Count-1 do
      begin
      //parse line
      Tokens.Text := StringReplace(List[Line], '|', #10, [rfReplaceAll]);
      if Tokens.Count < 4 then Continue;
      //remove the 'show on map' part
      if (Length(Tokens[0]) > 0) and (Tokens[0][1] in ['L', 'M', '-'])
        then Tokens[0] := Copy(Tokens[0], 2, MAXINT);
      //interpret image index as entry kind
      EntryKind := TPrefixKind(StrToIntDef('$' + Copy(Tokens[0], 1, 2), 0));
      if not (EntryKind in [pfDXCC, pfProvince, pfStation, pfNonDXCC, pfCity])
        then Continue;
      //populate new entry
      with AddEntry^ do
        begin
        Id := Count-1;
        Kind := EntryKind;
        //level
        Level := StrToIntDef('$' + Copy(Tokens[0], 3, 2), 0);
        //location
        Data.Location.x := StrToIntDef(Tokens[1], MAXINT);
        Data.Location.y := StrToIntDef(Tokens[2], MAXINT);
        //rest
        Data.Territory := Tokens[3];
        Data.Prefix := Tokens[4];
        Data.CQ := Tokens[5];
        Data.ITU := Tokens[6];
        Data.Continent := Tokens[7];
        Data.TZ := Tokens[8];
        Data.ADIF := Tokens[9];
        Data.ProvinceCode := Tokens[10];
        Mask := Tokens[13];
        end;
      end;
  finally
    Tokens.Free;
  end;

  SetLength(Entries, Count);
end;


function TPrefixList.AddEntry: PPrefixEntry;
begin
  if Length(Entries) <= Count then SetLength(Entries, Length(Entries) + 500);
  Result := @Entries[Count];
  Inc(Count);
end;








//------------------------------------------------------------------------------
//                       build parent/child relations
//------------------------------------------------------------------------------

procedure TPrefixList.BuildRelations;
var
  i: integer;
begin
  //for each entry
  for i:=0 to Count-1 do
    begin
    //find parent
    Entries[i].Parent := ParentOf(i);
    //if parent found, ...
    if Entries[i].Parent > -1 then
      //... add current entry to parent's list of children
      with Entries[Entries[i].Parent] do
        begin
        SetLength(Children, Length(Children) + 1);
        Children[High(Children)] := i;
        end;
    end;
end;


function TPrefixList.ParentOf(EntryNo: integer): integer;
var
  i: integer;
begin
  Result := -1;
  if Entries[EntryNo].Level = 0 then Exit;

  //speed this up by walking along the Entries[EntryNo-1].Parent chain
  for i:=EntryNo-1 downto 0 do
    if Entries[i].Level < Entries[EntryNo].Level then
      begin Result := i; Exit; end;
end;






//------------------------------------------------------------------------------
//                             build index
//------------------------------------------------------------------------------

procedure TPrefixList.BuildIndex;
var
  MaskList: TStringList;
  Mask: string;
  PrefixNo, MaskNo: integer;
  i, j: integer;
  p1, p2: integer;
  L1, L2: string;
begin
  //Clear Index
  for i:=1 to HiChar do
    for j:=1 to HiChar do
      Index[i, j] := nil;


  MaskList := TStringList.Create;
  try
    //iterate through DXCC entries
    for PrefixNo:=0 to Count-1 do
      begin
      if not (Entries[PrefixNo].Kind in [pfDXCC, pfNonDXCC]) then Continue;
      //iterate through masks of the entry
      MaskList.CommaText := Entries[PrefixNo].Mask;
      for MaskNo:=0 to MaskList.Count-1 do
        begin
        //expand mask
        Mask := MaskList[MaskNo];
        L1 := Chop(Mask);
        if Mask = '' then L2 := Chars else L2 := Chop(Mask);
        //add to index
        for p1:=1 to Length(L1) do
          for p2:=1 to Length(L2) do
        AddToIndex(L1[p1], L2[p2], @Entries[PrefixNo]);
        end;
      end;
  finally MaskList.Free; end;
end;


//expand the 1-st symbol of the mask
function TPrefixList.Chop(var Str: string): string;
var
  p, i: integer;
  Ch: Char;
begin
  case Str[1] of
    '#': Result := Digits;
    '@': Result := Letters;
    '?': Result := Chars;
    '[':
      begin
      //extract [..]
      p := Pos(']', Str);
      Result := Copy(Str, 2, p - 2);
      Delete(Str, 1, p - 1);
      //expand ranges
      for i:=Length(Result)-1 downto 2 do
        if Result[i] = '-' then
          begin
          Delete(Result, i, 1);
          for Ch:=Pred(Result[i]) downto Succ(Result[i-1]) do
            Insert(Ch, Result, i);
          end;
      end;
    else Result := Str[1];
    end;
  Delete(Str, 1, 1);
end;


procedure TPrefixList.AddToIndex(C1, C2: Char; Entry: PPrefixEntry);
var
  Len, i: integer;
  p1, p2: integer;
begin
  p1 := Pos(C1, Chars);
  p2 := Pos(C2, Chars);
  Len := Length(Index[p1,p2]);
  //no dupes
  for i:=0 to Len-1 do if Index[p1,p2][i] = Entry then Exit;
  //add
  SetLength(Index[p1,p2], Len + 1);
  Index[p1,p2][Len] := Entry;
end;




end.


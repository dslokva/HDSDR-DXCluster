unit UDPServerJSONObjects;

interface

type
  TSetValuesAnswer = class(TObject)
  public
    result : string;
    //if result = '0' all is OK, if any other value, include text string - we make assumption that error occured.
    constructor Create(resultStr : string);
  end;

type
  TGetValuesAnswer = class(TObject)
  public
    callsign: string;
    hamName: UnicodeString;
    hamQTH: UnicodeString;
    QSODate: string;
    QSOStartTime: string;
    QSOEndTime: string;
    mode: string;
    band: string;
    freq: string;
    rstSent: string;
    rstRcvd: string;
    notesCallsign: string;
    notesQSO: string;
    state: string;
    subDivision: string;
    grid: string;
    IOTA: string;

end;

type
  TSimpleCallsignAnswer = class(TObject)
  public
    callsign: string;
    hamName: string;
    hamQTH: string;
    isLoTWUser: char;
    isEqslUser: char;
    presentOnMode: char;
    presentOnBand: char;
    presentInLog: char;

  public
    constructor Create(callsignStr, hamNameStr, hamQTHStr: string;
      isLoTWUserChar, isEqslUserChar, presentOnBandChar, presentOnModeChar,
      presentInLogChar: char);
  end;

type
  TQSOHistoryItem = class(TObject)
  public
    QSODate: string;
    QSOStartTime: string;
    QSOEndTime: string;
    mode: string;
    band: string;
    freq: string;
    rstSent: string;
    rstRcvd: string;
    notesCallsign: string;
    notesQSO: string;
  end;

type
  TQSOHistoryAnswer = class(TObject)
    callsign: string;
    hamQTH: string;
    hamName: string;
    CQZone: word;
    ITUZone: word;
    isLoTWUser: char;
    isEqslUser: char;
    historyItems: TArray<TQSOHistoryItem>;

  public
    constructor Create();
  end;

const
  REQ_GET_IS_IN_LOG = '1';
  REQ_GET_QSO_HISTORY = '2';
  REQ_SET_NEW_QSO_FIELDS = '3';
  REQ_GET_NEW_QSO_FIELDS = '4';

implementation

constructor TSimpleCallsignAnswer.Create(callsignStr, hamNameStr,
  hamQTHStr: string; isLoTWUserChar, isEqslUserChar, presentOnBandChar,
  presentOnModeChar, presentInLogChar: char);
begin
  callsign := callsignStr;
  hamName := hamNameStr;
  hamQTH := hamQTHStr;
  isLoTWUser := isLoTWUserChar;
  isEqslUser := isEqslUserChar;
  presentOnBand := presentOnBandChar;
  presentOnMode := presentOnModeChar;
  presentInLog := presentInLogChar;
  inherited Create();
end;

constructor TQSOHistoryAnswer.Create();
begin
  historyItems := TArray<TQSOHistoryItem>.Create();
  inherited Create();
end;

constructor TSetValuesAnswer.Create(resultStr : string);
begin
  result := resultStr;
  inherited Create();
end;

end.

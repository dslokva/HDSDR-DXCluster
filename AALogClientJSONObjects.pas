unit AALogClientJSONObjects;

interface

type TSimpleCallsignRequest = class(TObject)
  callsign : string;
  band : string;
  mode : string;
  requestType : string;
  dataLimit : integer;

  public
    constructor Create(callsignStr, bandStr, modeStr, requestTypeStr: string);
end;

type TSetNewQSOValuesRequest = class(TObject)
  callsign : string;
  freq : string;
  mode : string;
  requestType : string;

  public
    constructor Create(callsignStr, freqStr, freqMode: string);
end;

type TGetNewQSOValuesRequest = class(TObject)
  requestType : string;
  getNewQSOValues : char;

  public
    constructor Create();
end;

const
  REQ_IS_IN_LOG = '1';
  REQ_GET_QSO_HISTORY = '2';
  REQ_SET_NEW_QSO_FIELDS = '3';
  REQ_GET_NEW_QSO_FIELDS = '4';

implementation

constructor TSimpleCallsignRequest.Create(callsignStr, bandStr, modeStr, requestTypeStr: string);
begin
  callsign := callsignStr;
  band := bandStr;
  mode := modeStr;
  requestType := requestTypeStr;
  dataLimit := 5;
  inherited Create();
End;

constructor TSetNewQSOValuesRequest.Create(callsignStr, freqStr, freqMode: string);
begin
  callsign := callsignStr;
  freq := freqStr;
  mode := freqMode;
  requestType := REQ_SET_NEW_QSO_FIELDS;
  inherited Create();
End;

constructor TGetNewQSOValuesRequest.Create();
begin
  requestType := REQ_GET_NEW_QSO_FIELDS;
  getNewQSOValues := '1';
  inherited Create();
End;
END.

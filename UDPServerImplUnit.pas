unit UDPServerImplUnit;

interface

uses
  IdUDPServer, IdBaseComponent, IdComponent, IdUDPBase, IdSocketHandle, IdGlobal, Windows, System.SysUtils, JSons;

type TSimpleCallsignAnswer = class(TObject)
  callsign : string;
  presentOnBand : char;
  presentInLog : char;

  public
    constructor Create(callsignStr : string; presentOnBandChar, presentInLogChar : char);
end;

type
 UDPServerImpl = class(TObject)

   public
     procedure InitialiseAndRunServer(bindAddress : string; port : UInt16);
     procedure StopSever;

   private
     procedure ProcessIncomingData(incomingString : string; ABinding: TIdSocketHandle);
     procedure IdUDPServerUDPRead(AThread: TIdUDPListenerThread; const AData: TIdBytes; ABinding: TIdSocketHandle);
     procedure ProcessSimpleCallsignRequest(request : TJson; ABinding: TIdSocketHandle);
 end;

const
  IS_IN_LOG = '1';

implementation

var
  UDPServer: TIdUDPServer;

constructor TSimpleCallsignAnswer.Create(callsignStr : string; presentOnBandChar, presentInLogChar : char);
begin
  callsign := callsignStr;
  presentOnBand := presentOnBandChar;
  presentInLog := presentInLogChar;
  inherited Create();
end;

procedure DebugMsg(const Msg: String);
begin
    OutputDebugString(PChar('DEBUG  ' + TimeToStr(Time)+':  '+ Msg))
end;

procedure UDPServerImpl.StopSever;
begin
UDPServer.Active := false;
End;

procedure UDPServerImpl.InitialiseAndRunServer(bindAddress : string; port : UInt16);
begin
UDPServer := TIdUDPServer.Create(nil) ;

with UDPServer do begin
  DefaultPort := 3541;
  Bindings.Add.IP := '127.0.0.1';
  BroadcastEnabled := False;
  ThreadedEvent := True;
  OnUDPRead := IdUDPServerUDPRead;
  IPVersion := Id_IPv4;
  ReuseSocket := rsOSDependent;
  Active := true;
  DebugMsg('UDP Server started on port: '+IntToStr(DefaultPort));
end;

End;

procedure UDPServerImpl.IdUDPServerUDPRead(AThread: TIdUDPListenerThread; const AData: TIdBytes; ABinding: TIdSocketHandle);
var
  s : string;
begin
  s := '';
  try
    s := BytesToString(AData);
    if Length(s) > 0 then begin
      ProcessIncomingData(s, ABinding);
    end;
  finally
    DebugMsg('From ' + ABinding.IP + ' Incoming packet: '+ s);
  end;

End;

procedure UDPServerImpl.ProcessIncomingData(incomingString : string; ABinding: TIdSocketHandle);
var
  JsonRequest: TJson;
  requestType : string;

begin
JsonRequest := TJson.Create();

try
  JsonRequest.Parse(incomingString);
  requestType := JSonRequest.Values['requestType'].AsString;

  if requestType = IS_IN_LOG then ProcessSimpleCallsignRequest(JsonRequest, ABinding) else
  if requestType = '2' then ProcessSimpleCallsignRequest(JsonRequest, ABinding) else begin
    DebugMsg('Unknown request type: ' + incomingString);
    ABinding.SendTo(ABinding.PeerIP, ABinding.PeerPort, 'Unknown requestType', ABinding.IPVersion);
  end;
except
  DebugMsg('Error processing incoming packet: ' + incomingString);
end;

End;

function CreateSimpleCallsignAnswer(answer : TSimpleCallsignAnswer) : string;
var
  JsonAnswer : TJson;

begin
try
//answer #1 - check callsign existence in log.
JsonAnswer := TJson.Create();
JsonAnswer.Put('answerType', IS_IN_LOG);

with JsonAnswer['answerData'].AsObject do begin
  Put('callsign', answer.callsign);
  Put('presentOnBand', answer.presentOnBand);
  Put('presentInLog', answer.presentInLog);
end;

result := JsonAnswer.Stringify;

finally
//
end;

End;

procedure UDPServerImpl.ProcessSimpleCallsignRequest(request : TJson; ABinding: TIdSocketHandle);
var
  requestData : TJsonObject;
  callsign, band, answerStr : string;
  onBand, inLog : char;
  answer : TSimpleCallsignAnswer;

begin
  requestData := request.Values['requestData'].AsObject;
  //this variables should be used for your search
  //band field variants: '160m', '80m', '40m', '20m', '17m', '15m', '12m', '10m', '6m', '4m', '2m', '70cm'

  callsign := requestData.Values['callsign'].AsString;
  band := requestData.Values['band'].AsString;
  {
    ....AALog code goes here....
  }
  onBand := '1';
  inLog := '1';

  //make string from created json object and send answer to client
  answer := TSimpleCallsignAnswer.Create(callsign, onBand, inLog);
  answerStr := CreateSimpleCallsignAnswer(answer);
  ABinding.SendTo(ABinding.PeerIP, ABinding.PeerPort, answerStr, ABinding.IPVersion);
End;


END.

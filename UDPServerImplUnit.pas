unit UDPServerImplUnit;

interface

uses
  IdUDPServer, IdBaseComponent, IdComponent, IdUDPBase, IdSocketHandle, IdGlobal, Windows, System.SysUtils, JSons;

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

implementation

var
  UDPServer: TIdUDPServer;

procedure DebugMsg(const Msg: String);
begin
    OutputDebugString(PChar('DEBUG  ' + TimeToStr(Time)+':  '+ Msg))
end;

procedure UDPServerImpl.StopSever;
begin
UDPServer.Active := false;
End;

procedure UDPServerImpl.InitialiseAndRunServer(bindAddress : string; port : UInt16);
var
  Binding: TIdSocketHandle;

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
  i : integer;
  s : string;
begin
  s := '';
  try
    s := BytesToString(AData);
    if Length(s) > 0 then begin
      ProcessIncomingData(s, ABinding);
    end;
  except
    //DebugMsg('Incoming packet: '+ s);
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

  if requestType = '1' then ProcessSimpleCallsignRequest(JsonRequest, ABinding) else
  if requestType = '2' then ProcessSimpleCallsignRequest(JsonRequest, ABinding) else
  DebugMsg('Unknown request type: ' + incomingString);
  ABinding.SendTo(ABinding.PeerIP, ABinding.PeerPort, 'Unknown requestType', ABinding.IPVersion);

except
  DebugMsg('Error processing incoming packet: ' + incomingString);
end;

End;

procedure UDPServerImpl.ProcessSimpleCallsignRequest(request : TJson; ABinding: TIdSocketHandle);
var
  JsonAnswer  : TJson;
  requestData : TJsonArray;
  requestItem : TJsonObject;
  callsign, band : string;
  i : integer;

begin
  JsonAnswer  := TJson.Create();
  requestData := request.Values['requestData'].AsArray;

  for i := 0 to requestData.Count-1 do begin
    requestItem := requestData.Items[i].AsObject;
    callsign := requestItem.Values['callsign'].AsString;
    band := requestItem.Values['band'].AsString;
  end;

  JsonAnswer.Put('answerType', 1);

  ABinding.SendTo(ABinding.PeerIP, ABinding.PeerPort, JsonAnswer.Stringify, ABinding.IPVersion);
End;


END.

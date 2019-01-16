unit UDPServerImplUnit;

interface

uses
  IdUDPServer, IdBaseComponent, IdComponent, IdUDPBase, IdSocketHandle, IdGlobal, Windows;

type
 UDPServerImpl = class

   procedure IdUDPServerUDPRead(AThread: TIdUDPListenerThread; const AData: TIdBytes; ABinding: TIdSocketHandle);
   procedure InitialiseAndRun(bindAddress : string; port : UInt16);
   procedure StopSever;

 end;

implementation

var
  UDPServer: TIdUDPServer;

procedure DebugMsg(const Msg: String);
begin
    OutputDebugString(PChar(Msg))
end;

procedure UDPServerImpl.StopSever;
begin
UDPServer.Destroy;
End;

procedure UDPServerImpl.InitialiseAndRun(bindAddress : string; port : UInt16);
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
  Active := True;
end;

End;

procedure UDPServerImpl.IdUDPServerUDPRead(AThread: TIdUDPListenerThread; const AData: TIdBytes; ABinding: TIdSocketHandle);
var
  i : Integer;
  s : String;
begin
  s := '';
  try
    i := 0;
    while (AData[i] <> 0) do
      begin
      s := s + chr(AData[i]);
      i := i + 1;
      end;
  finally
    DebugMsg(PChar(s));
  end;

End;

END.

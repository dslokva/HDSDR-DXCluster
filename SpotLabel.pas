unit SpotLabel;

interface

  uses
    Vcl.StdCtrls, System.Classes;

type
  TSpotLabel = class(TLabel)
    public
      spotDE : string;
      isLotwEqsl : boolean;
      isInLog : boolean;
      receiveTime : TDateTime;
      selected : boolean;
      constructor Create(AOwner: TComponent; spotDEStr : string; receiveTimeOrig : TDateTime);
  end;

implementation

constructor TSpotLabel.Create(AOwner: TComponent; spotDEStr : string; receiveTimeOrig : TDateTime);
begin
  spotDE := spotDEStr;
  receiveTime := receiveTimeOrig;
  selected := false;
  inherited Create(AOwner);
End;

END.

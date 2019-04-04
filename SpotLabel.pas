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
      onHold : boolean;
      frequency: variant;
      constructor Create(AOwner: TComponent; spotDEStr : string; receiveTimeOrig : TDateTime; freq: variant);
  end;

implementation

constructor TSpotLabel.Create(AOwner: TComponent; spotDEStr : string; receiveTimeOrig : TDateTime; freq: variant);
begin
  spotDE := spotDEStr;
  receiveTime := receiveTimeOrig;
  selected := false;
  onHold := false;
  frequency := freq;
  inherited Create(AOwner);
End;

END.

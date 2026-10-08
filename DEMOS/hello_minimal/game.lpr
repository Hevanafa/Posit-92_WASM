library Game;

{$Mode ObjFPC}
{$H+}{$J-}

uses
  P92Core, P92WasmHost, P92Graphics, P92VGA;

procedure OnReady;
begin
  HideCursor
end;

procedure Update;
begin

end;

procedure Draw;
begin
  Cls($FF101010);

  Print('Hello Posit-92!', 40, 40);
end;

procedure Init;
var
  config: TP92AppConfig;
begin
  config := DefaultP92AppConfig;

  P92Start(config);
end;

exports
  Init, OnReady, Update, Draw;

begin
  { Starting point is intentionally left empty }
end.

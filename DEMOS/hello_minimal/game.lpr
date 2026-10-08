library Game;

{$Mode ObjFPC}
{$H+}{$J-}

uses
  P92Core, P92WasmHost, P92Graphics, P92Keyboard, P92VGA;

var
  x, y: integer;

procedure OnReady;
begin
  HideCursor;
  x := 144;
  y := 84;
end;

procedure Update;
begin
  if IsKeyDown(SC_ESCAPE) then SignalDone;

  if IsKeyDown(SC_W) then dec(y, 2);
  if IsKeyDown(SC_S) then inc(y, 2);
  if IsKeyDown(SC_A) then dec(x, 2);
  if IsKeyDown(SC_D) then inc(x, 2);
end;

procedure Draw;
const
  Green = $FF008000;
  Black = $FF000000;
begin
  Cls($FF101010);

  RectFill(x, y, x + 31, y + 31, Green);
  RectFill(x + 4, y + 8, x + 11, y + 15, Black);
  RectFill(x + 20, y + 8, x + 27, y + 15, Black);
  RectFill(x + 16, y + 20, x + 19, y + 23, Black);

  Print('Hello Posit-92!', 100, 144);
  Print('Use WASD to move', 96, 160);
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

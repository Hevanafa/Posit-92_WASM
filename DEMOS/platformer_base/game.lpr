{
  Platformer base demo
  Part of Posit-92 game engine
  Mixins: bmfont, sound
}

library Game;

{$Mode ObjFPC}
{$H+}  { Use AnsiStrings }
{$J-}  { Switch off assignments to typed constants }

uses
  P92Core, P92WasmHost, P92Fonts, P92AssetRegistry,
  P92Keyboard, P92Mouse,
  P92Tex, P92TexDraw, P92Geometry,
  P92Timing, P92VGA,
  Assets;

const
  Gravity = 300;
  White = $FFFFFFFF;

var
  { Game state variables }
  gameTime: double;

  playerBody: TPhysicsBody;

{ Engine region }

{ Load game assets here }
procedure OnPreload;
begin
  texSpecimenP92[0] := RequestImage('assets/images/specimen_p-92_1.png');
  texSpecimenP92[1] := RequestImage('assets/images/specimen_p-92_2.png');
end;

{ Initialise game state here }
procedure OnReady;
begin
  HideCursor;

  gameTime := 0.0;

  playerBody := Default(TPhysicsBody);
  playerBody.x := 100;
  playerBody.y := 100;
  playerBody.width := 24;
  playerBody.height := 32;
end;

procedure Update;
begin
  if IsKeyDown(SC_ESCAPE) then SignalDone;

  if IsKeyDown(SC_LEFT) then
    playerBody.vx := -60;
  if IsKeyDown(SC_RIGHT) then
    playerBody.vx := 60;

  playerBody.x := playerBody.x + playerBody.vx * DeltaTime;

  gameTime := gameTime + DeltaTime
end;

procedure Draw;
begin
  Cls($FF6495ED);

  if (trunc(gameTime * 4) and 1) > 0 then
    Spr(texSpecimenP92[1], 148, 84)
  else
    Spr(texSpecimenP92[0], 148, 84);

  DrawPhysicsBody(playerBody, white);

  PrintDefaultCentred('Hello world!', VgaWidth div 2, 120);
end;

procedure Init;
var
  config: TP92AppConfig;
begin
  config := DefaultP92AppConfig;

  P92Start(config);
end;

exports
  Init,
  OnPreload,
  OnReady,
  Update,
  Draw;

begin
  { Starting point is intentionally left empty }
end.

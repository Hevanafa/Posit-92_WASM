{
  Default boilerplate
  Mixins: bmfont, sound
}

library Game;

{$Mode ObjFPC}
{$H+}  { Use AnsiStrings }
{$J-}  { Switch off assignments to typed constants }

uses
  P92Core, P92WasmHost, P92Fonts, P92AssetRegistry,
  P92Keyboard, P92Mouse,
  P92Geometry, P92Tex, P92TexDraw, P92Timing, P92VGA,
  Assets;

const
  { pixels per second }
  Velocity = 100;

var
  { Game state variables }
  gameTime: double;

  playerZone: TZone;

{ Load game assets here }
procedure OnPreload;
begin
  texSpecimenP92[0] := RequestImage('assets/images/specimen_p-92_1.png');
  texSpecimenP92[1] := RequestImage('assets/images/specimen_p-92_2.png');

  texSlime := RequestImage('assets/images/basic_slime.png');
  texShadow := RequestImage('assets/images/shadow.png');
end;

{ Initialise game state here }
procedure OnReady;
begin
  HideCursor;

  RandSeed := 255;

  gameTime := 0.0;

  playerZone.x := VGAWidth div 2;
  playerZone.y := VGAHeight div 2;
  playerZone.width := 32;
  playerZone.width := 16;
end;

{ Free resources here }
procedure OnCleanup;
begin
  FreeTex(texSpecimenP92[0]);
  FreeTex(texSpecimenP92[1]);
end;

procedure Update;
begin
  if IsKeyDown(SC_ESCAPE) then SignalDone;

  if IsKeyDown(SC_W) then
    playerZone.y := playerZone.y - Velocity * DeltaTime;
  if IsKeyDown(SC_S) then
    playerZone.y := playerZone.y + Velocity * DeltaTime;

  if IsKeyDown(SC_A) then
    playerZone.x := playerZone.x - Velocity * DeltaTime;
  if IsKeyDown(SC_D) then
    playerZone.x := playerZone.x + Velocity * DeltaTime;

  gameTime := gameTime + DeltaTime
end;

procedure Draw;
begin
  Cls($FF6495ED);

  if (trunc(gameTime * 4) and 1) > 0 then
    Spr(texSpecimenP92[1], 148, 84)
  else
    Spr(texSpecimenP92[0], 148, 84);

  spr(texSlime,
    trunc(playerZone.x),
    trunc(playerZone.y + playerZone.height - GetTexHeight(texSlime)));

  spr(texShadow, trunc(playerZone.x), trunc(playerZone.y));

  PrintDefaultCentred('Hello world!', VgaWidth div 2, 120);
end;


procedure Init;
var
  config: TP92AppConfig;
begin
  config := DefaultP92AppConfig;

  config.OnPreload := @OnPreload;
  config.OnReady := @OnReady;
  config.Update := @Update;
  config.Draw := @Draw;
  config.OnCleanup := @OnCleanup;

  P92Start(config);
end;

exports
  Init;

begin
  { Starting point is intentionally left empty }
end.

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
  P92Timing, P92Panic, P92VGA,

  Assets;

const
  Gravity = 300;
  White = $FFFFFFFF;

type
  TMapObject = record
    active: boolean;
    zone: TZone;
  end;

var
  { Game state variables }
  gameTime: double;

  playerBody: TPhysicsBody;
  mapObjects: array[0..9] of TMapObject;


function IsLeftPressed: boolean;
begin
  IsLeftPressed := IsKeyDown(SC_A) or IsKeyDown(SC_LEFT)
end;

function IsRightPressed: boolean;
begin
  IsRightPressed := IsKeyDown(SC_D) or IsKeyDown(SC_RIGHT)
end;

procedure SpawnMapObject(const x, y: double);
var
  a, idx: smallint;
begin
  idx := -1;

  for a:=0 to high(mapObjects) do
    if not mapObjects[a].active then begin
      idx := a;
      break
    end;

  if idx < 0 then PanicHalt('SpawnMapObject: Map object pool is full!');

  fillchar(mapObjects[idx], sizeof(TMapObject), 0);

  mapObjects[idx].active := true;
  mapObjects[idx].zone.x := x;
  mapObjects[idx].zone.y := y;
  mapObjects[idx].zone.width := 20;
  mapObjects[idx].zone.height := 20;
end;

{ Engine region }

{ Load game assets here }
procedure OnPreload;
begin
  texSpecimenP92[0] := RequestImage('assets/images/specimen_p-92_1.png');
  texSpecimenP92[1] := RequestImage('assets/images/specimen_p-92_2.png');
end;

{ Initialise game state here }
procedure OnReady;
var
  a: smallint;
begin
  HideCursor;

  gameTime := 0.0;

  for a:=0 to high(mapObjects) do
    fillchar(mapObjects[a], sizeof(TMapObject), 0);

  playerBody := Default(TPhysicsBody);
  playerBody.x := 100;
  playerBody.y := 100;
  playerBody.width := 24;
  playerBody.height := 32;

  SpawnMapObject(200, 100);
end;

procedure Update;
begin
  if IsKeyDown(SC_ESCAPE) then SignalDone;

  if IsLeftPressed then
    playerBody.vx := -60;
  if IsRightPressed then
    playerBody.vx := 60;

  playerBody.vx := playerBody.vx * 0.9;

  if abs(playerBody.vx) < 0.1 then playerBody.vx := 0;

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

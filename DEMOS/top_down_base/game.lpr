{
  Top-down base
  Mixins: bmfont, sound
}

library Game;

{$Mode ObjFPC}
{$H+}  { Use AnsiStrings }
{$J-}  { Switch off assignments to typed constants }

uses
  P92Core, P92WasmHost, P92Fonts, P92Conversions,
  P92AssetRegistry, P92AssetHandles,
  P92Keyboard, P92Mouse, P92Panic,
  P92Geometry, P92Graphics, P92Tex, P92TexDraw, P92Timing, P92VGA,
  Assets, MapItem, MapObject;

const
  { pixels per second }
  Velocity = 100;

  Red = $FFFF5555;


var
  { Game state variables }
  gameTime: double;

  coins: smallint;
  playerZone: TZone;

  mapItems: array[0..9] of TMapItem;
  mapObjects: array[0..9] of TMapObject;


procedure SpawnCoin(const x, y: double);
var
  a, idx: smallint;
begin
  idx := -1;

  for a:=0 to high(mapItems) do
    if not mapItems[a].active then begin
      idx := a;
      break
    end;

  if idx < 0 then PanicHalt('SpawnCoin: Map item pool is full!');

  FillChar(mapItems[idx], sizeof(TMapItem), 0);

  mapItems[idx].active := true;
  mapItems[idx].offsetY := -25;
  mapItems[idx].texHandle := texCoin;

  mapItems[idx].zone.x := x;
  mapItems[idx].zone.y := y;
  mapItems[idx].zone.width := 16;
  mapItems[idx].zone.height := 8;
end;

procedure SpawnMapObject(const objectType: TMapObjectType; const x, y: double);
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
  mapObjects[idx].texHandle := texCrate;

  mapObjects[idx].zone.x := x;
  mapObjects[idx].zone.y := y;
  mapObjects[idx].zone.width := 32;
  mapObjects[idx].zone.height := 16;
end;

{ Load game assets here }
procedure OnPreload;
begin
  texSpecimenP92[0] := RequestImage('assets/images/specimen_p-92_1.png');
  texSpecimenP92[1] := RequestImage('assets/images/specimen_p-92_2.png');

  texSlime := RequestImage('assets/images/basic_slime.png');
  texShadow := RequestImage('assets/images/shadow.png');
  texCoin := RequestImage('assets/images/coin.png');
  texCrate := RequestImage('assets/images/crate.png');
end;

{ Initialise game state here }
procedure OnReady;
var
  a: smallint;
begin
  HideCursor;

  RandSeed := 255;

  gameTime := 0.0;

  coins := 0;

  playerZone.x := VGAWidth div 2;
  playerZone.y := VGAHeight div 2;
  playerZone.width := 32;
  playerZone.height := 16;

  FillChar(mapItems, SizeOf(TMapItem), 0);

  for a:=1 to 10 do
    SpawnCoin(40 + random(240), 20 + random(160));

  SpawnMapObject(MapObjectCrate, VGAWidth shr 1, 40);
end;

{ Free resources here }
procedure OnCleanup;
begin
  FreeTex(texSpecimenP92[0]);
  FreeTex(texSpecimenP92[1]);
end;

procedure Update;
var
  a: smallint;
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

  for a:=0 to high(mapItems) do begin
    if not mapItems[a].active then continue;

    if ZoneIntersects(playerZone, mapItems[a].zone) then begin
      mapItems[a].active := false;
      inc(coins)
    end;
  end;

  gameTime := gameTime + DeltaTime
end;

procedure Draw;
var
  a: smallint;
begin
  Cls($FF6495ED);

  if (trunc(gameTime * 4) and 1) > 0 then
    Spr(texSpecimenP92[1], 148, 84)
  else
    Spr(texSpecimenP92[0], 148, 84);

  for a:=0 to high(mapItems) do begin
    if not mapItems[a].active then continue;

    RectDarken(
      trunc(mapItems[a].zone.x),
      trunc(mapItems[a].zone.y),
      trunc(mapItems[a].zone.x + mapItems[a].zone.width - 1),
      trunc(mapItems[a].zone.y + mapItems[a].zone.height - 1));

    spr(
      mapItems[a].texHandle,
      trunc(mapItems[a].zone.x),
      trunc(mapItems[a].zone.y + mapItems[a].offsetY));

    { DrawZone(mapItems[a].zone, red); }
  end;

  spr(texShadow, trunc(playerZone.x), trunc(playerZone.y));

  spr(texSlime,
    trunc(playerZone.x),
    trunc(playerZone.y + playerZone.height / 2 - GetTexHeight(texSlime)));

  { DrawZone(playerZone, red); }

  PrintDefaultCentred(
    'Coins: ' + i32str(coins),
    VGAWidth shr 1, 120);
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

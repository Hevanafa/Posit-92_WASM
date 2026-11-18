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
  P92Keyboard, P92Mouse, P92Panic, P92Iif,
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
  playerBody: TPhysicsBody;
  isFacingRight: boolean;

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
  mapItems[idx].itemType := ItemCoin;
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

procedure ResolveBodyYCollision(var body: TPhysicsBody);
var
  a: smallint;
begin
  for a:=0 to high(mapObjects) do begin
    if not mapObjects[a].active then continue;

    if ZoneIntersects(PhysicsBodyToZone(body), mapObjects[a].zone) then
      if abs(body.vy) <> 0.0 then begin
        if body.vy > 0 then
          body.y := trunc(mapObjects[a].zone.y - body.height);

        if body.vy < 0 then
          body.y := trunc(mapObjects[a].zone.y + mapObjects[a].zone.height + 1);
      end;
  end;
end;

procedure ResolveBodyXCollision(var body: TPhysicsBody);
var
  a: smallint;
begin
  for a:=0 to high(mapObjects) do begin
    if not mapObjects[a].active then continue;

    if ZoneIntersects(PhysicsBodyToZone(body), mapObjects[a].zone) then
      if abs(body.vx) <> 0.0 then begin
        if body.vx > 0 then
          body.x := trunc(mapObjects[a].zone.x - body.width);
        if body.vx < 0 then
          body.x := trunc(mapObjects[a].zone.x + mapObjects[a].zone.width + 1);
      end;
  end;
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

  playerBody.x := VGAWidth div 2;
  playerBody.y := VGAHeight div 2;
  playerBody.width := 32;
  playerBody.height := 16;

  isFacingRight := true;

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

  if not IsKeyDown(SC_W) and not IsKeyDown(SC_S) then
    playerBody.vy := 0
  else begin
    if IsKeyDown(SC_W) then
      playerBody.vy := -Velocity;
    if IsKeyDown(SC_S) then
      playerBody.vy := Velocity;
  end;

  if not IsKeyDown(SC_A) and not IsKeyDown(SC_D) then
    playerBody.vx := 0
  else begin
    if IsKeyDown(SC_A) then begin
      playerBody.vx := -Velocity;
      isFacingRight := false;
    end;

    if IsKeyDown(SC_D) then begin
      playerBody.vx := Velocity;
      isFacingRight := true;
    end;
  end;

  playerBody.y := playerBody.y + playerBody.vy * DeltaTime;

  ResolveBodyYCollision(playerBody);

  playerBody.x := playerBody.x + playerBody.vx * DeltaTime;

  ResolveBodyXCollision(playerBody);

  for a:=0 to high(mapItems) do begin
    if not mapItems[a].active then continue;

    if ZoneIntersects(PhysicsBodyToZone(playerBody), mapItems[a].zone) then begin
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

  for a:=0 to high(mapObjects) do begin
    if not mapObjects[a].active then continue;

    Spr(
      mapObjects[a].texHandle,
      trunc(mapObjects[a].zone.x),
      trunc(
        mapObjects[a].zone.y + mapObjects[a].zone.height
        - GetTexHeight(mapObjects[a].texHandle)));

    DrawZone(mapObjects[a].zone, red);
  end;

  for a:=0 to high(mapItems) do begin
    if not mapItems[a].active then continue;

    RectDarken(
      trunc(mapItems[a].zone.x),
      trunc(mapItems[a].zone.y),
      trunc(mapItems[a].zone.x + mapItems[a].zone.width - 1),
      trunc(mapItems[a].zone.y + mapItems[a].zone.height - 1));

    Spr(
      mapItems[a].texHandle,
      trunc(mapItems[a].zone.x),
      trunc(mapItems[a].zone.y + mapItems[a].offsetY));

    { DrawZone(mapItems[a].zone, red); }
  end;

  Spr(texShadow, trunc(playerBody.x), trunc(playerBody.y));

  SprFlipped(
    texSlime,
    trunc(playerBody.x),
    trunc(playerBody.y + playerBody.height / 2 - GetTexHeight(texSlime)),
    [TSprFlip(I16Iif(isFacingRight, ord(SprFlipHorizontal), 0))]);

  { DrawZone(playerBody, red); }

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

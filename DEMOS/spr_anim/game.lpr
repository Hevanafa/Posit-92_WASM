library Game;

{$Mode ObjFPC}
{$H+}{$J-}

uses
  P92Core, P92Fonts, P92WasmHost,
  P92Keyboard, P92Mouse,
  P92Tex, P92TexDraw,
  SprAnim, P92Timing, P92VGA,
  Assets;

var
  lastEsc: boolean;

  { Init your game state here }
  gameTime: double;

  hourglassFrameIdx: smallint;
  hourglassStartTick: double;
  sprHourglass: TSpriteAnim;

  cursorFrameIdx: smallint;
  cursorStartTick: double;
  sprAppStartingCursor: TSpriteAnim;

  cheetahFrameIdx: smallint;
  cheetahStartTick: double;
  sprCheetah: TSpriteAnim;

procedure DrawMouse;
begin
  { spr(imgCursor, mouseX, mouseY) }
  drawSpriteAnim(sprAppStartingCursor, cursorFrameIdx, GetMouseX, GetMouseY)
end;


procedure OnPreload;
begin

end;

procedure OnReady;
begin
  hideCursor;

  { Initialise game state here }
  gameTime := 0.0;

  initSpriteAnim(sprHourglass, imgHourglass, 15, 32, 32, 0.2);
  rewindSpriteAnim(hourglassStartTick, getTimer, hourglassFrameIdx);

  initSpriteAnim(sprAppStartingCursor, imgAppStartingCursor, 10, 32, 32, 0.2);
  rewindSpriteAnim(cursorStartTick, getTimer, cursorFrameIdx);

  initSpriteAnim(sprCheetah, imgCheetah, 8, 133, 63, 0.05);
  rewindSpriteAnim(cheetahStartTick, getTimer, cheetahFrameIdx);
end;

procedure Update;
begin
  if lastEsc <> isKeyDown(SC_ESCAPE) then begin
    lastEsc := isKeyDown(SC_ESCAPE);
    if lastEsc then SignalDone;
  end;

  updateSpriteAnim(sprHourglass, getTimer, hourglassStartTick, hourglassFrameIdx);
  updateSpriteAnim(sprAppStartingCursor, getTimer, cursorStartTick, cursorFrameIdx);

  updateSpriteAnim(sprCheetah, getTimer, cheetahStartTick, cheetahFrameIdx);

  gameTime := gameTime + DeltaTime;
end;

procedure Draw;
var
  w: integer;
  s: string;
begin
  cls($FF6495ED);

  if (trunc(gameTime * 4) and 1) > 0 then
    spr(imgDosuEXE[1], 148, 88)
  else
    spr(imgDosuEXE[0], 148, 88);

  { spr(imgAppStartingCursor, 10, 10); }
  { spr(imgHourglass, 10, 60); }

  drawSpriteAnim(sprCheetah, cheetahFrameIdx, 20, 20);

  drawSpriteAnim(sprHourglass, hourglassFrameIdx, 188, 80);

  s := 'Hello world!';
  w := measureDefault(s);
  printDefault(s, (vgaWidth - w) div 2, 120);

  DrawMouse
end;

procedure Init;
var
  appConfig: TP92AppConfig;
begin
  appConfig := DefaultP92AppConfig;

  P92Start(appConfig);
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


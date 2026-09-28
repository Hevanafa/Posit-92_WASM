library Game;

{$Mode ObjFPC}
{$H+}{$J-}

uses
  P92Core, P92Fonts,
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
  drawSpriteAnim(sprAppStartingCursor, cursorFrameIdx, mouseX, mouseY)
end;


procedure beginPlayingState;
begin
  hideCursor;
  fitCanvas;

  { Initialise game state here }
  actualGameState := GameStatePlaying;
  gameTime := 0.0;

  initSpriteAnim(sprHourglass, imgHourglass, 15, 32, 32, 0.2);
  rewindSpriteAnim(hourglassStartTick, getTimer, hourglassFrameIdx);

  initSpriteAnim(sprAppStartingCursor, imgAppStartingCursor, 10, 32, 32, 0.2);
  rewindSpriteAnim(cursorStartTick, getTimer, cursorFrameIdx);

  initSpriteAnim(sprCheetah, imgCheetah, 8, 133, 63, 0.05);
  rewindSpriteAnim(cheetahStartTick, getTimer, cheetahFrameIdx);
end;


procedure init;
begin
  initHeapMgr;
  initDeltaTime;
end;

procedure afterInit;
begin
  beginPlayingState
end;

procedure update;
begin
  updateDeltaTime;

  updateMouse;

  { Your update logic here }
  if lastEsc <> isKeyDown(SC_ESC) then begin
    lastEsc := isKeyDown(SC_ESC);
    if lastEsc then signalDone;
  end;

  updateSpriteAnim(sprHourglass, getTimer, hourglassStartTick, hourglassFrameIdx);
  updateSpriteAnim(sprAppStartingCursor, getTimer, cursorStartTick, cursorFrameIdx);

  updateSpriteAnim(sprCheetah, getTimer, cheetahStartTick, cheetahFrameIdx);

  gameTime := gameTime + dt
end;

procedure draw;
var
  w: integer;
  s: string;
begin
  if actualGameState = GameStateLoading then begin
    renderLoadingScreen;
    exit
  end;

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

  DrawMouse;
  vgaFlush
end;

exports
  { Main game procedures }
  beginLoadingState,
  init, afterInit, update, draw;

begin
{ Starting point is intentionally left empty }
end.


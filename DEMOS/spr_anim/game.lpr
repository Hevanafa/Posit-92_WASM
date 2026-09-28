library Game;

{$Mode ObjFPC}
{$H+}{$J-}

uses
  P92Core, P92Fonts, P92WasmHost, P92AssetRegistry,
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
  { spr(texCursor, mouseX, mouseY) }
  drawSpriteAnim(sprAppStartingCursor, cursorFrameIdx, GetMouseX, GetMouseY)
end;


procedure OnPreload;
begin
  texCursor := RequestImage('assets/images/cursor.png');

  texDosuEXE[0] := RequestImage('assets/images/dosu_1.png');
  texDosuEXE[1] := RequestImage('assets/images/dosu_2.png');

  texAppStartingCursor := RequestImage('assets/images/appstarting_sheet.png');
  texCheetah := RequestImage('assets/images/fpc_running_logo.png');
  texHourglass := RequestImage('assets/images/hourglass_sheet.png');
end;

procedure OnReady;
begin
  hideCursor;

  { Initialise game state here }
  gameTime := 0.0;

  initSpriteAnim(sprHourglass, texHourglass, 15, 32, 32, 0.2);
  rewindSpriteAnim(hourglassStartTick, getTimer, hourglassFrameIdx);

  initSpriteAnim(sprAppStartingCursor, texAppStartingCursor, 10, 32, 32, 0.2);
  rewindSpriteAnim(cursorStartTick, getTimer, cursorFrameIdx);

  initSpriteAnim(sprCheetah, texCheetah, 8, 133, 63, 0.05);
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
    spr(texDosuEXE[1], 148, 88)
  else
    spr(texDosuEXE[0], 148, 88);

  { spr(texAppStartingCursor, 10, 10); }
  { spr(texHourglass, 10, 60); }

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

  appConfig.LoadDefaultCursor := false;

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


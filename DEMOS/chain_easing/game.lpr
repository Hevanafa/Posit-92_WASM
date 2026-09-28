{
  Chain Easing demo
  Mixins: bmfont, sound
}

library Game;

{$Mode ObjFPC}
{$H+}{$J-}

uses
  P92Core, P92Fonts, P92AssetRegistry, P92WasmHost,
  P92Conversions, P92FPS, P92Logger,
  P92Keyboard, P92Mouse,
  P92Tex, P92TexDraw, P92TexEffects,
  P92Easings, P92IMGUI,
  P92Timing, P92VGA,
  Assets;

const
  Velocity = 100;

  CornflowerBlue = $FF6495ED;

var
  lastEsc: boolean;

  { Game state variables }
  gameTime: double;

  { Easing chain state variables }
  isChainStarted, isChainComplete: boolean;
  { uses real time }
  chainEasingTick: double;

  chainIdx: integer;
  startX, endX: integer;
  startAngle, endAngle: double;

  blinkyX, blinkyY: double;


procedure OnPreload;
begin
  texDosuEXE[0] := RequestImage('assets/images/dosu_1.png');
  texDosuEXE[1] := RequestImage('assets/images/dosu_2.png');

  texBlinky := RequestImage('assets/images/blinky.png');
end;

procedure OnReady;
begin
  HideCursor;

  gameTime := 0.0;

  blinkyX := 160;
  blinkyY := 144;

  ReplaceColour(
    BorrowBMFontPtr(GetDefaultFontHandle)^.texHandle, $FFFFFFFF, $FF000000)
end;

procedure BeginEasingChain;
begin
  isChainStarted := true;
  isChainComplete := false;

  chainIdx := 0;
  startX := 100;
  endX := 150;
  chainEasingTick := GetTimer;
end;


procedure Update;
const
  { in seconds }
  EaseDuration = 1.0;
var
  now: double;
  perc: double;
  x: double;
begin
  now := GetTimer;

  if lastEsc <> IsKeyDown(SC_ESCAPE) then begin
    lastEsc := IsKeyDown(SC_ESCAPE);

    if lastEsc then SignalDone;
  end;

  if not isChainStarted then begin
    if isKeyDown(SC_W) then blinkyY := blinkyY - Velocity * DeltaTime;
    if isKeyDown(SC_S) then blinkyY := blinkyY + Velocity * DeltaTime;

    if isKeyDown(SC_A) then blinkyX := blinkyX - Velocity * DeltaTime;
    if isKeyDown(SC_D) then blinkyX := blinkyX + Velocity * DeltaTime;
  end;

  { Handle game state updates }

  if isChainStarted and not isChainComplete then begin
    { Handle state transition }
    if now >= chainEasingTick + EaseDuration then begin
      case chainIdx of
      0: begin
        perc := GetPerc(chainEasingTick, EaseDuration, now);
        x := LerpEased(startX, endX, perc, @EaseOutSine);  { current X }

        startX := trunc(x);
        endX := endX - 50;

        chainEasingTick := now;
        inc(chainIdx)
      end;
      1: begin
        perc := GetPerc(chainEasingTick, EaseDuration, now);
        x := LerpEased(startX, endX, perc, @EaseOutSine);  { current X }
        
        startX := trunc(x);
        endX := endX + 100;
        startAngle := 0.0;
        endAngle := 2 * PI;

        chainEasingTick := now;
        inc(chainIdx)
      end;
      2:
        inc(chainIdx);
      3: begin
        perc := GetPerc(chainEasingTick, EaseDuration, now);
        x := LerpEased(startX, endX, perc, @EaseOutSine);  { current X }
        blinkyX := x;

        isChainStarted := false;
        isChainComplete := true
      end
      end;
    end;
  end;

  gameTime := gameTime + DeltaTime;
end;


procedure Draw;
const
  EaseDuration = 1.0;
var
  now: double;
  perc: double;
  x, angle: double;
begin
  now := GetTimer;

  Cls(CornflowerBlue);

  if Button('Start Lerp', 50, 50) then
    BeginEasingChain;

  if (trunc(gameTime * 4) and 1) > 0 then
    Spr(texDosuEXE[1], 148, 88)
  else
    Spr(texDosuEXE[0], 148, 88);
 
  if not isChainStarted then
    CentredLabel('WASD to move', vgaWidth div 2, 120)
  else
    CentredLabel('Easing chain is in progress...', vgaWidth div 2, 120);

  if isChainStarted then begin
    case chainIdx of
      2: begin
        { Current state --> apply easing --> handle rendering }
        perc := GetPerc(chainEasingTick, EaseDuration, now);

        x := LerpEased(startX, endX, perc, @EaseOutSine);
        angle := LerpEased(startAngle, endAngle, perc, @EaseOutSine);

        SprRotate(texBlinky, trunc(x) + 8, trunc(blinkyY) + 8, angle);
      end;
      else begin
        perc := GetPerc(chainEasingTick, EaseDuration, now);
        x := LerpEased(startX, endX, perc, @EaseOutSine);
        Spr(texBlinky, trunc(x), trunc(blinkyY));
      end
    end;
  end else
    Spr(texBlinky, trunc(blinkyX), trunc(blinkyY));

  CentredLabel('chainIdx ' + i32str(chainIdx), vgaWidth div 2, 180);

  PrintDefault('start tick: ' + F32Str(chainEasingTick), 10, 10);
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


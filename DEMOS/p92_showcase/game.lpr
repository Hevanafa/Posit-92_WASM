{
  Flavour text demo
  Part of Posit-92 game engine
  Mixins: bmfont
}

library Game;

{$Mode ObjFPC}
{$H+}  { Use AnsiStrings }
{$J-}  { Switch off assignments to typed constants }

uses
  FGL,
  P92Core, P92Fonts, P92AssetRegistry, P92WasmHost,
  P92Logger, P92BMFont, P92Iif, P92WasmHeap,
  P92Keyboard, P92Mouse,
  P92Graphics, P92Tex, P92TexDraw, P92TexEffects, P92Colour,
  P92Timing, P92FPS, P92VGA,
  Assets;

type
  TStringList = specialize TFPGList<string>;

const
  TextChangeInterval = 5.0;

var
  { Game state variables }
  gameTime: double;
  nextTextChangeTick: double;

  flavourTexts: TStringList;
  displayedTextIdx: smallint;

procedure OnPreload;
begin
  texSpecimenP92[0] := RequestImage('assets/images/specimen_p-92_1.png');
  texSpecimenP92[1] := RequestImage('assets/images/specimen_p-92_2.png');
end;

procedure OnReady;
begin
  HideCursor;

  { Initialise game state here }
  gameTime := 0.0;
  nextTextChangeTick := GetTimer + TextChangeInterval;

  flavourTexts := TStringList.create;

  flavourTexts.Add('WebAssembly, the Pascal way!');
  flavourTexts.Add('The best WebAssembly game engine for Pascal!');

  { Pascal confidence }

  flavourTexts.Add('Pascal is not dead!');
  flavourTexts.Add('Yes, Pascal can do that!');
  flavourTexts.Add('Built for computers and fantasy computers');
  flavourTexts.Add('Handwritten with questionable enthusiasm!');

  { Vintage stuff }

  flavourTexts.Add('Modern problems require 1992 solutions!');
  flavourTexts.Add('Still compiling after 30 years!');
  flavourTexts.Add('Powered by suspiciously old technology!');
  flavourTexts.Add('Turbo Pascal approved!*');
  flavourTexts.Add('Made with actual pointers!');
  flavourTexts.Add('640K of RAM ought to be enough for somebody!');
  flavourTexts.Add('DOS is a feature');
  flavourTexts.Add('Also runs on computers from this century!');
  flavourTexts.Add('One codebase, several decades!');

  { Slime stuff }

  flavourTexts.Add('Contains 92% more slime!');
  flavourTexts.Add('Slime-powered game engine');
  flavourTexts.Add('Scientifically engineered slime!');
  flavourTexts.Add('Slime girls love deterministic behaviour!');
  flavourTexts.Add('Made by a self-proclaimed Pascal wizard!');

  { Font stuff }

  flavourTexts.Add('P92 Sans and P92 Boot included!');

  { JS-related stuff }

  flavourTexts.Add('No JavaScript framework required!');
  flavourTexts.Add('No npm install!');

  { GPU stuff }

  flavourTexts.Add('Your GPU can take the day off!');
  flavourTexts.Add('No shaders? No problem!');
  flavourTexts.Add('The engine your GPU forgot to fear!');

  { Shipping confidence }

  flavourTexts.Add('Who needs pas2js if wasm32 can do it?');
  flavourTexts.Add('Who needs WASI if there''s no filesystem involved?');
  flavourTexts.Add('No filesystem? No WASI problem!');

  flavourTexts.Add('Another abstraction layer? Declined!');
  flavourTexts.Add('Framework-free by deliberate choice!');
  flavourTexts.Add('No runtime acrobatics required!');
  flavourTexts.Add('Less tech stack, more game!');
  flavourTexts.Add('Technically impressive. Practically unnecessary.');
  flavourTexts.Add('Shipping beats feature density!');

  flavourTexts.Add('Built to run, not to trend!');
  flavourTexts.Add('No architecture astronautics required!');
  flavourTexts.Add('The dependency graph is pleasantly boring!');
  flavourTexts.Add('Zero hype-driven development!');
  flavourTexts.Add('One executable idea at a time!')
  flavourTexts.Add('If the browser can call it, Pascal can own it!');

  flavourTexts.Add('WASM without the elaborate ceremony!');
  flavourTexts.Add('No framework migration planned!');
  flavourTexts.Add('The tech stack ends here!');
  flavourTexts.Add('Fewer layers, fewer mysteries!');
  flavourTexts.Add('Engine first, ecosystem second!');
  flavourTexts.Add('Built before the trend cycle ends!');

  displayedTextIdx := trunc(GetTimer) mod flavourTexts.Count;
end;

procedure Update;
var
  now: double;
begin
  now := GetTimer;

  if IsKeyDown(SC_ESCAPE) then SignalDone;

  if now >= nextTextChangeTick then begin
    nextTextChangeTick := nextTextChangeTick + TextChangeInterval;
    displayedTextIdx := (displayedTextIdx + 1) mod flavourTexts.count;
  end;

  gameTime := gameTime + DeltaTime
end;

procedure Draw;
var
  a: word;
  c: char;
  s: string;
  hue, v: double;
  left: smallint;
  frameIdx: smallint;
  colour: longword;
  x, y: smallint;
  w, h: smallint;
  scale: double;
begin
  { Cls($FF6495ED); }

  for a:=0 to VgaHeight - 1 do begin
    v := 64 / 255 + sin((a / 50 - frac(GetTimer)) * 2 * PI) * (32 / 255);
    colour := HSVtoRGB(137 / 255, 1.0, v);
    HLine(0, VgaWidth - 1, a, colour);
  end;

  scale := 1.0 + abs(sin(frac(GetTimer) * 2 * PI)) * 0.25;

  x := 160;
  y := 100;

  w := trunc(GetTexWidth(texSpecimenP92[1]) * scale);
  h := trunc(GetTexHeight(texSpecimenP92[1]) * scale);

  frameIdx := U16Iif((trunc(gameTime * 4) and 1) > 0, 1, 0);

  Spr(
    texSpecimenP92[frameIdx],
    x - 12, y - 12);

  {
  SprStretch(
    texSpecimenP92[frameIdx],
    x - w div 2, y - h div 2,
    w, h);
  }

  s := flavourTexts[displayedTextIdx];
  w := MeasureDefault(s);
  left := (VgaWidth - w) div 2;

  for a:=1 to length(s) do begin
    c := s[a];

    hue := (a-1) / length(s) + frac(GetTimer);
    if hue > 1.0 then hue := hue - 1.0;

    colour := HSVtoRGB(hue, 1.0, 1.0);
    inc(left, PrintCharColour(c, left, 128, colour));
  end;
end;

procedure Init;
var
  appConfig: TP92AppConfig;
begin
  appConfig := DefaultP92AppConfig;

  appConfig.DefaultBMFontPath := 'assets/fonts/p92_sans_8_bold.txt';

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

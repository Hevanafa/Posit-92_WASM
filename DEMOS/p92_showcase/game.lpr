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

var
  { Game state variables }
  gameTime: double;

  flavourTexts: TStringList;
  displayedFlavourText: string;

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

  flavourTexts := TStringList.create;

  flavourTexts.Add('WebAssembly, the Pascal way!');
  flavourTexts.Add('The best WebAssembly game engine for Pascal!');

  flavourTexts.Add('Modern problems require 1992 solutions!');

  flavourTexts.Add('Pascal is not dead!');
  flavourTexts.Add('Still compiling after 30 years!');
  flavourTexts.Add('Powered by suspiciously old technology!');
  flavourTexts.Add('Turbo Pascal approved!*');
  flavourTexts.Add('Made with actual pointers!');
  flavourTexts.Add('Handwritten with questionable enthusiasm!');

  flavourTexts.Add('Built for computers and fantasy computers');
  flavourTexts.Add('DOS is a feature');
  flavourTexts.Add('Yes, Pascal can do that!');

  { JS-related stuff }

  flavourTexts.Add('No JavaScript framework required!');
  flavourTexts.Add('No npm install!');

  { GPU stuff }

  flavourTexts.Add('Your GPU can take the day off!');

  displayedFlavourText := flavourTexts[trunc(GetTimer) mod flavourTexts.Count];
end;

procedure Update;
begin
  if IsKeyDown(SC_ESCAPE) then SignalDone;

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

  s := displayedFlavourText;
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

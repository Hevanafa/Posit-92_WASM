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
  Classes,
  P92Core, P92Conversions, P92Fonts, P92AssetRegistry, P92WasmHost,
  P92Logger, P92BMFont, P92Iif, P92WasmHeap,
  P92Keyboard, P92Mouse,
  P92Graphics, P92Tex, P92TexDraw, P92TexEffects, P92Colour,
  P92Easings, P92Timing, P92FPS, P92VGA,
  Assets;

const
  White = $FFFFFFFF;
  AccentPale = $FFDEF6B8;
  TextChangeInterval = 5.0;

var
  { Game state variables }
  gameTime: double;
  { uses real time }
  nextTextChangeTick: double;

  lastProceed: boolean;

  flavourTexts: TStringList;
  displayedTextIdx: smallint;


function IsProceedPressed: boolean;
begin
  IsProceedPressed := IsKeyDown(SC_SPACE) or IsLeftMousePressed
end;

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
  flavourTexts.Add('Pascal was never the problem!');
  flavourTexts.Add('Yes, we still use Pascal!');

  flavourTexts.Add('Pascal belongs in the big 26!');
  flavourTexts.Add('Structured programming strikes again!');
  flavourTexts.Add('Strong types, stronger opinions!');
  flavourTexts.Add('Pointers are friends!');
  flavourTexts.Add('Objects without the ceremony!');
  flavourTexts.Add('Old language, new tricks!');

  flavourTexts.Add('Write Pascal. Ship games.');
  flavourTexts.Add('Still waiting for Pascal to die!');
  flavourTexts.Add('if Condition then begin doStuff end;');

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

  flavourTexts.Add('Powered by industrial grade slime!');
  flavourTexts.Add('Now with improved slime viscosity!');
  flavourTexts.Add('Slime girls prefer static linking!');
  flavourTexts.Add('Slime girls do their own memory management!');
  flavourTexts.Add('Slime girls hate unnecessary abstractions!');
  flavourTexts.Add('92% slime, 8% pointer arithmetic!');
  flavourTexts.Add('Keep away from unsupervised slimes!');

  { Font stuff }

  flavourTexts.Add('P92 Sans and P92 Boot included!');

  { JS stuff }

  flavourTexts.Add('No JavaScript framework required!');
  flavourTexts.Add('No npm install!');
  flavourTexts.Add('JavaScript kept on a short leash!');
  flavourTexts.Add('Less JS, more Pascal!');
  flavourTexts.Add('The game lives in the WASM!');
  flavourTexts.Add('JavaScript is merely the glue!');

  flavourTexts.Add('No node_modules ecosystem required!');
  flavourTexts.Add('No bundler archaeology required!');
  flavourTexts.Add('No dependency tree forest!');
  flavourTexts.Add('No package-lock novella!');

  flavourTexts.Add('Runs without React!');
  flavourTexts.Add('Runs without Vue!');
  flavourTexts.Add('Runs without knowing what Vite is!');
  flavourTexts.Add('Your package manager may remain closed!');
  flavourTexts.Add('npm has been informed it may rest today!');
  flavourTexts.Add('Just enough JS to open the door!');

  { Other languages }

  { Rust }

  flavourTexts.Add('Rust? Is that the game or the crab?');
  flavourTexts.Add('Pascal taught discipline before borrow checking was cool!');
  flavourTexts.Add('Fearless concurrency? Pascal fears nothing at 60 FPS!');
  flavourTexts.Add('Pascal: memory safety through knowing what you''re doing!');
  flavourTexts.Add('The crab may remain peacefully on the beach!');
  flavourTexts.Add('Pascal was teaching explicit state before it was fashionable!');

  flavourTexts.Add('Pascal survived decades without a borrow checker!');
  flavourTexts.Add('Pascal: structured enough to keep you honest!');
  flavourTexts.Add('Unsafe? We call that responsibility!');
  flavourTexts.Add('No fighting the borrow checker today!');
  flavourTexts.Add('Ownership model: I wrote the code, I know the owner!');
  flavourTexts.Add('Lifetime annotations? Mine end at OnCleanup!');

  flavourTexts.Add('Pascal trusts you. Try to deserve it!');
  flavourTexts.Add('Pascal has one game loop and zero existential dread!');

  { Go }

  flavourTexts.Add('Go? I already went!');
  flavourTexts.Add('Goroutines? I have a game loop!');
  flavourTexts.Add('Channels? We call those variables!');
  flavourTexts.Add('Error handling, now with fewer if err != nil !');

  flavourTexts.Add('Nice mascot. We also have a hot slime girl!');

  flavourTexts.Add('Simple language? Now YOU are speaking my language!');
  flavourTexts.Add('Go looks suspiciously familiar!');
  flavourTexts.Add('Go is like Pascal, but someone hid the semicolons!');
  flavourTexts.Add('Minimal syntax? Pascal was doing that before it was cool!');
  flavourTexts.Add('Go has :=. I have := too!');

  { C++ }

  flavourTexts.Add('C++? How many pluses do you need?');
  flavourTexts.Add('Undefined behaviour sold separately!');
  flavourTexts.Add('No header archaeology required!');
  flavourTexts.Add('Pascal survived without operator soup!');
  flavourTexts.Add('RAII? Pascal prefers Free-dom!');
  flavourTexts.Add('Your compiler error has exceeded the whole text buffer!');

  { Java }

  flavourTexts.Add('Write once, install a JVM everywhere!');
  flavourTexts.Add('class FactoryThing<T> not included!');
  flavourTexts.Add('public static void main can take the day off!');
  flavourTexts.Add('Do you have any List<AbstractSingletonProxyFactoryGrapeItem>?');
  flavourTexts.Add('Not everything needs to be a class!');
  flavourTexts.Add('No garbage collector negotiations required!');
  flavourTexts.Add('Enterprise-grade Hello World not required!');
  flavourTexts.Add('public static void main System.out.println? Begin writeln is enough!');

  flavourTexts.Add('Java called, is it another giga-bite?');
  flavourTexts.Add('JVM warmup not included!');
  flavourTexts.Add('No virtual machine was harmed in the making of this frame');

  { Python }

  flavourTexts.Add('Indentation is for humans, begin/end is for certainty!');
  flavourTexts.Add('pip install absolutely nothing!');
  flavourTexts.Add('No virtual environment archaeology!');
  flavourTexts.Add('Python is lovely, but sir, this is Pascal');  { Kinda like the "Sir, this is Wendy's" }
  flavourTexts.Add('Fast enough without asking NumPy or C to do it!');

  { Ruby }

  flavourTexts.Add('That''s a pretty gem, Ruby, but wrong toolbox!');
  flavourTexts.Add('Everything is an object? Even this framebuffer?');
  flavourTexts.Add('No gems or rocks required!');  { This may also involve Lua }
  flavourTexts.Add('Convention over configuration? How about neither?');
  flavourTexts.Add('Rails not included. We have no train station!');

  flavourTexts.Add('Who brought a garbage collector to a 320x200 game?');
  flavourTexts.Add('Heap size: measured in kilobytes, not willy-nilly');
  flavourTexts.Add('Some runtimes need more RAM than this game has pixels');
  flavourTexts.Add('Garbage collection? We already know where everything is!');
  flavourTexts.Add('Ruby: elegant syntax, enthusiastic appetite');

  flavourTexts.Add('The whole game fits inside someone else''s startup overhead!');
  flavourTexts.Add('A whole engine, still lighter than your black hole called dependencies');

  flavourTexts.Add('Please remain calm, it''s only 2 MB of RAM');
  flavourTexts.Add('512K stack: decadent luxury!');

  { GPU stuff }

  flavourTexts.Add('Your GPU can take the day off!');
  flavourTexts.Add('No shaders? No problem!');
  flavourTexts.Add('The engine your GPU forgot to fear!');
  flavourTexts.Add('Your CPU drew this!');
  flavourTexts.Add('Software rendering is still rendering!');
  flavourTexts.Add('Pixels personally escorted by the CPU!');

  flavourTexts.Add('No vertex shader paperwork required!');
  flavourTexts.Add('No fragment shader negotiations!');
  flavourTexts.Add('No shader compilation surprises!');
  flavourTexts.Add('GPU utilisation sold separately!');

  flavourTexts.Add('Your shiny RTX card is deeply confused!');
  flavourTexts.Add('Your integrated graphics may enjoy vacation!');
  flavourTexts.Add('Rasterised the stubborn way!');
  flavourTexts.Add('Draw pixels. Present pixels. Done');
  flavourTexts.Add('Framebuffer goes in, picture comes out!');
  flavourTexts.Add('Shaders are optional. Pixels are mandatory!');
  flavourTexts.Add('Who needs triangles anyway?');

  { 3D stuff }

  flavourTexts.Add('Nice normal map! We brought a bitmap!');
  flavourTexts.Add('PBR? Pretty Bitmap Rendering?');
  flavourTexts.Add('Ray tracing? We already know where the pixels are!');
  flavourTexts.Add('Your mesh has more triangles than this game has pixels!');
  flavourTexts.Add('No need to triangulate the slime!');
  flavourTexts.Add('Who needs a depth buffer if everything is already right before your eyes!');
  flavourTexts.Add('Your material graph looks [very] impressive from 320x200!');
  flavourTexts.Add('Tessellation can remain peacefully unemployed!');
  flavourTexts.Add('5500 polygons for a toothbrush!');  { Regarding to [that one programmer] }
  flavourTexts.Add('LOD system not required at [this] distance!');
  flavourTexts.Add('The polygon budget has been converted into snacks!');

  flavourTexts.Add('This engine has zero interest in your tangent space!');
  flavourTexts.Add('Flat sprites for a flat surface!');
  flavourTexts.Add('The Z axis has been given annual leave, maybe forever!');
  flavourTexts.Add('Emotionally rasterised!');
  flavourTexts.Add('Bright pixels win over volumetric lighting in 99% of cases!*');

  { Shipping confidence }

  flavourTexts.Add('Cool stack bro, but did it actually help ship the thing?');
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
  flavourTexts.Add('One executable idea at a time!');
  flavourTexts.Add('If the browser can call it, Pascal can own it!');

  flavourTexts.Add('WASM without the elaborate ceremony!');
  flavourTexts.Add('No framework migration planned!');
  flavourTexts.Add('The tech stack ends here!');
  flavourTexts.Add('Fewer layers, fewer mysteries!');
  flavourTexts.Add('Engine first, ecosystem second!');
  flavourTexts.Add('Built before the trend cycle ends!');

  flavourTexts.Add('Your tech stack has 67 packages. Mine has a framebuffer');
  flavourTexts.Add('Dependency count: suspiciously low');
  flavourTexts.Add('No "modernisation" sprint required!');
  flavourTexts.Add('Still waiting for the framework rewrite!');

{
  writelog('Flavour text capacity: ' + I32Str(flavourTexts.Capacity));
  writelog('Flavour text count: ' + i32str(flavourTexts.Count));
}

  displayedTextIdx := trunc(GetTimer) mod flavourTexts.Count;
end;

procedure Update;
var
  now: double;
begin
  now := GetTimer;

  if IsKeyDown(SC_ESCAPE) then SignalDone;

  if lastProceed <> IsProceedPressed then begin
    lastProceed := IsProceedPressed;

    if lastProceed then
      nextTextChangeTick := now;
  end;

  if now >= nextTextChangeTick then begin
    nextTextChangeTick := now + TextChangeInterval;
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
  perc: double;
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

  { Rainbow text }

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

  { Progress bar }

  if nextTextChangeTick - GetTimer > 0.0 then begin
    perc := 1.0 - (nextTextChangeTick - GetTimer) / TextChangeInterval;
    w := trunc(LerpEased(0, 319, perc, @EaseOutQuad));

    HLine(0, w, VGAHeight - 1, AccentPale);
  end;
end;

procedure Init;
var
  config: TP92AppConfig;
begin
  config := DefaultP92AppConfig;

  config.DefaultBMFontPath := 'assets/fonts/p92_sans_8_bold.txt';

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

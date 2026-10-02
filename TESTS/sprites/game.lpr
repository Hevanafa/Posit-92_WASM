{
  Sprite test project
  Part of Posit-92 game engine
  Mixins: bmfont, sound
}

library Game;

{$Mode ObjFPC}
{$H+}  { Use AnsiStrings }
{$J-}  { Switch off assignments to typed constants }

uses
  P92Core, P92Fonts, P92WasmHost, P92AssetRegistry,
  P92Logger, P92Conversions,
  P92Graphics, P92Keyboard, P92Mouse, P92Sounds,
  P92Tex, P92TexDraw, P92TexComp, P92TexEffects,
  P92Timing, P92FPS, P92VGA,
  Assets;

procedure OnPreload;
begin
  texSpecimenP92[0] := RequestImage('assets/images/specimen_p-92_1.png');
  texSpecimenP92[1] := RequestImage('assets/images/specimen_p-92_2.png');
end;

procedure OnReady;
begin
  RandSeed := 255;
end;


function TestSpr(const opCount: word): double;
var
  startTick, endTick: double;
  a: word;
  flips: TSprFlips;
begin
  startTick := GetTimer;

  { Original: 0.0710s,
    After using inline: 0.0630s
    After using RGBA on the hot path: 0.0600s
    After clipping: 0.0270s }
  { for a:=1 to 1000 do
    Spr(texSpecimenP92[0], random(VgaWidth) - 12, Random(VgaHeight) - 12); }

  { Original 5000 ops: 0.1350s
    After row stride opt: 0.1300s
    After PGet inlining: 0.0920s
    After pointer dereferencing on both SprPGet and PSet: 0.0560s }
  { for a:=1 to OpCount do
    Spr(texSpecimenP92[0], random(VgaWidth) - 12, Random(VgaHeight) - 12); }

  { 10000 ops
    Original: 0.4650s
    With clipping: 0.2080s
    Direct address assignment: 0.1280s
  }
  {
  for a:=1 to opCount do
    SprStretch(
      texSpecimenP92[0],
      random(VgaWidth) - 10,
      random(VgaHeight) - 10,
      10 + random(30), 10 + random(30));
  }

  { 10000 ops
    Original: 0.3810s
  }
  {
  for a:=1 to opCount do begin
    flips := [];

    if (a and 1) <> 0 then include(flips, SprFlipHorizontal);
    if (a and 2) <> 0 then include(flips, SprFlipVertical);

    SprFlipped(
      texSpecimenP92[0],
      random(VgaWidth) - 12,
      random(VgaHeight) - 12, flips)
  end;
  }

  { 1000 ops
    Original: 0.0960s
    5000 ops
    Original: 0.4090s }
  for a:=1 to opCount do begin
    SprAlpha(
      texSpecimenP92[0],
      random(VGAWidth) - 12, random(VGAHeight) - 12, random);
  end;

  endTick := GetTimer;

  TestSpr := endTick - startTick
end;

procedure DrawOnce;
const
  OpCount = 5000;
var
  t: double;
  s: string;
  w: word;
begin
  Cls($FF6495ED);

  t := TestSpr(OpCount);

  s := i32str(OpCount) + ' operations done in ' + f32str(t) + 's';
  w := MeasureDefault(s);
  RectFill(10, VgaHeight - 20, 10 + w, VgaHeight - 20 + BorrowBMFontPtr(GetDefaultFontHandle)^.lineHeight, $FF000000);
  PrintDefault(s, 10, VgaHeight - 20);
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
  DrawOnce;

begin
{ Starting point is intentionally left empty }
end.

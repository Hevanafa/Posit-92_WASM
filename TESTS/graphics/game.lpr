{
  Default boilerplate
  Mixins: bmfont, sound
}

library Game;

{$Mode ObjFPC}
{$H+}  { Use AnsiStrings }
{$J-}  { Switch off assignments to typed constants }

uses
  SysUtils,
  P92Core, P92WasmHost, P92Fonts, P92AssetRegistry,
  P92Keyboard, P92Mouse,
  P92Graphics, P92Tex, P92TexDraw, P92Timing, P92VGA,
  Assets;

var
  { Game state variables }
  gameTime: double;

{ Load game assets here }
procedure OnPreload;
begin
  texSpecimenP92[0] := RequestImage('assets/images/specimen_p-92_1.png');
  texSpecimenP92[1] := RequestImage('assets/images/specimen_p-92_2.png');
end;

{ Initialise game state here }
procedure OnReady;
begin
  HideCursor;

  RandSeed := 255;

  gameTime := 0.0;
end;

{ Free resources here }
procedure OnCleanup;
begin
  FreeTex(texSpecimenP92[0]);
  FreeTex(texSpecimenP92[1]);
end;

procedure DrawOnce;
const
  OpCount = 50000;
var
  a: word;
  startTick, endTick: double;
begin
  cls($ff6495ed);

  startTick := GetTimer;

  { for a:=1 to OpCount do
    HLine(
      Random(VGAWidth + 20) - 10,
      Random(VGAWidth + 20) + 10,
      Random(VGAHeight + 20) - 10,
      $FF000000 or random($1000000)); }

  { for a:=1 to OpCount do
    VLine(
      Random(VGAWidth + 20) - 10,
      Random(VGAHeight + 20) + 10,
      Random(VGAHeight + 20) - 10,
      $FF000000 or random($1000000)); }

  { for a:=1 to OpCount do
    CircFill(
      Random(VGAWidth + 20) - 10,
      random(VGAHeight + 20) - 10,
      5 + random(6),
      $FF000000 or random($1000000)); }

  for a:=1 to OpCount do
    Circ(
      Random(VGAWidth + 20) - 10,
      random(VGAHeight + 20) - 10,
      5 + random(6),
      $FF000000 or random($1000000));

  endTick := GetTimer;

  PrintDefault(format('%d ops done in %.4f s', [OpCount, endTick - startTick]), 0, 0);
end;

procedure Init;
var
  config: TP92AppConfig;
begin
  config := DefaultP92AppConfig;

  config.OnPreload := @OnPreload;
  config.OnReady := @OnReady;
  config.DrawOnce := @DrawOnce;
  config.OnCleanup := @OnCleanup;
  config.LoadDefaultCursor := false;

  P92Start(config);
end;

exports
  Init;

begin
  { Starting point is intentionally left empty }
end.

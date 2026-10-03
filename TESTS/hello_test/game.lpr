{
  Default test project boilerplate
  Mixins: bmfont
}

library Game;

{$Mode ObjFPC}
{$H+}  { Use AnsiStrings }
{$J-}  { Switch off assignments to typed constants }

uses
  P92Core, P92Fonts, P92WasmHost, P92AssetRegistry,
  P92Logger,
  P92Keyboard, P92Mouse, P92Sounds,
  P92TexDraw, P92Timing, P92FPS, P92VGA,
  Assets;

procedure OnPreload;
begin
  texSpecimenP92[0] := RequestImage('assets/images/specimen_p-92_1.png');
  texSpecimenP92[1] := RequestImage('assets/images/specimen_p-92_2.png');
end;

procedure OnReady;
begin
  HideCursor
end;

procedure DrawOnce;
begin
  writelog('DrawOnce call');

  Cls($FF6495ED);

  Spr(texSpecimenP92[0], 148, 84);

  PrintDefaultCentred('Hello world! (Draw once)', VgaWidth div 2, 120);
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
  DrawOnce;

begin
{ Starting point is intentionally left empty }
end.

{
  Default boilerplate
  Mixins: bmfont, sound
}

library Game;

{$Mode ObjFPC}
{$H+}  { Use AnsiStrings }
{$J-}  { Switch off assignments to typed constants }

uses
  P92Core, P92WasmHost, P92Fonts, P92AssetRegistry,
  P92Keyboard, P92Mouse,
  P92Tex, P92TexDraw, P92Timing, P92VGA,
  Assets;

var
  lastT: boolean;

  { Game state variables }
  gameTime: double;
  isDarken: boolean;

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

  gameTime := 0.0;
  lastT := false;
  isDarken := false;
end;

{ Free resources here }
procedure OnCleanup;
begin
  FreeTex(texSpecimenP92[0]);
  FreeTex(texSpecimenP92[1]);
end;

procedure Update;
begin
  if IsKeyDown(SC_ESCAPE) then SignalDone;

  if lastT <> IsKeyDown(SC_T) then begin
    lastT := IsKeyDown(SC_T);

    if lastT then
      isDarken := not isDarken;
  end;

  gameTime := gameTime + DeltaTime
end;

procedure Draw;
begin
  Cls($FF6495ED);

  if (trunc(gameTime * 4) and 1) > 0 then
    Spr(texSpecimenP92[1], 148, 84)
  else
    Spr(texSpecimenP92[0], 148, 84);

  if isDarken then RectDarken(100, 100, 129, 119);

  PrintDefaultCentred('Hello world!', VgaWidth div 2, 120);
end;

procedure Init;
var
  config: TP92AppConfig;
begin
  config := DefaultP92AppConfig;

  config.OnPreload := @OnPreload;
  config.OnReady := @OnReady;
  config.Update := @Update;
  config.Draw := @Draw;
  config.OnCleanup := @OnCleanup;

  P92Start(config);
end;

exports
  Init;

begin
  { Starting point is intentionally left empty }
end.

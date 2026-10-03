{
  Loading unit
  Part of Posit-92 game engine
  Hevanafa
}

unit P92Loading;

{$Mode ObjFPC}
{$H-}{$J-}

interface

procedure RenderLoadingScreen;


implementation

uses
  P92Core, P92Conversions, P92AssetRegistry, P92VGA
{$IFDEF P92_WEBGL}
  , P92WebGL
{$ENDIF}
  ;

procedure RenderLoadingScreen;
var
  s: string;
begin
  Cls($00000000);

  s := 'Loading...';
  Print(s, (VGAWidth - 8 * length(s)) shr 1, 76);

  s := I32Str(GetAssetReadyCount) + ' / ' + I32Str(GetAssetTotalCount) + ' assets';
  Print(s, (VGAWidth - 8 * length(s)) shr 1, 92);

  VGAUpload;

{$IFDEF P92_WEBGL}
  WebGLPresent;
{$ELSE}
  VGAPresent;
{$ENDIF}
end;

end.

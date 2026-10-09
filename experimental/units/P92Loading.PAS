{
  Loading unit
  Part of Posit-92 game engine
}

unit P92Loading;

{$Mode ObjFPC}
{$H-}{$J-}

interface

{$IFDEF P92_WASM}

procedure RenderLoadingScreen;

{$ENDIF}


implementation

{$IFDEF P92_WASM}

uses
  P92Core, P92Conversions, P92AssetRegistry, P92Graphics, P92VGA
{$IFDEF P92_WEBGL}
  , P92WebGL
{$ENDIF}
  ;

procedure RenderLoadingScreen;
const
  BarLeft = 120;
  BarTop = 116;
  BarWidth = 80;
  BarHeight = 10;
  { Copied from P92IMGUI }
  AccentNormal = $FF8CDE92;
var
  s: string;
  perc: double;
begin
  Cls($FF000000);

  s := 'Loading...';
  Print(s, (VGAWidth - 8 * length(s)) shr 1, 76);

  s := I32Str(GetAssetReadyCount) + ' / ' + I32Str(GetAssetTotalCount) + ' assets';
  Print(s, (VGAWidth - 8 * length(s)) shr 1, 92);

  if GetAssetTotalCount > 0 then begin
    perc := GetAssetReadyCount / GetAssetTotalCount;

    RectFill(
      BarLeft, BarTop,
      BarLeft + trunc(BarWidth * perc) - 1, BarTop + BarHeight - 1,
      AccentNormal);

    Rect(
      BarLeft, BarTop,
      BarLeft + BarWidth - 1, BarTop + BarHeight - 1,
      $FFFFFFFF);
  end;

  VGAUpload;

{$IFDEF P92_WEBGL}
  WebGLPresent;
{$ELSE}
  VGAPresent;
{$ENDIF}
end;

{$ENDIF}

end.

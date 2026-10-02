{
  Composite blitting unit
  Part of Posit-92 game engine
  Hevanafa

  Similar to ImgRefFast but with a proper alpha blending logic
}

unit P92TexComp;

{$Mode ObjFPC}
{$H+}{$J-}
{$Inline ON}

interface

uses P92AssetHandles;

{
  opacity: 0.0 .. 1.0
}
procedure SprAlpha(const texHandle: TTextureHandle; const x, y: smallint; opacity: double);
procedure SprBlend(const texHandle: TTextureHandle; const x, y: smallint);


implementation

uses P92AssetRegistry, P92Tex, P92Maths, P92VGA;

procedure SprAlpha(const texHandle: TTextureHandle; const x, y: smallint; opacity: double);
var
  texturePtr: PSoftwareTex;
  startX, endX, startY, endY: smallint;
  px, py: smallint;
  ABGR: longword;
  alpha: byte;
begin
  if not IsTexReady(texHandle) then exit;

  { Handle edge cases & clipping }

  opacity := clamp(opacity, 0.0, 1.0);
  if opacity <= 0.0 then exit;

  texturePtr := BorrowTexPtr(texHandle);

  startX := ClipX1 - x;
  endX := ClipX2 - x;

  if startX < 0 then
    startX := 0;
  if endX > texturePtr^.width - 1 then
    endX := texturePtr^.width - 1;

  startY := ClipY1 - y;
  endY := ClipY2 - y;

  if startY < 0 then
    startY := 0;
  if endY > texturePtr^.height - 1 then
    endY := texturePtr^.height - 1;

  if (startX > endX) or (startY > endY) then exit;

  { Render logic }

  for py := startY to endY do
    for px := startX to endX do begin
      ABGR := UnsafeTexPGet(texturePtr, px, py);

      alpha := ABGR shr 24;
      if alpha = 0 then continue;

      alpha := trunc(alpha * opacity);
      ABGR := (ABGR and $FFFFFF) or (alpha shl 24);

      UnsafePSetBlend(x + px, y + py, ABGR)
    end;
end;

procedure SprBlend(const texHandle: TTextureHandle; const x, y: smallint);
var
  texturePtr: PSoftwareTex;
  px, py: smallint;
  colour: longword;
begin
  if not IsTexReady(texHandle) then exit;

  texturePtr := BorrowTexPtr(texHandle);

  for py := 0 to texturePtr^.height - 1 do
    for px := 0 to texturePtr^.width - 1 do begin
      if (x + px > clipX2) or (x + px < clipX1)
        or (y + py > clipY2) or (y + py < clipY1) then continue;

      colour := UnsafeTexPGet(texturePtr, px, py);
      UnsafePSetBlend(x + px, y + py, colour)
    end;
end;

end.

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
  colour: longword;
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

  { TODO: Handle Y clipping }



  { Render logic }

  for py := 0 to texturePtr^.height - 1 do
    for px := 0 to texturePtr^.width - 1 do begin
      if (x + px > clipX2) or (x + px < clipX1)
        or (y + py > clipY2) or (y + py < clipY1) then continue;

      colour := UnsafeTexPGet(texturePtr, px, py);
      alpha := colour shr 24;
      if alpha = 0 then continue;

      alpha := trunc(alpha * opacity);
      colour := (colour and $FFFFFF) or (alpha shl 24);

      UnsafePSetBlend(x + px, y + py, colour)
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

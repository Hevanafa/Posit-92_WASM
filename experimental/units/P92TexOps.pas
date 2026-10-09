{
  Texture modification unit
  Part of Posit-92 game engine
}
unit P92TexOps;

{$Mode ObjFPC}
{$H+}{$J-}

interface

uses P92AssetHandles, P92AssetRegistry, P92Tex;

procedure SprToDest(const src, dest: TTextureHandle; const x, y: smallint);

procedure SprRegionToDest(
  const src, dest: TTextureHandle;
  const srcX, srcY, srcW, srcH: smallint;
  const destX, destY: smallint);

procedure TexFlip(const texHandle: TTextureHandle; const flip: TSprFlips);

{ colour: $AARRGGBB }
procedure ReplaceTexColour(const texHandle: TTextureHandle; oldColour, newColour: longword);


implementation

uses P92Maths, P92Panic, P92Colour, P92VGA;

procedure SprToDest(const src, dest: TTextureHandle; const x, y: smallint);
var
  srcTex, destTex: PSoftwareTex;
  startX, endX, startY, endY: word;
  a, b: smallint;
  srcOffset: longword;
  alpha: byte;
  colour: longword;
begin
  if not IsTexReady(src) or not IsTexReady(dest) then exit;

  srcTex := BorrowTexPtr(src);
  destTex := BorrowTexPtr(dest);

  startX := trunc(Max(0, -x));
  startY := trunc(Max(0, -y));
  endX := trunc(Min(srcTex^.width, destTex^.width - x));
  endY := trunc(Min(srcTex^.height, destTex^.height - y));

  for b:=startY to endY - 1 do
  for a:=startX to endX - 1 do begin
    srcOffset := (a + b * srcTex^.width) * 4;
    alpha := srcTex^.pixelData[srcOffset + 3];
    if alpha < 255 then continue;

    colour := UnsafeTexPGet(srcTex, a, b);
    UnsafeTexPSet(destTex, x + a, y + b, colour)
  end;
end;

procedure SprRegionToDest(
  const src, dest: TTextureHandle;
  const srcX, srcY, srcW, srcH: smallint;
  const destX, destY: smallint
);
var
  srcTex, destTex: PSoftwareTex;
  px, py: smallint;
  sx, sy: smallint;
  srcPos: longword;
  alpha: byte;
  colour: longword;
begin
  if not IsTexReady(src) then PanicHalt('SprRegionToDest: src handle is unset!');
  if not IsTexReady(dest) then PanicHalt('SprRegionToDest: dest handle is unset!');

  srcTex := BorrowTexPtr(src);
  destTex := BorrowTexPtr(dest);

  for py:=0 to srcH - 1 do
  { TODO: Hoist the Y bounds check and `sy` }
  for px:=0 to srcW - 1 do begin
    if (destX + px >= destTex^.width) or (destX + px < 0)
      or (destY + py >= destTex^.height) or (destY + py < 0) then continue;

    sx := srcX + px;
    sy := srcY + py;
    srcPos := (sx + sy * srcTex^.width) * 4;

    alpha := srcTex^.pixelData[srcPos + 3];
    if alpha < 255 then continue;

    colour := UnsafeTexPGet(srcTex, sx, sy);
    UnsafeTexPSet(destTex, destX + px, destY + py, colour);
  end;
end;

procedure TexFlip(const texHandle: TTextureHandle; const flip: TSprFlips);
var
  texture: PSoftwareTex;
  px, py: smallint;
  halfW, halfH: smallint;
  tempColour: longword;
  pos1, pos2: longint;
begin
  if flip = [] then exit;
  if not IsTexReady(texHandle) then exit;

  texture := BorrowTexPtr(texHandle);

  { Horizontal flip }

  if SprFlipHorizontal in flip then begin
    halfW := texture^.width div 2;

    for py:=0 to texture^.height - 1 do
      for px:=0 to halfW - 1 do begin
        pos1 := (px + py * texture^.width) * 4;
        pos2 := ((texture^.width - 1 - px) + py * texture^.width) * 4;

        tempColour := PLongword(@texture^.pixelData[pos1])^;
        PLongword(@texture^.pixelData[pos1])^ := PLongword(@texture^.pixelData[pos2])^;
        PLongword(@texture^.pixelData[pos2])^ := tempColour
      end;
  end;

  { Vertical flip }
  
  if SprFlipVertical in flip then begin
    halfH := texture^.height div 2;

    for py:=0 to halfH - 1 do
      for px:=0 to texture^.width - 1 do begin
        pos1 := (px + py * texture^.width) * 4;
        pos2 := (px + (texture^.height - 1 - py) * texture^.width) * 4;

        tempColour := PLongword(@texture^.pixelData[pos1])^;
        PLongword(@texture^.pixelData[pos1])^ := PLongword(@texture^.pixelData[pos2])^;
        Plongword(@texture^.pixelData[pos2])^ := tempColour
      end;
  end;
end;

procedure ReplaceTexColour(const texHandle: TTextureHandle; oldColour, newColour: longword);
var
  a, b: smallint;
  texturePtr: PSoftwareTex;
  { pixel offset }
  offset: longword;
  px: PLongWord;
begin
  if not IsTexReady(texHandle) then exit;
  if oldColour = newColour then exit;

  texturePtr := BorrowTexPtr(texHandle);

  oldColour := ARGBtoABGR(oldColour);
  newColour := ARGBtoABGR(newColour);

  for offset:=0 to texturePtr^.width * texturePtr^.height - 1 do begin
    px := PLongWord(@texturePtr^.pixelData[offset * 4]);

    if px^ = oldColour then
      px^ := newColour;
  end;
end;


end.


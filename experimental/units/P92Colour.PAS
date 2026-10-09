{
  Colour conversion unit
  Part of Posit-92 game engine
}

unit P92Colour;

{$Mode ObjFPC}
{$H-}  { Use ShortStrings }
{$J-}  { Don't allow assignments to typed consts }

interface

uses P92Easings;

function ARGBtoRGBA(const colour: longword): longword;
function ARGBtoABGR(const colour: longword): longword;
function ABGRtoARGB(const colour: longword): longword;

{ Source-over blend of ABGR colours }
function BlendABGR(const srcABGR, destABGR: longword): longword; inline;

{ h, s, v: [0.0, 1.0] }
function HSVtoRGB(h, s, v: double): longword;

function MixColours(const colourA, colourB: longword; const perc: double): longword;

function MixColoursEased(
  const colourA, colourB: longword;
  const perc: double;
  const ease: TEaseFunc
): longword;


implementation

uses P92Maths;

function ARGBtoRGBA(const colour: longword): longword; inline;
begin
  ARGBtoRGBA := (
       ((colour and $00FFFFFF) shl 8)
    or ((colour and $FF000000) shr 24))
end;

function ARGBtoABGR(const colour: longword): longword; inline;
begin
  ARGBtoABGR :=
    (colour and $FF00FF00)
    or ((colour and $00FF0000) shr 16)
    or ((colour and $000000FF) shl 16)
end;

function ABGRtoARGB(const colour: longword): longword; inline;
begin
  ABGRtoARGB := ARGBtoABGR(colour)
end;

{ Returns exactly round(v / 255)
  for v in 0..65025 (i.e. 255 * 255) }
function Div255(v: longword): longword; inline;
begin
  inc(v, 128);
  Div255 := (v + (v shr 8)) shr 8
end;

function BlendABGR(const srcABGR, destABGR: longword): longword; inline;
var
  srcAlpha, invAlpha: longword;
  r, g, b, outAlpha: longword;
begin
  srcAlpha := srcABGR shr 24;
  invAlpha := 255 - srcAlpha;

  r := Div255((srcABGR and $FF) * srcAlpha + (destABGR and $FF) * invAlpha);
  g := Div255((srcABGR shr 8 and $FF) * srcAlpha + (destABGR shr 8 and $FF) * invAlpha);
  b := Div255((srcABGR shr 16 and $FF) * srcAlpha + (destABGR shr 16 and $FF) * invAlpha);
  outAlpha := srcAlpha + Div255((destABGR shr 24) * invAlpha);

  BlendABGR := (outAlpha shl 24) or (b shl 16) or (g shl 8) or r
end;


function HSVtoRGB(h, s, v: double): longword;
var
  r, g, b: byte;
  i: smallint;
  f, p, q, t: double;
begin
  r := 0; g := 0; b := 0;

  h := clamp(h, 0.0, 1.0);
  s := clamp(s, 0.0, 1.0);
  v := clamp(v, 0.0, 1.0);

  { Greyscale }
  if s = 0.0 then begin
    r := trunc(v * 255);
    g := r;
    b := r;
    HSVtoRGB := $FF000000 or (r shl 16) or (g shl 8) or b;
    exit
  end;

  { Convert hue to [0.0, 6.0] }
  h := h * 6.0;
  i := trunc(h);
  f := h - i;

  p := v * (1.0 - s);
  q := v * (1.0 - s * f);
  t := v * (1.0 - s * (1.0 - f));

  { Determine RGB }
  case i mod 6 of
    0: begin r := trunc(v * 255); g := trunc(t * 255); b := trunc(p * 255); end;
    1: begin r := trunc(q * 255); g := trunc(v * 255); b := trunc(p * 255); end;
    2: begin r := trunc(p * 255); g := trunc(v * 255); b := trunc(t * 255); end;
    3: begin r := trunc(p * 255); g := trunc(q * 255); b := trunc(v * 255); end;
    4: begin r := trunc(t * 255); g := trunc(p * 255); b := trunc(v * 255); end;
    5: begin r := trunc(v * 255); g := trunc(p * 255); b := trunc(q * 255); end;
  end;

  HSVtoRGB := $FF000000 or (r shl 16) or (g shl 8) or b
end;

function MixColours(const colourA, colourB: longword; const perc: double): longword;
var
  a, r, g, b: byte;
begin
  { Basically start + perc * range }
  a := trunc((colourA shr 24 and $FF) + perc * ((colourB shr 24 and $FF) - (colourA shr 24 and $FF)));
  r := trunc((colourA shr 16 and $FF) + perc * ((colourB shr 16 and $FF) - (colourA shr 16 and $FF)));
  g := trunc((colourA shr 8 and $FF) + perc * ((colourB shr 8 and $FF) - (colourA shr 8 and $FF)));
  b := trunc((colourA and $FF) + perc * ((colourB and $FF) - (colourA and $FF)));

  MixColours := (a shl 24) or (r shl 16) or (g shl 8) or b
end;

function MixColoursEased(const colourA, colourB: longword; const perc: double; const ease: TEaseFunc): longword;
begin
  MixColoursEased := MixColours(colourA, colourB, ease(perc))
end;


end.

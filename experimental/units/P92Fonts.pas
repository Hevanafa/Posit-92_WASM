unit P92Fonts;

{$Mode ObjFPC}
{$H-}  { Use ShortStrings }
{$J-}  { Don't allow assignments to typed consts }

interface

uses P92AssetHandles;

procedure LoadDefaultBMFont;
function GetDefaultFontHandle: TBMFontHandle;
function GetDefaultFontLineHeight: smallint;

procedure PrintDefault(const text: string; const x, y: smallint);
procedure PrintDefaultCentred(const text: string; const cx, y: smallint);
function MeasureDefault(const text: string): word;

{ Returns xadvance }
function PrintCharColour(const ch: char; const x, y: smallint; const colour: longword): smallint;


implementation

uses P92AssetRegistry, P92BMFont, P92Core;

var
  defaultFontHandle: TBMFontHandle;

procedure LoadDefaultBMFont;
begin
  defaultFontHandle := RequestBMFont(GetBootConfig.DefaultBMFontPath)
end;

function GetDefaultFontHandle: TBMFontHandle;
begin
  GetDefaultFontHandle := defaultFontHandle
end;

function GetDefaultFontLineHeight: smallint;
begin
  if defaultFontHandle = 0 then begin
    GetDefaultFontLineHeight := 0;
    exit
  end;

  GetDefaultFontLineHeight := BorrowBMFontPtr(defaultFontHandle)^.lineHeight
end;

procedure PrintDefault(const text: string; const x, y: smallint);
begin
  PrintBMFont(defaultFontHandle, text, x, y)
end;

procedure PrintDefaultCentred(const text: string; const cx, y: smallint);
var
  w: word;
begin
  w := MeasureDefault(text);
  PrintDefault(text, cx - w div 2, y)
end;

function MeasureDefault(const text: string): word;
begin
  MeasureDefault := MeasureBMFont(defaultFontHandle, text)
end;

function PrintCharColour(const ch: char; const x, y: smallint; const colour: longword): smallint;
begin
  PrintCharColour := PrintBMFontCharColour(
    defaultFontHandle, ch, x, y, colour)
end;

begin
  defaultFontHandle := 0;
end.


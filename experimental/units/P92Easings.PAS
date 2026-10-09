{
  Easings unit
  Part of Posit-92 game engine
  By Hevanafa

  Generic unit that contains easing functions
  All the time / tick units are in seconds
}

unit P92Easings;

{$Mode ObjFPC}
{$H+}{$J-}

interface

type
  TEaseFunc = function(perc: double): double;

{ Calculates normalised easing progress
  result := (t - startTick) / duration

  The result is not clamped to 0.0 .. 1.0
  Returns 1.0 if duration <= 0.0

  startTick: start time, in seconds
  duration: in seconds
  t: current time, in seconds
}
function GetEasingPerc(startTick, duration, t: double): double;

{ Returns true when the easing progress is >= 1.0
  The progress is obtained from GetEasingPerc

  startTick: start time, in seconds
  duration: in seconds
  t: current time, in seconds
}
function IsEasingComplete(const startTick, duration, t: double): boolean;

{
  a: start value
  z: end value (inclusive)
  perc: easing percentage [0.0 .. 1.0], can be obtained from GetPerc
}
function Lerp(const a, z, perc: double): double;

{
  a: start value
  z: end value (inclusive)
  perc: easing percentage [0.0 .. 1.0], can be obtained from GetPerc
}
function LerpEased(const a, z, perc: double; const ease: TEaseFunc): double;

{ Easing functions }

function EaseInSine(perc: double): double;
function EaseOutSine(perc: double): double;
function EaseInOutSine(perc: double): double;

function EaseInQuad(perc: double): double;
function EaseOutQuad(perc: double): double;
function EaseInOutQuad(perc: double): double;


implementation

uses P92Maths, P92Timing, P92Panic;

function GetEasingPerc(startTick, duration, t: double): double;
begin
  if duration <= 0.0 then begin
    GetEasingPerc := 1.0;
    exit
  end;

  GetEasingPerc := (t - startTick) / duration
end;

function IsEasingComplete(const startTick, duration, t: double):boolean;
begin
  IsEasingComplete := GetEasingPerc(startTick, duration, t) >= 1.0
end;

function Lerp(const a, z, perc: double): double;
begin
  Lerp := a + perc * (z - a)
end;

function LerpEased(const a, z, perc: double; const ease: TEaseFunc): double;
begin
  if not assigned(ease) then
    PanicHalt('LerpEased: ease function is not supplied!');

  LerpEased := a + ease(perc) * (z - a)
end;


function EaseInSine(perc: double): double;
begin
  EaseInSine := 1 - cos(perc * pi / 2)
end;

function EaseOutSine(perc: double): double;
begin
  EaseOutSine := sin(perc * pi / 2)
end;

function EaseInOutSine(perc: double): double;
begin
  EaseInOutSine := -(cos(pi * perc) - 1) /2
end;


function EaseInQuad(perc: double):double;
begin
  EaseInQuad := perc * perc
end;

function EaseOutQuad(perc: double): double;
begin
  EaseOutQuad := 1 - (1 - perc) * (1 - perc)
end;

function EaseInOutQuad(perc: double): double;
begin
  if perc < 0.5 then
    EaseInOutQuad := 2 * perc * perc
  else begin
    perc := -2 * perc + 2;
    EaseInOutQuad := 1 - (perc * perc) / 2;
  end;
end;


end.

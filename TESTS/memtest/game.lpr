{
  Heap memory test project
  Part of Posit-92 game engine

  Mixins: bmfont
}

library Game;

{$Mode ObjFPC}
{$H+}  { Use AnsiStrings }
{$J-}  { Switch off assignments to typed constants }
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}

uses
  P92Core, P92Conversions, P92Fonts, P92WasmHost, P92AssetRegistry,
  P92Logger, P92Keyboard, P92Mouse,
  P92TexDraw, P92IMGUI, P92Geometry, P92Graphics, P92Iif,
  P92Timing, P92FPS, P92VGA, P92WasmHeap,
  Assets, ObjectTests;

type
  TMemTestTab = (
    MemTestGlobal,
    MemTestBucket,
    MemTestLinkedList
  );

const
  Black = $FF000000;

var
  { Game state variables }
  gameTime: double;
  actualMode: TMemTestTab;

  nextScanTick: double;

  totalSlots,
  badSlots,
  freeBuckets,
  slackBytes: array[0..high(BucketSizes)] of longword;

procedure TestBasicAllocFree;
var
  p1, p2: pointer;
begin
  writelog('Begin TestBasicAllocFree');

  p1 := GetMem(1024);
  assert(p1 <> nil, 'Alloc 1024 failed');
  Freemem(p1);

  p2 := GetMem(1024);
  assert(p2 = p1, 'Expected the same address after free');
  Freemem(p2);

  writelog('End of TestBasicAllocFree');
end;

procedure TestExhaustAndCoalesce;
var
  blocks: array[0..2047] of pointer;
  a: smallint;
  big: pointer;
begin
  writelog('Begin TestExhaustAndCoalesce');

  { Exhaust the memory with 512-byte blocks }
  for a:=0 to high(blocks) do begin
    blocks[a] := getmem(512);
    assert(blocks[a] <> nil, 'Exhaustion at block ' + I32Str(a));
  end;

  assert(GetMem(512) = nil, 'Should be out-of-memory');

  { Free all }
  for a:=0 to high(blocks) do
    freemem(blocks[a]);

  { Full coalescing test }
  big := GetMem(1 shl 20);  { 20 is obtained from BuddyMaxOrder }
  assert(big <> nil, 'Coalescing to max order failed');
  freemem(big);

  writelog('End of TestExhaustAndCoalesce');
end;


procedure TestSplitNoOverlap;
var
  a, b, c: PByte;
begin
  writelog('Begin TestSplitNoOverlap');

  a := getmem(1 shl 18); { 256KB }
  b := getmem(1 shl 16); { 64KB }
  c := getmem(1 shl 16); { 64KB }

  Assert((a <> nil) and (b <> nil) and (c <> nil), 'alloc failed');
  assert(abs(ptrint(a) - ptrint(b)) >= (1 shl 18), 'a/b overlap');
  assert(abs(ptrint(b) - ptrint(c)) >= (1 shl 16), 'b/c overlap');

  freemem(b);
  freemem(c);
  freemem(a);

  writelog('End of TestSplitNoOverlap');
end;

procedure TestInterleavedFree;
var
  a, b, c, d: pointer;
begin
  writelog('Begin TestInterleavedFree');

  a := getmem(512);
  b := getmem(512);
  c := getmem(512);
  d := getmem(512);

  { Free them out of order, since only adjacent buddies should merge }
  freemem(pbyte(b));
  freemem(pbyte(d));
  freemem(pbyte(a));  { a + b should coalesce to 1024 }
  freemem(pbyte(c));  { c + d should coalesce, then merge up }

  writelog('End of TestInterleavedFree');
end;

procedure TestCrossTierRealloc;
var
  p: pointer;
begin
  writelog('Begin TestCrossTierRealloc');

  p := getmem(128);
  p := ReAllocMem(p, 4096);

  assert(p <> nil, 'Realloc to buddy alloc failed');

  p := ReAllocMem(p, 64);

  assert(p <> nil, 'Realloc to bucket alloc failed');

  freemem(p);

  writelog('End of TestCrossTierRealloc');
end;

procedure DoTests;
begin
  { Regular tests: }
  TestBasicAllocFree;
  TestSplitNoOverlap;
  TestInterleavedFree;
  TestCrossTierRealloc;

  { Optional tests: }
  { TestExhaustAndCoalesce; }

  { Object instance tests: }
  TestSingleInstance;
  TestObjectList;
end;

function ButtonColoured(
  const caption: string;
  const x, y, width, height: smallint;
  const colour: longword
): boolean;
const
  Padding = 4;
var
  zone: TZone;
  thisWidgetID: smallint;
  { buttonColour: longword; }
begin
  GUIAssertFontSet;

  zone.x := x;
  zone.y := y;
  zone.width := width;
  zone.height := height;

  { Update logic }

  thisWidgetID := AcquireNextWidgetID;

  if PointInZone(GetMousePoint, zone) then begin
    SetHotWidget(thisWidgetID);

    if GetMouseJustPressed then SetActiveWidget(thisWidgetID);
  end;

  { Render logic }

  {
  if GetActiveWidget = thisWidgetID then
    buttonColour := AccentDark
  else if GetHotWidget = thisWidgetID then
    buttonColour := AccentPale
  else
    buttonColour := AccentNormal;
  }

  RectFill(
    x, y,
    x + width - 1, y + height - 1,
    colour);

  Rect(
    x, y,
    x + width - 1, y + height - 1,
    $FF000000);

  TextLabel(caption, x + Padding, y + Padding);

  if GetMouseJustReleased and (GetHotWidget = thisWidgetID) and (GetActiveWidget = thisWidgetID) then
    { activeWidget = -1 }  { Index reset is handled at the end of draw }
    ButtonColoured := true
  else
    ButtonColoured := false;
end;

procedure OnPreload;
begin
  texSpecimenP92[0] := RequestImage('assets/images/specimen_p-92_1.png');
  texSpecimenP92[1] := RequestImage('assets/images/specimen_p-92_2.png');

  texTest := RequestImage('assets/fonts/p92_sans_8_regular.png');
end;

procedure OnReady;
begin
  HideCursor;

  { Initialise game state here }
  gameTime := 0.0;
  nextScanTick := GetTimer;

  { DoTests; }

  actualMode := MemTestGlobal;
end;

procedure Update;
begin
  if IsKeyDown(SC_ESCAPE) then SignalDone;

  gameTime := gameTime + DeltaTime
end;

procedure Draw;
const
  ViewTop = 40;
var
  a: smallint;
  s: string;
  tableRowTop: smallint;
  now: double;
begin
  Cls($FF6495ED);

  now := GetTimer;

  if now >= nextScanTick then begin
    nextScanTick := now + 2.0;

    for a:=0 to high(BucketSizes) do begin
      totalSlots[a] := GetBucketTotalSlots(a);
      badSlots[a] := GetBucketBadSlots(a);
      freeBuckets[a] := GetBucketFreeSlots(a);
      slackBytes[a] := GetBucketSlackBytes(a);
    end;
  end;

  if (trunc(gameTime * 4) and 1) > 0 then
    Spr(texSpecimenP92[1], 148, 124)
  else
    Spr(texSpecimenP92[0], 148, 124);

  PrintDefaultCentred('Hello world!', VgaWidth div 2, 160);

  if ButtonColoured(
    'Global',
    10, 10, 48, 18,
    U32Iif(actualMode = MemTestGlobal, $FF5555FF, Black)) then
      actualMode := MemTestGlobal;

  if ButtonColoured(
    'Bucket',
    60, 10, 48, 18,
    U32Iif(actualMode = MemTestBucket, $FF5555FF, Black)) then
      actualMode := MemTestBucket;

  if ButtonColoured(
    'Linked list',
    110, 10, 64, 18,
    U32Iif(actualMode = MemTestLinkedList, $FF5555FF, Black)) then
      actualMode := MemTestLinkedList;

  case actualMode of
    MemTestGlobal: begin
      PrintDefault(
        'Total heap size: '
        + i32str(WasmMemorySize - longword(BorrowHeapRegionStart)),
        10, ViewTop);
    end;

    MemTestBucket: begin
      s := '';

      for a:=0 to high(BucketSizes) do
        s := s + I32Str(BucketSizes[a]) + StringIif(a < high(BucketSizes), ', ', '');

      PrintDefault('Bucket sizes: ' + s, 10, ViewTop);

      { Header row }
      tableRowTop := ViewTop + 20;
      PrintDefault('Bucket', 10, tableRowTop);
      PrintDefault('Free', 50, tableRowTop);
      PrintDefault('Total slots', 90, tableRowTop);
      PrintDefault('Bad slots', 140, tableRowTop);
      PrintDefault('Slack bytes', 190, tableRowTop);

      for a:=0 to high(BucketWeights) do begin
        tableRowTop := ViewTop + 30 + a * 10;

        { Bucket size }
        PrintDefault(I32Str(BucketSizes[a]) + ' B', 10, tableRowTop);

        { Free }
        PrintDefault(i32str(freeBuckets[a]), 50, tableRowTop);

        { Used }
        { PrintDefault('?', 50, ViewTop + 30 + a * 10); }

        { Total slots }
        PrintDefault(I32Str(totalSlots[a]), 90, tableRowTop);
        PrintDefault(I32Str(badSlots[a]), 140, tableRowTop);
        PrintDefault(I32Str(slackBytes[a]), 190, tableRowTop);
      end;
    end;

    MemTestLinkedList: ;
  end;
end;

procedure Init;
var
  config: TP92AppConfig;
begin
  config := DefaultP92AppConfig;

  config.EnableDrawFPS := true;

  config.OnPreload := @OnPreload;
  config.OnReady := @OnReady;
  config.Update := @Update;
  config.Draw := @Draw;

  P92Start(config);
end;

exports
  Init;

begin
{ Starting point is intentionally left empty }
end.

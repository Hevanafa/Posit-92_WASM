unit MapItem;

{$Mode ObjFPC}
{$H+}{$J-}

interface

uses
  P92Geometry, P92AssetHandles;

type
  TItemType = (
    ItemCoin
  );

  TMapItem = record
    active: boolean;
    itemType: TItemType;

    { uses world coords }
    zone: TZone;

    texHandle: TTextureHandle;

    { relative to zone.y }
    offsetY: double;
  end;


implementation

end.


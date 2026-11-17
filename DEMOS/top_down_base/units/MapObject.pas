unit MapObject;

{$Mode ObjFPC}
{$H+}{$J-}

interface

uses
  P92Geometry, P92AssetHandles;

type
  TMapObjectType = (
    MapObjectCrate
  );

  TMapObject = record
    active: boolean;
    objectType: TMapObjectType;

    { uses world coords }
    zone: TZone;
    texHandle: TTextureHandle;
  end;


implementation

end.


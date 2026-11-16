unit MapObject;

interface

uses
  P92Geometry, P92AssetHandles;

type
  TMapObject = record
    active: boolean;
    zone: TZone;
    texHandle: TTextureHandle;
  end;


implementation

end.


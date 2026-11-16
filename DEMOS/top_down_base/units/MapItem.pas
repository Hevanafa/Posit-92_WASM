unit MapItem;

{$Mode ObjFPC}
{$H+}{$J-}

interface

uses
  P92Geometry, P92AssetHandles;

type
  TMapItem = record
    active: boolean;
    zone: TZone;
    texHandle: TTextureHandle;
    offsetY: double;
  end;


implementation

end.


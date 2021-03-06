unit uWindows;

interface

uses Registry, Windows, SysUtils, Classes;

function GetProgramFilesDir: string;
function DeleteFolder(sDir: string): Boolean;
function GetWidowScreenPosition: TPoint;
function GetChildWidowScreenPosition: TPoint;

implementation
uses uConst;

function GetProgramFilesDir: string;
var
  r: TRegistry;
begin
  r := TRegistry.Create;

  r.RootKey := HKEY_LOCAL_MACHINE;

  if r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion', False) then
    result := r.ReadString('ProgramFilesDir')
  else
    result := NULL;

  r.CloseKey;
  r.Free;
end;

function DeleteFolder(sDir: string): Boolean;
var
  oList: TStringList;
  iFindResult: integer;
  srSchRec : TSearchRec;
  cnt: integer;
begin
  cnt := 0;
  oList := TStringList.Create;

  try
    iFindResult := FindFirst(sDir + '\*.*', faAnyFile - faDirectory, srSchRec);

    while iFindResult = 0 do
    begin
      oList.Add(sDir + '\' + srSchRec.Name);
      iFindResult := FindNext(srSchRec);
    end;

    while oList.Count > 0 do
    begin
      if not DeleteFile(oList.Strings[0]) then
        inc(cnt);
      oList.Delete(0);
    end;

    result := cnt = 0;
  except
    result := false;
  end;
end;

function GetWidowScreenPosition: TPoint;
var
  X, Y: integer;
begin
  X := GetSystemMetrics(SM_CYBORDER);
  Y := GetSystemMetrics(SM_CXBORDER);
  Y := Y + GetSystemMetrics(SM_CYCAPTION);
  Y := Y + GetSystemMetrics(SM_CYMENU);

  result := Point(X, Y);
end;

function GetChildWidowScreenPosition: TPoint;
var
  X, Y: integer;
begin
  X := GetSystemMetrics(SM_CYBORDER);
  Y := GetSystemMetrics(SM_CXBORDER);
  Y := Y + GetSystemMetrics(SM_CYCAPTION) * 2;
  Y := Y + GetSystemMetrics(SM_CYMENU);

  result := Point(X, Y);
end;

end.

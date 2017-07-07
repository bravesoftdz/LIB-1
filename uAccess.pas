unit uAccess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComObj, ActiveX, StdCtrls;

function MDB_CreateDB(const sPath, sPass: string; var sErr: string): Boolean;
function MDB_ChangePWD(const sPath, sOldPass, sNewPass: string;
                   var sErr: string): Boolean;

implementation

function MDB_CreateDB(const sPath, sPass: string; var sErr: string): Boolean;
const
   csConnStr = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source="%s"';
   csConnStrPass = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source="%s";Jet OLEDB:Database Password=%s';
var
   oleCatalog: OleVariant;
   sConnStr: string;
begin
   Result := false;
   if trim(sPass) = '' then
      sConnStr := Format(csConnStr, [sPath])
   else
      sConnStr := Format(csConnStrPass, [sPath, sPass]);
   try
      try
         oleCatalog := CreateOleObject('ADOX.Catalog');
         oleCatalog.Create(sConnStr);
      finally
         oleCatalog := Unassigned;
      end;
      Result := true;
    except
      on Err:Exception do sErr := Err.Message;
    end;
end;


// �н����� ����/����
// �����ͺ��̽� ����ȭ�ϱ�
function MDB_ChangePWD(const sPath, sOldPass, sNewPass: string;
                   var sErr: string): Boolean;
const
   CONN_STR = 'Data Source="%s";Jet OLEDB:Database Password=%s';
var
   ovEngine: OleVariant;
   sBakPath: string;
   sStr1, sStr2: string;
begin
   Result := false;
   // ������� �н�
   sBakPath := ChangeFileExt(sPath, '.bak');
   // ���� ��� ���� ����
   DeleteFile(sBakPath);

   sStr1 := Format(CONN_STR, [sPath, sOldPass]);
   sStr2 := Format(CONN_STR, [sBakPath, sNewPass]);
   try
      try
         ovEngine := CreateOleObject('JRO.JetEngine');
         // ����ȭ����� �̿��� �н����� ����
         ovEngine.CompactDatabase(sStr1, sStr2);
         // ���� ������ ����
         DeleteFile(sPath);
         RenameFile(sBakPath, sPath);
      finally
         ovEngine := Unassigned;
      end;
      Result := true;
   except
      on Err:Exception do sErr := Err.Message;
   end;
end;

end.
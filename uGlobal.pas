unit uGlobal;

interface

uses SysUtils, Dialogs, Controls, Forms, StdCtrls, Classes, cxTextEdit,
  cxRadioGroup, cxCheckBox, cxDropDownEdit, cxTimeEdit, cxButtonEdit,
  cxMaskEdit, cxCalendar, DateUtils, DBCtrls, cxMemo, cxDBEdit;

const
  cIniFileName = 'SocialWork.ini';
  cUpdaterName = 'RHnCoUpdater.exe';
  cAppName = 'SocialWork';
  cVersion = '5.3';
  // 1.2 - 사용자 등록되지 않는 문제를 고쳤음
  // 1.3 - 스케쥴 OptionView Additionaltimezone 을 System 으로 바꾸었음
  // 1.4 - 환자정보관리에 병동별 환자보기 추가 2011.11.30
  // 1.5 - 입원종별 추가(보험, 보호 등)
  // 1.6 - 진단명 30자 -> 100자 2011.12.01
  // 1.7 - 여러가지 버그 수정 2011.12.05
  // 1.8 - "
  // 1.9 - "
  // 2.0 - 퀵리포트 프린트 셋업 과 프린트 연동 QuickRep.PrinterSetup; if QuickRep.Tag=0 then Quickrep.Print;
  // 2.1 - intake 면담일시 수정 안되는 부분 수정 2011.12.08
  // 2.2 - 일정추가 시 의견란 크게함. 진행내용 입력 그리드 order by patientname 추가
  // 2.3 - 정신치료 의견란 입력크기 1000자 이하로 수정
  // 2.4 - 요구사항 추가
  // 2.7 - 외출/외박 에 CR 구분 추가
  // 2.8 - 정신치료.. 오류 수정
  // 2.9 - GetLastID 의 result: integer -> string 으로 변경
  // 2.91- 외출외박관리 수정
  // 3.0 - 통계
  // 3.1 - 통계수정
  // 3.2 - 사업지도, 재활, 방문 통계에서 차수 표시
  // 3.3 - 통계출력
  // 3.4 - 통계 Print All
  // 3.5 - 일괄입력 에러 수정
  // 3.6 - 외박외출, 정신치료 시간중복 체크 작업
  // 3.7 - 정신치료 내용출력시 Title 을 ProgramTypeName 으로 출력되게 수정
  // 3.8 - 진행내용 오류수정
  // 3.9 - 외박/외출 삭제기능 추가
  // 4.0 - 통계 전체보기 추가
  // 4.1 - 가정방문기록지 완료
  // 4.2 - 정신치료관리 schedule user 중복(hospital ID check 수정)
  // 4.3 - Social Worker's Opinion -> 3000 자로 수정
  // 4.4 - 출력 글자 수정
  // 4.5 - 출력 글자 수정
  // 4.6 - Intake 개인력 글자수 늘림 -> 3000자.
  // 4.7 - skin 삭제 : 화면 깜박거림 문제 제거
  // 5.0 - 병동이동 기능 추가
  // 5.1 - 신규입원등록 오류 수정
  // 5.2 - 병실변경 오류 수정
  // 5.201 - DB Connectin String 수정
  // 5.202 - 신환 OutDate, OutTime 세팅
  // 5.203 - 키워드, 기록지 이름변경 기능
  // 5.204 - 개인력 칸 크기 조절
  // 5.205 - 분석집단치료 추가, 통계 주간 합계 보기 추가
  // 5.3 - 업데이트 방식을 FTP 로 변경.

  cPORT = 118;
  FTP_LOGIN_FAIL = 0;
  FTP_LOGIN_SUCCESS = 1;
  cUpdaterFileName = 'RH_OCS_Updater.exe';
  cRegKey = '\Software\EastSeaSoftware\SocialWork\';

  cIn = 0;
  cOut = 1;
  cMale = '남';
  cFeMale = '여';
  cAllDayEvent = 3;
  cNotAllDayEvent = 2;
  cJobFree = 0;
  cJobDone = 2;
  cUnUsed = 0;
  cUsed = 1;

  cDelimeter = ';';

  cDoing = 1;
  cDone = 0;

  NULLString = '';
  cDbConStr =
    'Provider=SQLOLEDB.1;Data Source=%s;Initial Catalog=%s;User ID=%s;Password=%s;Persist Security Info=True';
  cAllWard = '전체병동';
  cAll = '전체';

  cRecordIntake     = 0;
  cRecordSurvey1    = 1;
  cRecordSurvey2    = 2;
  cRecordCounseling = 3;
  cRecordTraining   = 4;
  cRecordVisit       = 5;

type
  TEditMode = (emAppend, emUpdate);

  TRecordType = (rtError, rtNone, rtIntake, rtSurvey1, rtSurvey2, rtCounseling,
    rtTraining, rtProgram, rtVisit, rtFamily, rtOverNight);

  TDateInfo = record
    Date: TDateTime;
    StartDate: TDateTime;
    FinishDate: TDateTime;
  private
    function GetDays: integer;
    function GetYear: integer;
    function GetMonth: integer;
    function GetWeeks: integer;
    function GetFDate: string;
    function GetSDate: string;
    function GetFirstDay: TDateTime;
    function GetLastDay: TDateTime;
    function GetDay: integer;
  public
    property Year: integer read GetYear;
    property Month: integer read GetMonth;
    property Day: integer read GetDay;
    property Days: integer read GetDays;
    property Weeks: integer read GetWeeks;
    property SDate: string read GetSDate;
    property FDate: string read GetFDate;
    property FirstDay: TDateTime read GetFirstDay;
    property LastDay: TDateTime read GetLastDay;
  end;

  TFTPServerConfig = record
    Host: string;
    UserName: string;
    Password: string;
  public
    procedure Copy(oFTPServer: TFTPServerConfig);
  end;

  TID = record
    ID: integer;
    Name: string;
    function ToString: string;
  end;

  TFieldInfo = record
    Name: string;
    Size: integer;
  end;

  TInputInfo = record
    InputTitle: string;
    InputField: TFieldInfo;
    Used: Boolean;
    VisibleWardInfo: Boolean;
    Seq: integer;
    procedure Clear;
  end;

  TInputResult = record
    Result: TModalResult;
    Text: string;
    Used: Boolean;
    Seq: integer;
  end;

  TDateString = record
    Year: string;
    Month: string;
    Day: string;
    procedure SetDate(sDate: string);
    function GetYear: integer;
    function GetMonth: integer;
    function GetDay: integer;
  public
    property nYear: integer read GetYear;
    property nMonth: integer read GetMonth;
    property nDay: integer read GetDay;
  end;

  TDBServerConfig = record
    DataSource: string;
    DBName: string;
    UserID: string;
    Password: string;
  public
    procedure Copy(oServer: TDBServerConfig);
  end;

  TUserInfo = record
    HospitalID: integer;
    HospitalName: string;
    AppTitle: string;
    UserID: string;
    Password: string;
    UserName: string;
    Worker: Boolean;
    Doctor: Boolean;
    Admin: Boolean;
    Used: Boolean;
  public
    procedure Clear;
    function isEmpty: Boolean;
  end;

  TInOutInfo = record
    InOutID: integer;
    nHospitalID: integer;
    nIntypeID: integer;
    nBohumID: integer;
    sPatientID: string;
    sInDate: string;
    sInTime: string;
    sOutDate: string;
    sOutTime: string;
    sRoom: string;
    sDiagName: string;
    sWardName: string;
    sDoctorName: string;
    sUserName: string;
    bUsed: Boolean;
  public
    procedure Clear;
    procedure Copy(Sor: TInOutInfo);
    function isEmpty: Boolean;
    function isValidData: Boolean;
  end;

  TPatientInfo = record
    nHospitalID: integer;
    sPatientID: string;
    sPatientName: string;
    sBirthday: string;
    bMale: Boolean;
  public
    procedure Clear;
    procedure Copy(Sor: TPatientInfo);
    function isEmpty: Boolean;
    function isValidData: Boolean;
  end;

  TNewPatientInfo = record
    oPatient: TPatientInfo;
    oInOut: TInOutInfo;
    constructor Create(nHID: integer; sPID: string);
  end;

  TIntake = record
    Mode: TEditMode;
    oPatient: TPatientInfo;
    oInOut: TInOutInfo;
    InfoDonor: string;
    MeetingDate: string;
    InMotivation: string;
    MajorProblem: string;
    InHistory: string;
    PersonHistory: string;
    WorkerOpinion: string;
  public
    procedure Clear;
  end;

  TProgramInfo = record
    Mode: TEditMode;
    ProgramTypeID: integer;
    ProgramTypeName: string;
    Color: integer;
    HospitalID: integer;
    ProgramID: integer;
    ProgramName: string;
    WardID: integer;
    WardName: string;
    LinkRecordID: integer;
    UseAll: Boolean;
    Used: Boolean;
  public
    procedure Clear;
  end;

  TRelationshipInfo = record
    FamilyName: string;
    Health: string;
    InMate: Boolean;
    Pay: Boolean;
    RelationshipID: integer;
    RelationshipName: string;
    procedure Clear;
  end;

  TShortKeyInfo = record
    Mode: TEditMode;
    Keyword: string;
    Content: string;
    procedure Clear;
  end;

  TGlobal = class
    function isNullStr(str: string): Boolean;
    function isNotNullStr(str: string): Boolean;
    function DateToString(oDate: TDateTime): String; overload;
    function DateToString(oDate: TDateTime; nPos, nCount: integer): String;
      overload;
    function DateToDate(oDate: TDateTime): TDateTime;
    function DateToTime(oDate: TDateTime): TTime;
    function DateTimeToString(oDate: TDateTime): string;
    function DateAndTimeToDateTime(oDate: TDate; oTime: TTime): TDateTime;
    function isTimeString(sTime: string): Boolean;
    function TimeToString(oTime: TTime): string;
    function TimeToStringHN(oTime: TTime): string;
    function StringToTime(sTime: string; var oT: TTime): Boolean; overload;
    function StringToTime(sTime: string): TTime; overload;
    function StringToDate(sDate: string; var oD: TDateTime): Boolean; overload;
    function StringToDate(sDate: string): TDateTime; overload;
    function FillZero(nV, nCount: integer): String;
    function isDateString(sDate: string): Boolean;
    function isDigitString(sDigit: string): Boolean;
    function GetAge(sBirthday, sNow: string): string;
    function isHangul(str: string): Boolean;
    function InputMsg(sTitle, sInputName: string; nInputSize: integer;
      bUsed: Boolean; bVisibleWardInfo: Boolean = False;
      nSeq: integer = 0): TInputResult;
    procedure Msg(sMsg: string; nInterval: integer=0);
    function YesNo(sMsg: string): TModalResult;
    function GetItemIndex(sItemIndex: string): integer; overload;
    function GetItemIndex(nItemIndex: integer): string; overload;
    procedure ClearComponents(oForm: TForm);
    procedure SetListFromText(sText, sDelimeter: string; oList: TStrings);
    procedure SetTextFromList(oList: TStrings; sDelimeter: string;
      var sText: string);
    function GetFileSize(sFileName: string): integer;
    procedure GetKeywordContent(Memo: TMemo); overload;
    procedure GetKeywordContent(Memo: TDBMemo); overload;
    procedure GetKeywordContent(Memo: TcxMemo); overload;
    procedure GetKeywordContent(Memo: TcxDBMemo); overload;
    function GetLastWord(Sor, delimeter: string): string;
  end;

var
  oGlobal: TGlobal;

implementation

uses uInputName, uMsg, uYesNo, uKeywordMgr;

{ Global Function }
function TGlobal.isNullStr(str: string): Boolean;
begin
  Result := trim(str) = NULLString;
end;

function TGlobal.isTimeString(sTime: string): Boolean;
begin
  Result := False;
  if length(sTime) <> 8 then
    Exit;

  Result := isDigitString(Copy(sTime, 1, 2)) and isDigitString
    (Copy(sTime, 4, 2)) and isDigitString(Copy(sTime, 7, 2));
end;

procedure TGlobal.Msg(sMsg: string; nInterval: integer=0);
var
  oMsg: TfrmMsg;
begin
  Application.CreateForm(TfrmMsg, oMsg);

  oMsg.Msg := sMsg;
  oMsg.Interval := nInterval;
  oMsg.ShowModal;

  oMsg.Free;
end;

function TGlobal.isNotNullStr(str: string): Boolean;
begin
  Result := not isNullStr(str);
end;

function TGlobal.isDigitString(sDigit: string): Boolean;
var
  len, i: integer;
begin
  Result := true;

  len := length(sDigit);

  if len < 1 then
    Result := False
  else
    for i := 1 to len do
    begin
      if not CharInSet(sDigit[i], ['0' .. '9']) then
      begin
        Result := False;
        break;
      end;
    end;
end;

function TGlobal.isHangul(str: string): Boolean;
var
  s: string;
  w: Word;
begin
  s := trim(str);
  if length(s) <> 1 then
    Result := False
  else
  begin
    w := Word(s[1]);

    Result := w > 255;
  end;
end;

function TGlobal.FillZero(nV, nCount: integer): String;
var
  sV: string;
  len, i: integer;
begin
  sV := inttostr(nV);
  len := length(sV);

  if len >= nCount then
    Result := Copy(sV, 1, nCount)
  else
  begin
    Result := sV;
    for i := 1 to nCount - len do
      Result := '0' + Result;
  end;
end;

function TGlobal.GetAge(sBirthday, sNow: string): string;
var
  oBirthday, oNow: TDateString;
begin
  if (not isDateString(sBirthday)) or (not isDateString(sNow)) then
    Result := NULLString
  else
  begin
    oBirthday.SetDate(sBirthday);
    oNow.SetDate(sNow);

    if oBirthday.nMonth < oNow.nMonth then
      Result := inttostr(oNow.nYear - oBirthday.nYear)
    else if oBirthday.nMonth = oNow.nMonth then
    begin
      if oBirthday.nDay <= oNow.nDay then
        Result := inttostr(oNow.nYear - oBirthday.nYear)
      else
        Result := inttostr(oNow.nYear - oBirthday.nYear - 1);
    end
    else
      Result := inttostr(oNow.nYear - oBirthday.nYear - 1);
  end;
end;

function TGlobal.GetFileSize(sFileName: string): integer;
var
  f: file of Byte;
begin
  if not FileExists(sFileName) then
  begin
    Result := 0;
    Exit;
  end;

  AssignFile(f, sFileName);
  Reset(f);

  Result := FileSize(f);

  CloseFile(f);
end;

function TGlobal.GetItemIndex(nItemIndex: integer): string;
begin
  if nItemIndex < 0 then
    Result := ''
  else
    Result := inttostr(nItemIndex);
end;

procedure TGlobal.GetKeywordContent(Memo: TDBMemo);
begin
  if (frmKeywordMgr.ShowModal=mrOK) and
     (not frmKeywordMgr.frameKeyword.adoKeyword.IsEmpty) and
     oGlobal.isNotNullStr(frmKeywordMgr.frameKeyword.adoKeyword.FieldByName('Content').AsString) then
    Memo.SelText := frmKeywordMgr.frameKeyword.adoKeyword.FieldByName('Content').AsString + #13#10;
end;

procedure TGlobal.GetKeywordContent(Memo: TMemo);
begin
  if (frmKeywordMgr.ShowModal=mrOK) and
     (not frmKeywordMgr.frameKeyword.adoKeyword.IsEmpty) and
     oGlobal.isNotNullStr(frmKeywordMgr.frameKeyword.adoKeyword.FieldByName('Content').AsString) then
    Memo.SelText := frmKeywordMgr.frameKeyword.adoKeyword.FieldByName('Content').AsString + #13#10;
end;

procedure TGlobal.GetKeywordContent(Memo: TcxDBMemo);
begin
  if (frmKeywordMgr.ShowModal=mrOK) and
     (not frmKeywordMgr.frameKeyword.adoKeyword.IsEmpty) and
     oGlobal.isNotNullStr(frmKeywordMgr.frameKeyword.adoKeyword.FieldByName('Content').AsString) then
    Memo.SelText := frmKeywordMgr.frameKeyword.adoKeyword.FieldByName('Content').AsString + #13#10;
end;

function TGlobal.GetLastWord(Sor, delimeter: string): string;
var
  len, nPos: integer;
begin
  len := length(Sor);

  Result := Sor;
  nPos := Pos(delimeter, Result);
  while nPos > 0 do
  begin
    Result := Copy(Result, nPos + 1, len - nPos);
    nPos := Pos(delimeter, Result);
  end;
end;

procedure TGlobal.GetKeywordContent(Memo: TcxMemo);
begin
  if (frmKeywordMgr.ShowModal=mrOK) and
     (not frmKeywordMgr.frameKeyword.adoKeyword.IsEmpty) and
     oGlobal.isNotNullStr(frmKeywordMgr.frameKeyword.adoKeyword.FieldByName('Content').AsString) then
    Memo.SelText := frmKeywordMgr.frameKeyword.adoKeyword.FieldByName('Content').AsString + #13#10;
end;

procedure TGlobal.SetListFromText(sText, sDelimeter: string; oList: TStrings);
var
  nPos: integer;
begin
  oList.Clear;

  try
    nPos := pos(sDelimeter, sText);
    while nPos > 0 do
    begin
      oList.Add(Copy(sText, 1, nPos - 1));
      sText := Copy(sText, nPos + 1, length(sText) - nPos);

      nPos := pos(sDelimeter, sText);
    end;
  except
  end;
end;

procedure TGlobal.SetTextFromList(oList: TStrings; sDelimeter: string;
  var sText: string);
var
  n: integer;
begin
  sText := NULLString;

  for n := 0 to oList.Count - 1 do
    sText := sText + oList[n] + sDelimeter;
end;

function TGlobal.GetItemIndex(sItemIndex: string): integer;
begin
  if isDigitString(sItemIndex) then
    Result := strtoint(sItemIndex)
  else
    Result := -1;
end;

function TGlobal.InputMsg(sTitle, sInputName: string; nInputSize: integer;
  bUsed: Boolean; bVisibleWardInfo: Boolean = False;
  nSeq: integer = 0): TInputResult;
var
  oInputForm: TfrmInputName;
begin
  Application.CreateForm(TfrmInputName, oInputForm);

  oInputForm.oInput.Clear;
  oInputForm.oInput.InputTitle := sTitle;
  oInputForm.oInput.InputField.Name := sInputName;
  oInputForm.oInput.InputField.Size := nInputSize;
  oInputForm.oInput.Used := bUsed;
  oInputForm.oInput.VisibleWardInfo := bVisibleWardInfo;
  oInputForm.oInput.Seq := nSeq;

  Result.Result := oInputForm.ShowModal;
  Result.Text := trim(oInputForm.txtInput.Text);
  Result.Used := oInputForm.chkUsed.Checked;
  Result.Seq := oInputForm.spinSeq.Value;

  oInputForm.Free;
end;

function TGlobal.isDateString(sDate: string): Boolean;
begin
  Result := False;
  if length(sDate) <> 10 then
    Exit;

  Result := isDigitString(Copy(sDate, 1, 4)) and isDigitString
    (Copy(sDate, 6, 2)) and isDigitString(Copy(sDate, 9, 2));
end;

procedure TGlobal.ClearComponents(oForm: TForm);
var
  n: integer;
begin
  for n := 0 to oForm.ComponentCount - 1 do
    if oForm.Components[n] is TcxTextEdit then
      TcxTextEdit(oForm.Components[n]).Clear
    else if oForm.Components[n] is TMemo then
      TMemo(oForm.Components[n]).Lines.Clear
    else if oForm.Components[n] is TcxRadioGroup then
      TcxRadioGroup(oForm.Components[n]).ItemIndex := -1
    else if oForm.Components[n] is TcxCheckBox then
      TcxCheckBox(oForm.Components[n]).Checked := False
    else if oForm.Components[n] is TcxDateEdit then
      TcxDateEdit(oForm.Components[n]).Clear
    else if oForm.Components[n] is TcxTimeEdit then
      TcxTimeEdit(oForm.Components[n]).Clear
    else if oForm.Components[n] is TcxCheckBox then
      TcxCheckBox(oForm.Components[n]).Checked := False
    else if oForm.Components[n] is TcxButtonEdit then
      TcxButtonEdit(oForm.Components[n]).Clear
end;

function TGlobal.DateAndTimeToDateTime(oDate: TDate; oTime: TTime): TDateTime;
var
  Y, M, D: Word;
  H, n, s, MS: Word;
begin
  DecodeDate(oDate, Y, M, D);
  DecodeTime(oTime, H, n, s, MS);
  Result := EncodeDateTime(Y, M, D, H, n, s, MS);
end;

function TGlobal.DateTimeToString(oDate: TDateTime): string;
begin
  Result := FormatDatetime('YYYY-MM-DD hh:nn:ss', oDate);
end;

function TGlobal.DateToDate(oDate: TDateTime): TDateTime;
var
  sDate: string;
  Y, M, D: Word;
begin
  sDate := DateToString(oDate);

  try
    Y := strtoint(Copy(sDate, 1, 4));
    M := strtoint(Copy(sDate, 6, 2));
    D := strtoint(Copy(sDate, 9, 2));

    Result := EncodeDate(Y, M, D);
  except
    Result := EncodeDate(0, 0, 0);
  end;
end;

function TGlobal.DateToString(oDate: TDateTime; nPos, nCount: integer): String;
var
  Year, Month, Day: Word;
begin
  DecodeDate(oDate, Year, Month, Day);

  Result := Copy(FillZero(Year, 4) + '-' + FillZero(Month, 2) + '-' + FillZero
      (Day, 2), nPos, nCount);
end;

function TGlobal.DateToTime(oDate: TDateTime): TTime;
var
  sTime: string;
  H, M, s: Word;
begin
  sTime := TimeToString(oDate);

  try
    H := strtoint(Copy(sTime, 1, 2));
    M := strtoint(Copy(sTime, 4, 2));
    s := strtoint(Copy(sTime, 7, 2));

    Result := EncodeTime(H, M, s, 0);
  except
    Result := EncodeTime(0, 0, 0, 0);
  end;
end;

function TGlobal.DateToString(oDate: TDateTime): string;
var
  Year, Month, Day: Word;
begin
  DecodeDate(oDate, Year, Month, Day);

  Result := FillZero(Year, 4) + '-' + FillZero(Month, 2) + '-' + FillZero
    (Day, 2);
end;

function TGlobal.StringToDate(sDate: string; var oD: TDateTime): Boolean;
var
  Y, M, D: Word;
begin
  if not isDateString(sDate) then
  begin
    Result := False;
    Exit;
  end;

  try
    Y := strtoint(Copy(sDate, 1, 4));
    M := strtoint(Copy(sDate, 6, 2));
    D := strtoint(Copy(sDate, 9, 2));

    oD := EncodeDate(Y, M, D);

    Result := true;
  except
    Result := False;
  end;
end;

function TGlobal.StringToTime(sTime: string; var oT: TTime): Boolean;
var
  H, M, s: Word;
begin
  if not isTimeString(sTime) then
  begin
    Result := False;
    Exit;
  end;

  try
    H := strtoint(Copy(sTime, 1, 2));
    M := strtoint(Copy(sTime, 4, 2));
    s := strtoint(Copy(sTime, 7, 2));

    oT := EncodeTime(H, M, s, 0);

    Result := true;
  except
    Result := False;
  end;
end;

function TGlobal.TimeToString(oTime: TTime): string;
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(oTime, Hour, Min, Sec, MSec);

  Result := FillZero(Hour, 2) + ':' + FillZero(Min, 2) + ':' + FillZero(Sec, 2);
end;

function TGlobal.TimeToStringHN(oTime: TTime): string;
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(oTime, Hour, Min, Sec, MSec);

  Result := FillZero(Hour, 2) + ':' + FillZero(Min, 2);
end;

function TGlobal.YesNo(sMsg: string): TModalResult;
var
  oYesNo: TfrmYesNo;
begin
  Application.CreateForm(TfrmYesNo, oYesNo);

  oYesNo.Msg := sMsg;
  Result := oYesNo.ShowModal;

  oYesNo.Free;
end;

{ TDBServerConfig }
procedure TDBServerConfig.Copy(oServer: TDBServerConfig);
begin
  DataSource := trim(oServer.DataSource);
  DBName := trim(oServer.DBName);
  UserID := trim(oServer.UserID);
  Password := trim(oServer.Password);
end;

{ TDateString }

procedure TDateString.SetDate(sDate: string);
begin
  Year := Copy(sDate, 1, 4);
  Month := Copy(sDate, 6, 2);
  Day := Copy(sDate, 9, 2);
end;

function TDateString.GetDay: integer;
begin
  Result := strtoint(Day);
end;

function TDateString.GetMonth: integer;
begin
  Result := strtoint(Month);
end;

function TDateString.GetYear: integer;
begin
  Result := strtoint(Year);
end;

{ TInputInfo }

procedure TInputInfo.Clear;
begin
  InputTitle := NULLString;
  InputField.Name := NULLString;
  InputField.Size := 0;
  Used := true;
end;

{ TPatientInfo }

procedure TPatientInfo.Clear;
begin
  nHospitalID := -1;
  sPatientID := NULLString;
  sPatientName := NULLString;
  sBirthday := NULLString;
  bMale := true;
end;

procedure TPatientInfo.Copy(Sor: TPatientInfo);
begin
  nHospitalID := Sor.nHospitalID;
  sPatientID := Sor.sPatientID;
  sPatientName := Sor.sPatientName;
  sBirthday := Sor.sBirthday;
  bMale := Sor.bMale;
end;

function TPatientInfo.isEmpty: Boolean;
begin
  Result := oGlobal.isNullStr(sPatientID);
end;

function TPatientInfo.isValidData: Boolean;
begin
  Result := (nHospitalID <> -1) and oGlobal.isNotNullStr(sPatientID)
    and oGlobal.isNotNullStr(sPatientName);
end;

{ TInOutInfo }

procedure TInOutInfo.Clear;
begin
  InOutID := -1;
  nHospitalID := -1;
  nIntypeID := -1;
  nBohumID := -1;
  sPatientID := NULLString;
  sInDate := NULLString;
  sInTime := NULLString;
  sOutDate := NULLString;
  sOutTime := NULLString;
  sRoom := NULLString;
  sDiagName := NULLString;
  sWardName := NULLString;
  sDoctorName := NULLString;
  sUserName := NULLString;
end;

procedure TInOutInfo.Copy(Sor: TInOutInfo);
begin
  InOutID := Sor.InOutID;
  nHospitalID := Sor.nHospitalID;
  nIntypeID := Sor.nIntypeID;
  nBohumID := Sor.nBohumID;
  sPatientID := Sor.sPatientID;
  sInDate := Sor.sInDate;
  sInTime := Sor.sInTime;
  sOutDate := Sor.sOutDate;
  sRoom := Sor.sRoom;
  sDiagName := Sor.sDiagName;
  sWardName := Sor.sWardName;
  sDoctorName := Sor.sDoctorName;
  sUserName := Sor.sUserName;
  bUsed := Sor.bUsed;
end;

function TInOutInfo.isEmpty: Boolean;
begin
  Result := oGlobal.isNullStr(sPatientID) or (InOutID = -1);
end;

function TInOutInfo.isValidData: Boolean;
begin
  Result := (nHospitalID <> -1) and oGlobal.isNotNullStr(sPatientID)
    and oGlobal.isDateString(sInDate) and oGlobal.isNotNullStr(sWardName);
end;

{ TNewPatientInfo }

constructor TNewPatientInfo.Create(nHID: integer; sPID: string);
begin
  oPatient.Clear;
  oPatient.nHospitalID := nHID;
  oPatient.sPatientID := sPID;

  oInOut.Clear;
  oInOut.nHospitalID := nHID;
  oInOut.sPatientID := sPID;
end;

{ TUserInfo }

procedure TUserInfo.Clear;
begin
  UserID := '';
end;

function TUserInfo.isEmpty: Boolean;
begin
  Result := oGlobal.isNullStr(UserID);
end;

{ TIntake }

procedure TIntake.Clear;
begin
  oPatient.Clear;
  oInOut.Clear;
  InfoDonor := NULLString;
  MeetingDate := NULLString;
  InMotivation := NULLString;
  MajorProblem := NULLString;
  InHistory := NULLString;
  PersonHistory := NULLString;
  WorkerOpinion := NULLString;
end;

{ TProgramInfo }

procedure TProgramInfo.Clear;
begin
  ProgramTypeID := -1;
  ProgramTypeName := '';
  Color := 0;
  HospitalID := -1;
  ProgramID := -1;
  ProgramName := '';
  WardID := -1;
  WardName := '';
  UseAll := true;
  Used := true;
end;

{ TShortInfo }

procedure TShortKeyInfo.Clear;
begin
  Keyword := '';
  Content := '';
end;

{ TRelationshipInfo }

procedure TRelationshipInfo.Clear;
begin
  FamilyName := '';
  Health := '';
  InMate := true;
  Pay := true;
  RelationshipID := -1;
  RelationshipName := '';
end;

{ TID }

function TID.ToString: string;
begin
  Result := inttostr(ID);
end;

function TGlobal.StringToDate(sDate: string): TDateTime;
var
  Y, M, D: Word;
begin
  if not isDateString(sDate) then
  begin
    Result := EncodeDate(0, 0, 0);
    Exit;
  end;

  try
    Y := strtoint(Copy(sDate, 1, 4));
    M := strtoint(Copy(sDate, 6, 2));
    D := strtoint(Copy(sDate, 9, 2));

    Result := EncodeDate(Y, M, D);
  except
    Result := EncodeDate(0, 0, 0);
  end;
end;

function TGlobal.StringToTime(sTime: string): TTime;
var
  H, M, s: Word;
begin
  if not isTimeString(sTime) then
  begin
    Result := EncodeTime(0, 0, 0, 0);
    Exit;
  end;

  try
    H := strtoint(Copy(sTime, 1, 2));
    M := strtoint(Copy(sTime, 4, 2));
    s := strtoint(Copy(sTime, 7, 2));

    Result := EncodeTime(H, M, s, 0);
  except
    Result := EncodeTime(0, 0, 0, 0);
  end;
end;

{ TDateInfo }

function TDateInfo.GetDay: integer;
begin
  result := DayOf(Date);
end;

function TDateInfo.GetDays: integer;
begin
  result := DaysInMonth(Date);
end;

function TDateInfo.GetFDate: string;
begin
  result := oGlobal.DateToString(FinishDate);
end;

function TDateInfo.GetFirstDay: TDateTime;
begin
  result := EncodeDate(Year, Month, 1);
end;

function TDateInfo.GetLastDay: TDateTime;
begin
  result := EncodeDate(Year, Month, Days);
end;

function TDateInfo.GetMonth: integer;
begin
  result := MonthOf(Date);
end;

function TDateInfo.GetSDate: string;
begin
  result := oGlobal.DateToString(StartDate);
end;

function TDateInfo.GetWeeks: integer;
begin
  result := WeekOftheMonth(EncodeDate(Year, Month, Days));
end;

function TDateInfo.GetYear: integer;
begin
  result := YearOf(Date);
end;

{ TFTPServerConfig }

procedure TFTPServerConfig.Copy(oFTPServer: TFTPServerConfig);
begin
  Host := oFTPServer.Host;
  UserName := oFTPServer.UserName;
  Password := oFTPServer.Password;
end;

initialization

oGlobal := TGlobal.Create;

finalization

oGlobal.Free;

end.

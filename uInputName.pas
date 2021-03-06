unit uInputName;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uGlobal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinCaramel,
  StdCtrls, cxTextEdit, Menus, cxButtons, cxCheckBox, ExtCtrls,
  dxSkinOffice2007Blue, cxMaskEdit, cxSpinEdit, dxSkinBlack, dxSkinBlue,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue;

type
  TfrmInputName = class(TForm)
    Panel1: TPanel;
    txtInput: TcxTextEdit;
    lblInputTitle: TLabel;
    chkUsed: TcxCheckBox;
    btnOK: TcxButton;
    btnClose: TcxButton;
    spinSeq: TcxSpinEdit;
    lblSeq: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure txtInputKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    oInput: TInputInfo;
  end;

var
  frmInputName: TfrmInputName;

implementation

{$R *.dfm}

procedure TfrmInputName.btnOKClick(Sender: TObject);
var
  sText: string;
begin
  if length(trim(txtInput.text)) = 0 then
  begin
    oGlobal.Msg('내용(' + oInput.InputTitle + ')을 입력하십시오!');
    txtInput.SetFocus;
    Exit;
  end;

  sText := trim(txtInput.text);

  if sText = '전체' then
  begin
    oGlobal.Msg('''전체''라는 단어는 사용할 수 없습니다!');
    Exit;
  end;

  if (pos('[', sText) > 0) or (pos(']', sText) > 0) or (pos(';', sText) > 0)
    then
  begin
    oGlobal.Msg('(''['','']'','';'') 문자들은 사용하실 수 없습니다!');
    Exit;
  end;

  if oGlobal.YesNo('적용하시겠습니까?') = mrYes then
  begin
    oInput.InputField.Name := sText;
    oInput.Used := chkUsed.Checked;
    oInput.Seq := spinSeq.Value;

    ModalResult := mrOK;
  end;
end;

procedure TfrmInputName.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    close;
end;

procedure TfrmInputName.FormShow(Sender: TObject);
begin
  lblInputTitle.Caption := oInput.InputTitle;
  txtInput.text := oInput.InputField.Name;
  txtInput.Properties.MaxLength := oInput.InputField.Size;
  chkUsed.Checked := oInput.Used;

  spinSeq.Visible := oInput.VisibleWardInfo;
  lblSeq.Visible := oInput.VisibleWardInfo;

  spinSeq.Value := oInput.Seq;

  txtInput.SetFocus;
  txtInput.SelStart := 0
end;

procedure TfrmInputName.txtInputKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and oGlobal.isNotNullStr(txtInput.Text) then
    btnOK.Click;
end;

end.

unit uMsg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus, StdCtrls,
  cxButtons, ExtCtrls, cxControls, cxContainer, cxEdit, dxSkinsCore,
  dxSkinCaramel, dxSkinOffice2007Blue;

type
  TfrmMsg = class(TForm)
    pnlMsg: TPanel;
    btnOK: TcxButton;
    Timer1: TTimer;
    lblLength: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FLabel: array of TLabel;
  public
    { Public declarations }
//    Msg: string;
    Msg: String;
    Interval: integer;
  end;

var
  frmMsg: TfrmMsg;

implementation

{$R *.dfm}

procedure TfrmMsg.FormDestroy(Sender: TObject);
var
  n: integer;
begin
  for n := Low(FLabel) to High(FLabel) do
    FLabel[n].Free;

  SetLength(FLabel, 0);
end;

procedure TfrmMsg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then close;
end;

procedure TfrmMsg.FormShow(Sender: TObject);
  function GetTextWidth(oText: TStringList): integer;
  var
    nLine: integer;
    nWidth: integer;
  begin
    nWidth := 0;
    for nLine := 0 to oText.Count - 1 do
      if self.Canvas.TextWidth(oText.Strings[nLine]) > nWidth then
        nWidth := self.Canvas.TextWidth(oText.Strings[nLine]);

    result := nWidth;
  end;
const
  nLineSpacing = 7;
var
  oS: TStringList;
  n, nWidth, nHeight: integer;
begin
  oS := TStringList.Create;

  oS.Text := Msg;

  SetLength(FLabel, oS.Count);

  nWidth := GetTextWidth(oS);
  Width := nWidth + 26 + 20 + 20;

  if Width < 250 then
  begin
    Width := 250;
    nWidth := Width - 26 - 20 - 20;
  end;

  nHeight := 0;
  for n := 0 to oS.Count - 1 do
  begin
    FLabel[n] := TLabel.Create(self);
    FLabel[n].Parent := pnlMsg;
    FLabel[n].Alignment := taCenter;
    FLabel[n].Layout := tlCenter;
    FLabel[n].AutoSize := False;
    FLabel[n].Left := 20;
    FLabel[n].Width := nWidth;
    FLabel[n].Height := self.Canvas.TextHeight('AAA') + nLineSpacing;
    FLabel[n].Top := 15 + n * FLabel[n].Height;
    FLabel[n].Caption := oS.Strings[n];
    nHeight := FLabel[n].Top + FLabel[n].Height;
  end;
  pnlMsg.Height := nHeight + 15;

  Height := pnlMsg.Height + 110;


  btnOK.Top := Height - 85 + 5;
  btnOK.Left := (ClientWidth - btnOK.Width) div 2;

  oS.Free;

  if Interval > 0 then
  begin
    Timer1.Interval := Interval;
    Timer1.Enabled := True;
  end;
end;

procedure TfrmMsg.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Close;
end;

end.

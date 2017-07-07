unit uYesNo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus, StdCtrls,
  cxButtons, ExtCtrls, cxControls, cxContainer, cxEdit, dxSkinsCore,
  dxSkinCaramel, cxLabel;

type
  TfrmYesNo = class(TForm)
    pnlMsg: TPanel;
    pnlButton: TPanel;
    btnYes: TcxButton;
    btnNo: TcxButton;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FLabel: array of TLabel;
    procedure SetControlSize;
  public
    { Public declarations }
    Msg: string;
  end;

var
  frmYesNo: TfrmYesNo;

implementation

{$R *.dfm}

procedure TfrmYesNo.FormDestroy(Sender: TObject);
var
  n: integer;
begin
  for n := Low(FLabel) to High(FLabel) do
    FLabel[n].Free;

  SetLength(FLabel, 0);
end;

procedure TfrmYesNo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    close;
end;

procedure TfrmYesNo.FormShow(Sender: TObject);
begin
  SetControlSize;
end;

procedure TfrmYesNo.SetControlSize;
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

  pnlButton.Top := Height - 85;
  pnlButton.Left := (ClientWidth - pnlButton.Width) div 2;

  oS.Free;
end;

end.

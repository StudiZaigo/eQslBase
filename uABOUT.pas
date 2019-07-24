unit uABOUT;

interface

uses WinApi.Windows, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TVerResourceKey = (
    vrComments,         // コメント
    vrCompanyName,      // 会社名
    vrFileDescription,  // 説明
    vrFileVersion,      // ファイルバージョン
    vrInternalName,     // 内部名
    vrLegalCopyright,   // 著作権
    vrLegalTrademarks,  // 商標
    vrOriginalFilename, // 正式ファイル名
    vrPrivateBuild,     // プライベートビルド情報
    vrProductName,      // 製品名
    vrProductVersion,   // 製品バージョン
    vrSpecialBuild);    // スペシャルビルド情報

function GetVersionInfo(ExeName: string; KeyWord: TVerResourceKey): string;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    lblProductName: TLabel;
    lblVersion: TLabel;
    lblCopyRight: TLabel;
    lblComment: TLabel;
    CompanyName: TLabel;
    lblCompanyName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

var
  AboutBox: TAboutBox;

const
    KeyWordStr: array [TVerResourceKey] of String = (
        'Comments',
        'CompanyName',
        'FileDescription',
        'FileVersion',
        'InternalName',
        'LegalCopyright',
        'LegalTrademarks',
        'OriginalFilename',
        'PrivateBuild',
        'ProductName',
        'ProductVersion',
        'SpecialBuild');

implementation

{$R *.dfm}

procedure TAboutBox.FormCreate(Sender: TObject);
var
  ExeName: string;
begin
  ExeName := Application.ExeName;
  lblProductName.Caption  :=  GetVersionInfo(ExeName, vrProductName);
  lblVersion.Caption      :=  GetVersionInfo(ExeName, vrFileVersion);
  lblCopyRight.Caption    :=  GetVersionInfo(ExeName, vrLegalCopyright);
  lblComment.Caption      :=  GetVersionInfo(ExeName, vrComments);
  lblCompanyName.Caption  :=  GetVersionInfo(ExeName, vrCompanyName);
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  close;
end;

// Windowsの特殊フォルダを取得
function GetVersionInfo(ExeName: string; KeyWord: TVerResourceKey): string;
const
  Translation = '\VarFileInfo\Translation';
  FileInfo    = '\StringFileInfo\%0.4s%0.4s\';
var
  BufSize, HWnd: DWORD;
  VerInfoBuf: Pointer;
  VerData: Pointer;
  VerDataLen: Longword;
  PathLocale: String;
begin
  // 必要なバッファのサイズを取得
  BufSize := GetFileVersionInfoSize(PChar(ExeName), HWnd);
  if BufSize <> 0 then
  begin
    // メモリを確保
    GetMem(VerInfoBuf, BufSize);
    try
      GetFileVersionInfo(PChar(ExeName), 0, BufSize, VerInfoBuf);
      // 変数情報ブロック内の変換テーブルを指定
      VerQueryValue(VerInfoBuf, PChar(Translation), VerData, VerDataLen);
      if not (VerDataLen > 0) then
        raise Exception.Create('情報の取得に失敗しました');
      PathLocale := Format(FileInfo + KeyWordStr[KeyWord],
        [IntToHex(Integer(VerData^) and $FFFF, 4),
         IntToHex((Integer(VerData^) shr 16) and $FFFF, 4)]);
      VerQueryValue(VerInfoBuf, PChar(PathLocale), VerData, VerDataLen);
      if VerDataLen > 0 then
      begin
        // VerDataはゼロで終わる文字列ではないことに注意
        result := '';
        SetLength(result, VerDataLen);
        StrLCopy(PChar(result), VerData, VerDataLen);
      end;
    finally
      // 解放
      FreeMem(VerInfoBuf);
    end;
  end;
end;

end.


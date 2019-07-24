unit Routines;

interface

uses
  System.SysUtils, Vcl.Forms, System.Types, System.IOUtils, Graphics,
  ShlObj;
//  SHLOBJ.DCU,Shlobj;

type
  TRGBStr =  packed record
    B, G, R: Byte;  //�o�C�g�̕��ѕ��� B > G > R �Ȃ̂�
  end;

  TRGBArray = array [0..65535] of TRGBStr;
  PRGBArray = ^TRGBArray;

type
  TAngle =(Angle90,Angle180,Angle270);
  //�����ɂ����ꂩ���w��B�����͉�]�p�x�B

var
  fWaitBreak: boolean;
  function ToDateTime(QsoDate, QsoTime: string): TDateTime;
  function WaitTime(const t: integer): Boolean;
  function FileNameExists(Path, Filename: string): TStringDynArray;
  function GetSpecialFolderPath(Folder: Integer; CanCreate: Boolean): string;
  function GetMyPicturesFolderPath(): string;
  function GetMyDocumentsFolderPath(): string;

implementation


function ToDateTime(QsoDate, QsoTime: string): TDateTime;
begin
  Result := 0;
  if Length(QsoDate) <> 8 then exit;
  if Length(QsoTime) <> 4 then exit;
  Result := StrToDateTime(Copy(QsoDate,1,4)+'/'+Copy(QsoDate,5,2)+'/'+Copy(QsoDate,7,2)
          + ' ' + Copy(QsoTime,1,2)+':'+ Copy(QsoTime,3,2) + ':00')
end;

// �҂��֐�  �w��J�E���g���o�߂���� True, ���f���ꂽ�Ȃ�� False
// t�̓~���b
function WaitTime(const t: integer): Boolean;
var
  Timeout: TDateTime;
begin
  fWaitBreak  := False;                 // �t���O�̏�����
  Timeout     := Now + t/24/3600/1000;  // �I������

  while (Now < Timeout) and not fWaitBreak do
    begin
    Application.ProcessMessages;
    Sleep(10);                //���x�� 10ms �ȉ��ŗǂ��ꍇ
    end;
  Result := not fWaitBreak;
end;

function FileNameExists(Path, Filename: string): TStringDynArray;
var
  SearchPattern: string;
  Option: TSearchOption;
//  i: integer;
//  FileNames: TStringDynArray;
begin

  SearchPattern := ExtractFileName(ChangeFileExt(FileName, '.*'));  // �t�@�C�����Ɉ�v���錟���p�^�[��
  Option    := TSearchOption.soTopDirectoryOnly;                    // �g�b�v���x���񋓃��[�h
  result    := TDirectory.GetFiles(Path, SearchPattern, Option);    //�w��̃f�B���N�g�����̃t�@�C���̃��X�g
//  i := length(FileNames);
//  if i > 0 then
//    result  :=  true;
end;

function GetSpecialFolderPath(Folder: Integer; CanCreate: Boolean): string;
 var
  Buff : array [0..255] of Char;
  iRet : HRESULT;
//  ADir : String;
begin
  FillChar(Buff, SizeOf(Buff), #0);

//  iRet := SHGetFolderPath(0, CSIDL_PROGRAM_FILES, 0, SHGFP_TYPE_CURRENT, @Buff);
//  iRet := SHGetFolderPath(0, Folder, 0, SHGFP_TYPE_CURRENT, @Buff);
  iRet := SHGetFolderPath(0, CSIDL_MYPICTURES, 0, SHGFP_TYPE_CURRENT, @Buff);
  if iRet = S_OK then begin
    result := Buff;
  end;
end;

function GetMyPicturesFolderPath(): string;
begin
  result := GetSpecialFolderPath(CSIDL_MYPICTURES, false);
end;

function GetMyDocumentsFolderPath(): string;
begin
  result := GetSpecialFolderPath(CSIDL_MYDOCUMENTS, false);
end;

end.



program eQslBase;

uses
  Windows,
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uABOUT in 'uABOUT.pas' {AboutBox},
  uLogin in 'uLogin.pas' {frmLogin};

const
  UniqueName = 'MutexEQslBase';

var
  hMutex: THandle;

{$R *.res}

begin
  {アプリケーション二重起動防止}
  Application.MainFormOnTaskbar := false;
  hMutex := CreateMutex(nil, False, UniqueName);
  if WaitForSingleObject(hMutex, 0) = wait_TimeOut then
    exit;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.





unit uLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmLogin = class(TForm)
    edtUsername: TLabeledEdit;
    edtPassword: TLabeledEdit;
    btnLogin: TButton;
    btnCancel: TButton;
    cbxAutoLogin: TCheckBox;
    procedure edtUsernameExit(Sender: TObject);
    procedure edtPasswordExit(Sender: TObject);
  private
    FAutoLogin: boolean;
    FPassword: string;
    FUsername: string;
    procedure SetAutoLogin(const Value: boolean);
    procedure SetPassword(const Value: string);
    procedure SetUsername(const Value: string);
    { Private êÈåæ }
  public
    { Public êÈåæ }
    property UserName: string read FUsername write SetUsername;
    property Password: string read FPassword write SetPassword;
    property AutoLogin: boolean read FAutoLogin write SetAutoLogin;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

{ TForm1 }

procedure TfrmLogin.edtPasswordExit(Sender: TObject);
begin
  FPassword := trim(edtPassword.text);
end;

procedure TfrmLogin.edtUsernameExit(Sender: TObject);
begin
  FUsername := trim(edtUserName.text);
end;

procedure TfrmLogin.SetAutoLogin(const Value: boolean);
begin
  FAutoLogin := Value;
end;

procedure TfrmLogin.SetPassword(const Value: string);
begin
  FPassword := Value;
  edtPassword.Text  := FPassword;
end;

procedure TfrmLogin.SetUsername(const Value: string);
begin
  FUsername := Value;
  edtUserName.Text  := FUserName;
end;

end.

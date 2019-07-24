unit uSqlMoniorMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IBSQLMonitor, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    IBSQLMonitor1: TIBSQLMonitor;
    Panel1: TPanel;
    Button1: TButton;
    procedure IBSQLMonitor1SQL(EventText: string; EventTime: TDateTime);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TForm2.IBSQLMonitor1SQL(EventText: string; EventTime: TDateTime);
begin
  Memo1.Lines.Add(EventText);
end;

end.

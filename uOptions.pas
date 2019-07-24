unit uOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  types, Vcl.FileCtrl,
  XmlIniFile;

const
  c_TimeZone: string = 'UTC=0,JST=9';
  c_Validity: string = '"10 minutes=10","30 minutes=30","1 hour=60","3 hours=180",'
     + '"6 hours=360","12 hours=720","24 hours=1440"';
type
  TfrmOptions = class(TForm)
    btnCancel1: TButton;
    btnCancel2: TButton;
    btnDataPath: TButton;
    btnImgPath: TButton;
    btnLeft: TButton;
    btnOK1: TButton;
    btnOk2: TButton;
    btnRight: TButton;
    btnVisibleItemDown: TButton;
    btnVisibleItemUp: TButton;
    cmbApplication: TComboBox;
    cmbTimeZone: TComboBox;
    cmbValidity: TComboBox;
    edtDataPath: TLabeledEdit;
    edtImgPath: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    PageControl1: TPageControl;
    lstNoneVisibleItems: TListBox;
    lstVisibleItems: TListBox;
    tabDBGrid: TTabSheet;
    tabSystem: TTabSheet;

    procedure btnDataPathClick(Sender: TObject);
    procedure btnImgPathClick(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure btnVisibleItemDownClick(Sender: TObject);
    procedure btnVisibleItemUpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private 宣言 }
    XmlIni: TXmlIniFile;
    TimeZoneList: TStringList;
    ValidityList: TStringList;

    procedure ListBoxUpDown(Sender: TObject; UpDown: Integer);
    procedure LoadXmlIni;
    procedure SaveXMLIni;
  public
    { Public 宣言 }
  end;

var
  frmOptions: TfrmOptions;

implementation

uses uMain, Routines;

{$R *.dfm}

procedure TfrmOptions.btnDataPathClick(Sender: TObject);
var
  RootFolder   : String;
  SelectFolder : String;
begin
 RootFolder   := '';
// SelectFolder := '';
 SelectFolder := edtDataPath.text;

 {$IF CompilerVersion > 18.49}
 if SelectDirectory('Database folder',
                    RootFolder,
                    SelectFolder,
                    [sdNewUI, sdNewFolder, sdShowEdit],
                    Self) then begin
   MessageBox(Handle, PChar(SelectFolder), '選択フォルダ', MB_ICONINFORMATION);
 end;
 {$ELSE}
 MessageBox(Handle, '利用できません', '使用不可', MB_ICONWARNING);
 {$IFEND}
end;

procedure TfrmOptions.btnImgPathClick(Sender: TObject);
var
  RootFolder   : String;
  SelectFolder : String;
begin
 RootFolder   := '';
// SelectFolder := '';
 SelectFolder := edtIMGPath.text;

 {$IF CompilerVersion > 18.49}
 if SelectDirectory('Image file folder',
                    RootFolder,
                    SelectFolder,
                    [sdNewUI, sdNewFolder, sdShowEdit],
                    Self) then begin
   MessageBox(Handle, PChar(SelectFolder), '選択フォルダ', MB_ICONINFORMATION);
 end;
 {$ELSE}
 MessageBox(Handle, '利用できません', '使用不可', MB_ICONWARNING);
 {$IFEND}
end;

procedure TfrmOptions.btnLeftClick(Sender: TObject);
var
  n1: integer;
begin
  n1 := lstNoneVisibleItems.ItemIndex;
  lstVisibleItems.Items.add(lstNoneVisibleItems.Items[n1]);
  lstNoneVisibleItems.Items.Delete(n1);
end;

procedure TfrmOptions.btnRightClick(Sender: TObject);
var
  n1: integer;
begin
  n1 := lstVisibleItems.ItemIndex;
  lstNoneVisibleItems.Items.add(lstVisibleItems.Items[n1]);
  lstVisibleItems.Items.Delete(n1);
end;

procedure TfrmOptions.btnVisibleItemDownClick(Sender: TObject);
begin
  ListBoxUpDown(lstVisibleItems, 1);
end;

procedure TfrmOptions.btnVisibleItemUpClick(Sender: TObject);
begin
  ListBoxUpDown(lstVisibleItems, -1);
end;

procedure TfrmOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    SaveXMLIni;
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  LoadXmlIni;
end;

procedure TfrmOptions.ListBoxUpDown(Sender: TObject; UpDown: Integer);
var
  Max: integer;
  n,m: integer;
begin
  Max := TListBox(Sender).Count - 1;
  n := TListBox(Sender).ItemIndex;
  m := n + UpDown;
  if (0 <= m ) and (m <= Max) then
    TListBox(Sender).Items.Exchange(n, m);
end;

procedure TfrmOptions.LoadXmlIni;
var
  i: integer;
begin
  XmlIni := TXmlIniFile.Create(frmMain.XMLIniName);
  TimeZoneList := TStringList.Create;
  ValidityList := TStringList.Create;
  try
    TimeZoneList.CommaText := c_TimeZone;
    cmbTimeZone.Items.Clear;
    for i := 0 to TimeZoneList.Count - 1 do
      cmbTimeZone.Items.Add(TimeZoneList.Names[i]);

    ValidityList.CommaText := c_Validity;
    cmbValidity.Items.Clear;
    for i := 0 to ValidityList.Count - 1 do
      cmbValidity.Items.Add(ValidityList.Names[i]);

    XmlIni.OpenNode('/Application', true);
    cmbApplication.Text := XmlIni.ReadString('Application', cmbApplication.Items[0]);
    edtDataPath.Text  := XmlIni.ReadString('DataPath', '');
    edtImgPath.Text   := XmlIni.ReadString('ImgPath', '');
    cmbTimeZone.Text  := XmlIni.ReadString('TimeZone', TimeZoneList.Names[0]);
    cmbValidity.Text  := XmlIni.ReadString('Validity', ValidityList.ValueFromIndex[0]);

    if edtDataPath.Text = '' then
      begin
      edtDataPath.Text := ExtractFilePath(Application.ExeName);
      end;
    if edtImgPath.Text = '' then
      begin
      edtImgPath.Text := GetMyPicturesFolderPath + '\eQSL\';
      end;

    lstVisibleItems.Items.Clear;
    lstNoneVisibleItems.Items.Clear;
    for i := 0 to frmMain.DBGrid1.Columns.Count - 1 do
      if frmMain.DBGrid1.Columns[i].Visible then
        lstVisibleItems.Items.Add(frmMain.DBGrid1.Columns[i].FieldName);
    for I := 0 to frmMain.qryEQsl.Fields.Count -1 do
      if lstVisibleItems.Items.IndexOf(frmMain.qryEQsl.Fields[i].FieldName) < 0 then
        lstNoneVisibleItems.Items.Add(frmMain.qryEQsl.Fields[i].FieldName);
  finally
    FreeAndNil(XmlIni);
  end;
end;

procedure TfrmOptions.SaveXMLIni;
var
  i: integer;
begin
  XmlIni := TXmlIniFile.Create(frmMain.XMLIniName);
  try
    cmbTimeZone.Items.Clear;
    cmbValidity.Items.Clear;

    XmlIni.OpenNode('/Application', true);
    XmlIni.WriteString('Application', cmbApplication.Text);
    XmlIni.WriteString('DataPath', edtDataPath.Text);
    XmlIni.WriteString('ImgPath', edtImgPath.Text);
    XmlIni.WriteString('TimeZone', cmbTimeZone.Text);
    XmlIni.WriteInteger('TimeZoneV', StrToInt(TimeZoneList.Values[cmbTimeZone.Text]));
    XmlIni.WriteString('Validity', cmbValidity.Text);
    XmlIni.WriteInteger('ValidityV', StrToInt(ValidityList.Values[cmbValidity.Text]));
    XmlIni.CloseNode;
    XmlIni.UpdateFile;

    XmlIni.OpenNode('/DBGrid/' , true);
    XmlIni.WriteString('Order', lstVisibleItems.Items.CommaText);
    for i := 0 to lstVisibleItems.Items.Count - 1 do
      if  XmlIni.OpenNode('/DBGrid/Style/' + lstVisibleItems.Items[i] + '/', false) then
        begin
        XmlIni.WriteBool('Visible', true);
        XmlIni.CloseNode;
        end;
    for i := 0 to lstNoneVisibleItems.Items.Count - 1 do
      if  XmlIni.OpenNode('/DBGrid/Style/' + lstNoneVisibleItems.Items[i] + '/', false) then
        begin
        XmlIni.WriteBool('Visible', false);
        XmlIni.CloseNode;
        end;
    XmlIni.UpdateFile;
  finally
    FreeAndNil(XmlIni);
    FreeAndNil(TimeZoneList);
    FreeAndNil(ValidityList)
  end;
end;

procedure TfrmOptions.ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  n1,n2: integer;
begin
  if (Sender is TListBox) and (Source is TListBox) then
    begin
    n1 := TListBox(Source).ItemIndex;
    n2 := TlistBox(Sender).ItemAtPos(Point(X, Y), True);
    if TListBox(Sender).Name = TListBox(Source).Name then
      TListBox(Sender).Items.Move(n1, n2)
    else
      begin
      TListBox(Sender).Items.Insert(n2,TListBox(Source).Items[n1]);
      TListBox(Source).Items.Delete(n1);
      end
    end;
end;

end.

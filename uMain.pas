unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, System.Actions, SYSTEM.UItypes, Types,
  StrUtils,
  Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,

  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  Data.DB, Datasnap.DBClient, Datasnap.Provider, IBCustomDataSet,
  IBTable, IBDatabase, IBQuery, IBUpdateSQL, IBSQLMonitor, IBSQL,

  Printers,  JPeg, PNGImage,  GDIPAPI, GDIPOBJ,

  IdHTTP, HTTPApp, ComCtrls, UrlMon,
  XmlIniFile,  SkRegExpW,
  Routines, Vcl.Menus;

type TCallsignRec = record
  Callsign:       string;
  OrgCallsign:    string;
  Prefix:         string;
  Suffix:         string;
  Area:           string;
  result:         boolean;
  end;

type TQsoLogRec = record
  Num:            Integer;
  QslRecv:        string;
  QslRecvDate:    TDateTime;
  NetLogRecv:     string;
  GridLoc:        string;
  end;

type TArchived = (acInbox, acArchived, acAll);

type
  TfrmMain = class(TForm)
    About1: TMenuItem;
    actAbout: TAction;
    actArchive: TAction;
    actExit: TAction;
    ActionManager1: TActionManager;
    actLogin_out: TAction;
    actMarking: TAction;
    actOptions: TAction;
    actPrint: TAction;
    btnDownload: TButton;
    btnExit: TButton;
    btnFile: TButton;
    btnLogin: TButton;
    btnMarking: TButton;
    btnPrint: TButton;
    cmbSelect: TComboBox;
    dbEQSLBase: TIBDatabase;
    DBGrid1: TDBGrid;
    dbLogBase: TIBDatabase;
    DBNavigator1: TDBNavigator;
    dsEQSL: TDataSource;
    edtRecordNo: TLabeledEdit;
    IdHTTP1: TIdHTTP;
    Memo1: TMemo;
    Options1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PopupMenu1: TPopupMenu;
    PrintDialog1: TPrintDialog;
    qryEQsl: TIBQuery;
    qryEQslBAND: TLargeintField;
    qryEQslBAND_M: TIBStringField;
    qryEQslCALLSIGN: TIBStringField;
    qryEQslDATAKEY: TIBStringField;
    qryEQslArchived: TSmallintField;
    qryEQslGRIDLOC: TIBStringField;
    qryEQslISMARK: TSmallintField;
    qryEQslISNEW: TSmallintField;
    qryEQslMATCH: TSmallintField;
    qryEQslMODE: TIBStringField;
    qryEQslNEWJCA: TSmallintField;
    qryEQslNEWSTATION: TSmallintField;
    qryEQslNUM: TLargeintField;
    qryEQslONDATETIME: TDateTimeField;
    qryEQslPRINTED: TSmallintField;
    qryEQslQSLMSG: TIBStringField;
    qryEQslSUFFIX: TIBStringField;
    qryEQslDOWNLOADDATE: TDateTimeField;
    qryEQslMYCALLSIGN: TWideStringField;
    sqlSelectEQsl: TIBQuery;
    sqlQsoLogMatch1: TIBQuery;
    sqlQsoLogNewStation: TIBQuery;
    sqlQsoLogNewJCA: TIBQuery;
    StatusBar1: TStatusBar;
    trnEQSLBase: TIBTransaction;
    trnLogBase: TIBTransaction;
    updEQsl: TIBUpdateSQL;
    actAllCleare: TAction;
    AllCleare1: TMenuItem;
    N1: TMenuItem;
    actDownload: TAction;
    actExport: TAction;
    SaveDialog1: TSaveDialog;
    qryEQslORGCALLSIGN: TIBStringField;
    sqlQsoLogMatch2: TIBQuery;
    btnExport: TButton;
    updQsoLog: TIBSQL;
    cbxShowAllData: TCheckBox;
    sqlQsoLogMatch3: TIBQuery;

    procedure actAboutExecute(Sender: TObject);
    procedure actArchiveExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actLogin_outExecute(Sender: TObject);
    procedure actMarkingExecute(Sender: TObject);
    procedure actOptionsExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure actStoreExecute(Sender: TObject);
    procedure cdsEQslAfterScroll(DataSet: TDataSet);
    procedure cdsEQslBANDGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsEQslONDATETIMEGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure qryEQslUpdateRecord(DataSet: TDataSet; UpdateKind: TUpdateKind; var UpdateAction: TIBUpdateAction);
    procedure actAllCleareExecute(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure cbxShowAllDataClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    procedure actDownloadExecute(Sender: TObject);

  private
    { Private 宣言 }
    FS: TFormatSettings;
    isLogin: boolean;
    isDebug: boolean;
    AdifFileName: string;
    XMLIni: TXmlIniFile;

    FAppName: string;
    FAppPath: string;
    FAutoLogin: boolean;
    FDataBasePath: string;
    FImageFilePath: string;
    FImgFilePath: string;
    FLoggingApp: string;
    FPassword: string;
    FTimeZone: integer;
    FTimeZoneD: double;
    FUserName: string;
    FXMLUserPath: string;
    FValidity: integer;
    FValidityD: double;
    FXMLIniName: string;

    TestLog: TstringList;

    function AdifToDataSet(InString: string; Ds: TIBQuery): boolean;
    function CheckCallsign(vCallsign: string; var CallsignRec: TCallsignRec): boolean;
    function CheckDupKey(MainKey: string): Integer;
    function DownloadImageFile(Callsign: string; OnDateTime: TDateTime; Band, Mode: string; SavePath: string): boolean;
    function GetADIF(FileName: string): boolean;
    function GetDownloadFileName(InBox: TArchived; RecvdSince: double  = 0): string;
    function GetImageFiles: boolean;
    function Login(Auto: boolean): boolean;
    function Logout: boolean;
    function MakeFolder(Callsign: string): string;
    function PrintImag(ImageFileName: string): boolean;
    procedure GetBandList(FromBand, ToBand: string; var BandList: TStringList);
    procedure LoadXmlIni;
    procedure makeMarking;
    procedure MarkingIsNew;
    procedure MatchAndUpdateQsoLog;
    procedure PrintQslcard;
    procedure SaveXmlIni;
    procedure SetAppName(const Value: string);
    procedure SetAppPath(const Value: string);
    procedure SetAutoLogin(const Value: boolean);
    procedure SetDataBasePath(const Value: string);
    procedure SetImageFilePath(const Value: string);
    procedure SetImgFilePath(const Value: string);
    procedure SetLoggingApp(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetPrinter;
    procedure SetTimeZone(const Value: integer);
    procedure SetTimeZoneD(const Value: double);
    procedure SetUserName(const Value: string);
    procedure SetValidity(const Value: integer);
    procedure SetValidityD(const Value: double);
    procedure SetXMLIniName(const Value: string);
    procedure ShowAbout;
    procedure SetButttons;

    function EQsl_Open(): boolean;
    function QsoLog_Update(Num: integer; Callsign: string; GridLoc: string): boolean;
    function QsoLog_Find(var QsoLogRec: TQsoLogRec): boolean;
    function QsoLog_FindNewStation: boolean;
    function QsoLog_FindNewJCA: boolean;
    function QsoLog_FindNum(Num: integer; Callsign: string; var QsoLogRec: TQsoLogRec): boolean;
//    function QsoLog_FindNum(Num: integer; Callsign: string; var QsoLogRec: TQsoLogRec): boolean;
//    function HavePrintedQSL(Num: integer; Callsign: string): boolean;
    function DownloadInbox: boolean;
    procedure SetXMLUserPath(const Value: string);


  public
    { Public 宣言 }
    property AppName:   string read FAppName write SetAppName;
    property AppPath:   string read FAppPath write SetAppPath;
    property AutoLogin: boolean read FAutoLogin write SetAutoLogin;
    property DataBasePath:  string Read FDataBasePath write SetDataBasePath;
    property ImageFilePath: string read FImageFilePath write SetImageFilePath;
    property ImgFilePath:   string read FImgFilePath write SetImgFilePath;
    property LoggingApp:    string read FLoggingApp write SetLoggingApp;
    property Password:  string read FPassword write SetPassword;
    property TimeZone:      integer read FTimeZone write SetTimeZone;
    property TimeZoneD:     double read FTimeZoneD write SetTimeZoneD;
    property UserName:  string read FUserName write SetUserName;
    property XMLUserPath:   string read FXMLUserPath write SetXMLUserPath;
    property Validity:      integer read FValidity write SetValidity;
    property ValidityD:     double read FValidityD write SetValidityD;
    property XMLIniName:    string read FXMLIniName write SetXMLIniName;
  end;

const
  c_eQsl        = 'eQSL';
  c_eQslUrl     = 'http://eqsl.cc/';
  c_DownloadUrl = 'qslcard/DownloadInBox.cfm?';
  c_QslcardUrl  = 'QSLCard/';
  c_AdifHeader  = 'DIF 3 Export from eQSL.cc';
var
  frmMain: TfrmMain;

implementation

uses uABOUT, uLogin, UOptions;

{$R *.dfm}

procedure TfrmMain.actAboutExecute(Sender: TObject);
begin
  ShowAbout;
end;

procedure TfrmMain.actArchiveExecute(Sender: TObject);
begin
  if qryEQsl.UpdatesPending then
    qryEQsl.ApplyUpdates();

  GetImageFiles();
end;

procedure TfrmMain.actDownloadExecute(Sender: TObject);
begin
    if DownloadInbox then
      begin
      MatchAndUpdateQsoLog;
      end;
    SetButttons;
end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actAllCleareExecute(Sender: TObject);
var
  qry: TIBsql;
  s : string;
begin
  qry := TIBsql.Create(Self);
  try
    qry.Database := dbeQSLBase;
    s := 'DELETE FROM EQSL;';
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add(s);
    qry.ExecQuery;
    trnEQSLBase.Commit;
  finally
    FreeAndNil(qry);
  end;
end;

procedure TfrmMain.actExportExecute(Sender: TObject);
var
  RawOutput: TIBOutputDelimitedFile;
  XmlIni: TXmlIniFile;
  ExportPath: string;
begin
  XmlIni    :=  TXmlIniFIle.Create(FXmlIniName);
  RawOutput :=  TIBOutputDelimitedFile.Create;
  try
    XmlIni.OpenNode('/Application', true);
    ExportPath  := XmlIni.ReadString('ExportPath', GetMyDocumentsFolderPath);
    with SaveDialog1 do
      begin
      Title :=  'eQSL data export';
      Filter  := 'CSV Files (*.csv)|*.csv|All Files (*.*)|*.*';
      InitialDir  := ExportPath;
      DefaultExt  := 'csv';
      if not Execute then
        exit;
      end;
    ExportPath :=  ExtractFilePath(SaveDialog1.FileName);
    XmlIni.WriteString('ExportPath', ExportPath);
    XmlIni.CloseNode;
    XmlIni.UpdateFile;

    RawOutput.ColDelimiter  := ',';
    RawOutput.RowDelimiter  := #13#10;
    RawOutput.OutputTitles  := true;
    RawOutput.Filename      := SaveDialog1.FileName;
//  SQL文にParamsがあるとBatchOutputが正しく動作しない
    qryEQsl.BatchOutput(RawOutput);
  finally
    FreeAndNil(RawOutput);
    FreeAndNil(XmlIni);
  end;
end;

procedure TfrmMain.actLogin_outExecute(Sender: TObject);
begin
  if isLogin then
    begin
    if Logout()  then
      begin
      btnLogin.Caption  := 'Login';
      end
    end
  else
    begin
    if Login(false)  then
      begin
      btnLogin.Caption  := 'Logoff';
      end;
    end;
  SetButttons;
end;

procedure TfrmMain.actMarkingExecute(Sender: TObject);
begin
  makeMarking;
end;

procedure TfrmMain.actOptionsExecute(Sender: TObject);
var
  frmOptions: TfrmOptions;
begin
  frmOptions  :=  TfrmOptions.Create(self);
  try
    if frmOptions.ShowModal = mrOk then
      LoadXmlIni;
  finally
    freeAndNil(frmOptions);
  end;
end;

procedure TfrmMain.actPrintExecute(Sender: TObject);
begin
  if qryEQsl.UpdatesPending then
    qryEQsl.ApplyUpdates();
  PrintQslCard;
end;

procedure TfrmMain.actStoreExecute(Sender: TObject);
begin
  if qryEQsl.UpdatesPending then
    qryEQsl.ApplyUpdates();

  GetImageFiles();
end;

procedure TfrmMain.SetPrinter;
var
  DrvName, PrtName, PortName: array[0..127] of Char;
  DeviceMode: Thandle;
  PDevMode: ^TDevMode;
begin
  try
    with Printer do
      begin
       PrinterIndex := -1;
       GetPrinter(DrvName, PrtName, PortName, DeviceMode);
       PDevMode := GlobalLock(DeviceMode);
       PDeVMode^.dmDefaultSource  := DMBIN_UPPER;
       PDeVMode^.dmPaperSize      := DMPAPER_JAPANESE_POSTCARD;
       PdevMode^.dmOrientation    := DMORIENT_LANDSCAPE;
       GlobalUnlock(DeviceMode);
       SetPrinter(DrvName, PrtName, PortName, DeviceMode);
      end;
  finally

  end;
end;

procedure TfrmMain.SetTimeZone(const Value: integer);
begin
  FTimeZone := Value;
  FTimeZoneD  := FTimeZone / 24;
end;

procedure TfrmMain.SetTimeZoneD(const Value: double);
begin
  FTimeZoneD := Value;
end;

procedure TfrmMain.PrintQslcard;
var
  qry: TIBQuery;
  s : string;
  FolderName: string;
  ImgFileName: string;
  FileNames: TStringDynArray;
  isPrintNew: boolean;
begin
  qryEQsl.DisableControls;

  qry := TIBQuery.Create(Self);
  Screen.Cursor := crHourGlass;
  try
    if cbxShowAllData.Checked then
      s := 'SELECT * FROM EQSL WHERE ISMARK=1 ORDER BY DATAKEY;'
    else
      s := 'SELECT * FROM EQSL WHERE ISMARK=1 AND ISNEW=1 ORDER BY DATAKEY;';
    qry.Database := dbeQslBase;
    qry.Sql.Clear;
    qry.SQL.Add(s);
    qry.Open;
    qry.Last;
    qry.First;
    if qry.RecordCount = 0 then
      exit;

//    qryEQsl.Open;
//    qryEQsl.Last;
//    qryEQsl.First;
//    if qryEQsl.RecordCount = 0 then
//      exit;

    SetPrinter;
    with PrintDialog1 do
      begin
      if not PrintDialog1.Execute() then Exit;
        if (PrintRange = prAllPages) or (PrintRange = prSelection) then   // OptionsでprAllPages以外を選択できないように設定してある
          begin
          end
        else  { PrintRange = prPageNums }
          begin
          end;
      end;
    Printer.Title := 'eQSL_' + FormatDateTime('yyyymmddhhnn', now);

    isPrintNew  := true;;
    while not qry.EOF do
      begin
      Statusbar1.SimpleText := 'Image print ' +
            InttoStr(qry.RecNo) + '/' + IntToStr(qry.RecordCount);
      FolderName    := MakeFolder(qry.FieldByName('Callsign').AsString);
      ImgFileName   := FolderName + '\' + StringReplace(qry.FieldByName('DataKey').AsString, '/', '-', [rfReplaceAll]) + '.*';
      FileNames :=  FileNameExists(FolderName, ImgFileName);
      if Length(FileNames) > 0 then
        begin
        ImgFileName := filenames[0];
        if isPrintNew then
          begin
          Printer.BeginDoc;
          isPrintNew := false;
          end
        else
          Printer.NewPage;
        if PrintImag(ImgFileName) then
          begin
          if qryEQsl.Locate('DATAKEY', VarArrayOf([qry.FieldByName('DataKey').AsString]), [loCaseInsensitive]) then
            begin
            qryEqsl.Edit;
            qryEQsl.FieldByName('PRINTED').AsInteger  :=  integer(true);
            qryEQsl.FieldByName('ISMARK').AsInteger   :=  integer(false);
            qryEQSL.Post;
            qryEQSL.ApplyUpdates;
            end;
          end;
        end;
      qry.next;
      end;
    Printer.EndDoc;
  finally
    FreeAndNil(qry);
    Screen.Cursor := crDefault;
    qryEQsl.EnableControls;
  end;
end;

function TfrmMain.PrintImag(ImageFileName: string): boolean;
var
  bmp : TBitmap;
  Jpg :TJpegImage;
  Png: TPNGImage;
  ext: string;
  Arect: tRect;
begin
  result := false;
  Bmp   := TBitmap.Create;
  Jpg   := TJpegImage.Create;
  Png   := TPNGImage.Create;

  try
    if not FileExists(ImageFileName) then
      begin
      ShowMessage(ImageFileName + 'が見つかりません');
      exit;
      end;
      ext := ExtractFileExt(ImageFileName);
      ext := Uppercase(ext);
      if ext = '.JPG' then
        begin
        Jpg.LoadFromFile(ImageFileName);
        bmp.Assign(Jpg);
        end
      else if ext = '.PNG' then
        begin
        Png.LoadFromFile(ImageFileName);
        bmp.Assign(Png);
        end
      else
        begin
        ShowMessage(ImageFileName + 'はイメージ型式でありません');
        exit;
      end;

      with Printer do
        begin
        ARect.Left   := 0;                    //  印刷位置の左端
        ARect.Top    := 0;                    //  印刷位置の上端
        Arect.Right := Trunc(( PageWidth / bmp.Width) * bmp.Width);
        Arect.Bottom := Trunc(( PageHeight / bmp.Height) * bmp.Height);
        Canvas.StretchDraw(Arect, bmp);
        result := true;
        end;
  finally
    FreeAndNil(Bmp);
    FreeAndNil(JPG);
    FreeAndNil(PNG);
  end;
end;

procedure TfrmMain.cbxShowAllDataClick(Sender: TObject);
var
  s: string;
begin
//  SQL分にParamasがあるとBatchOutputが正しく動作しないのでFormat文で処理した
  if cbxShowAllData.Checked then
    s := 'SELECT * FROM EQSL WHERE MYCALLSIGN=''%s'' ORDER BY DATAKEY ;'
  else
    s := 'SELECT * FROM EQSL WHERE MYCALLSIGN=''%s'' AND ISNEW = 1 ORDER BY DATAKEY ;';
  s := format(s, [UserName]);
  qryEQsl.Close;
  qryEQsl.SQL.Clear;
  qryEQsl.SQL.Add(s);
  EQsl_Open;
end;

procedure TfrmMain.cdsEQslAfterScroll(DataSet: TDataSet);
begin
  edtRecordNo.Text  := IntToStr(qryEQsl.RecNo) + '/' + IntToStr(qryEQsl.RecordCount);
end;

procedure TfrmMain.cdsEQslBANDGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text  :=  FormatFloat('#0.000;;#', TLargeIntField(Sender).Value / 1000000);
end;

procedure TfrmMain.cdsEQslONDATETIMEGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text  :=  FormatDateTime('yyyy/mm/dd hh:nn', TDateTimeField(Sender).Value + FTimeZoneD);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveXmlIni;

  dbLogBase.Close;
  qryEQsl.Close;

  if isLogin then
    Logout;

  TestLog.SaveToFile('C:\LogBase Projects\eQslBase V1.00\TestLog.txt');
  TestLog.Free;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  XmlIni: TXMLIniFile;
  i: integer;
  s: string;
begin
  isDebug := false;
  TestLog := TstringList.Create;

  FS.DateSeparator := '-';

  s := ExtractFileName(Application.ExeName);         // .EXEを除くため
  i := Pos(ExtractFileExt(Application.ExeName), s);
  AppName := Copy(s, 1, i - 1);
  AppPath := ExtractFilePath(Application.ExeName);

  ADIFFileName  := ChangeFileExt(Application.ExeName, '.adi');
  XMLIniName    := ChangeFileExt(Application.ExeName, '.XML');
  if not FileExists(XMLIniName) then
    actOptionsExecute(actOptions);
  XMLIni  := TXmlIniFile.Create(XmlIniName);
  try
    XMLIni.OpenNode('/Application', true);
    Top     := XmlIni.ReadInteger('Top', -1);
    Left    := XmlIni.ReadInteger('Left', -1);
    Height  := XmlIni.ReadInteger('Height', Height);
    Width   := XmlIni.ReadInteger('Width', Width);

    if (top < 0) or (Top + Height > Screen.WorkAreaHeight)
    or (Left < 0) or (Left + Width > Screen.WorkAreaWidth) then
      begin
      Top   := (Screen.WorkAreaHeight - Height) div 2;
      Left  := (Screen.WorkAreaWidth - Self.Width) div 2;
      end;
    with Panel1 do
      begin
      Caption     := '';
      BevelOuter  := bvNone;
      Align       := alTop;
      end;
    with Panel2 do
      begin
      BevelOuter  := bvNone;
      Align       := alClient;
      end;
    with Panel21 do
      begin
      Caption     := '';
      BevelOuter  := bvNone;
      Align       := alTop;
      end;
    with Panel22 do
      begin
      BevelOuter  := bvNone;
      Align       := alClient;
      end;
    with Panel3 do
      begin
      BevelOuter  := bvNone;
      if isDebug then
        Visible := true
      else
        Visible := false;
      end;
    DBGrid1.Align := alClient;
    Memo1.Align   := alclient;

    isLogin := false;

    dbeQslBase.DatabaseName := AppPath + 'eQSLBase.FDB';
    dbLogBase.DatabaseName  := AppPath + 'LogBase.FDB';  // 暫定

    dbEQSLBase.Open;
    dbLogBase.Open;

    LoadXMLIni;
    SetButttons;
  finally
    FreeAndNil(XmlIni);
  end;
end;

procedure TfrmMain.DBGrid1CellClick(Column: TColumn);
var
  i: integer;
begin
  if Column.Field.DataType = ftSmallint then
  if not Column.ReadOnly  then
    begin
    i := Integer(not Boolean(Column.Field.AsInteger));
    qryEQsl.Edit;
    Column.Field.AsInteger := i;
    qryEQsl.Post;

    end;
end;

procedure TfrmMain.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  R: TRect;
begin
  if Column.Field.DataType = ftSmallint then
    begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    R := Rect;
    InflateRect(R, -1, -1);
    if Boolean(Column.Field.AsInteger) then
      DrawFrameControl(TDBGrid(Sender).Canvas.Handle, R, DFC_BUTTON, DFCS_BUTTONCHECK + DFCS_CHECKED)
    else
      DrawFrameControl(TDBGrid(Sender).Canvas.Handle, R, DFC_BUTTON, DFCS_BUTTONCHECK);
  end;
end;

procedure TfrmMain.qryEQslUpdateRecord(DataSet: TDataSet; UpdateKind: TUpdateKind; var UpdateAction: TIBUpdateAction);
begin
  updEQsl.Apply(UpdateKind);
  UpdateAction := uaApplied;
end;

function TfrmMain.QsoLog_Find(var QsoLogRec: TQsoLogRec): boolean;
  function CheckOrgCallsign(Callsign, OrgCallsign: string): boolean;
  var
    s: string;
  begin
    result := false;
    s := stringReplace(Callsign, OrgCallsign, '', [rfIgnoreCase]);
    s := stringReplace(s, '/', '', [rfIgnoreCase]);
    if Length(s) = 0 then
      begin
      result := true;
      exit;
      end;
    if Length(s) > 1 then
      exit;
    if (s >= '0') or (s <= '9')  then
      result := true;
  end;
begin
  result := false;

{   sqlQsoLogMatch1のSQL
SELECT NUM, CALLSIGN, ONDATETIME, MODE, BAND, NETLOGRECV, QSLRECV, QSLRECVDATE, GRIDLOC FROM QSOLOG
WHERE CALLSIGN = :CALLSIGN AND MODE = :MODE AND BAND = :BAND
AND ONDATETIME >= :FROMDATETIME and ONDATETIME <= :TODATETIME
ORDER BY ONDATETIME;
}

//  if qryEQsl.FieldByName('CALLSIGN').AsString = 'JI6JMD'  then
//    showMessage ('stop');

// Callsignで照合
  sqlQsoLogMatch1.Close;
  sqlQsoLogMatch1.UnPrepare;
  sqlQsoLogMatch1.ParamByName('CALLSIGN').AsString        := qryEQsl.FieldByName('CALLSIGN').AsString;
  sqlQsoLogMatch1.ParamByName('MODE').AsString            := qryEQsl.FieldByName('MODE').AsString;
  sqlQsoLogMatch1.ParamByName('BAND').AsInteger           := qryEQsl.FieldByName('BAND').AsInteger;
  sqlQsoLogMatch1.ParamByName('ONDATETIME').AsDateTime    := qryEQsl.FieldByName('ONDATETIME').AsDateTime;
  sqlQsoLogMatch1.ParamByName('FROMDATETIME').AsDateTime  := qryEQsl.FieldByName('ONDATETIME').AsDateTime - FValidityD;
  sqlQsoLogMatch1.ParamByName('TODATETIME').AsDateTime    := qryEQsl.FieldByName('ONDATETIME').AsDateTime + FValidityD;
  if not sqlQsoLogMatch1.Prepared then
     sqlQsoLogMatch1.Prepare;
  sqlQsoLogMatch1.Open;
  sqlQsoLogMatch1.Last;
  if sqlQsoLogMatch1.RecordCount <> 0 then
    begin
    result    :=  true;
    QsoLogRec.Num         := sqlQsoLogMatch1.FieldByName('Num').AsInteger;
    QsoLogRec.QslRecv     := sqlQsoLogMatch1.FieldByName('QslRecv').AsString;
    QsoLogRec.NetLogRecv  := sqlQsoLogMatch1.FieldByName('NetLogRecv').AsString;
    QsoLogRec.GridLoc     := sqlQsoLogMatch1.FieldByName('GridLoc').AsString;
    exit;
    end;

// OrgCallsignで照合
  if sqlQsoLogMatch1.RecordCount = 0 then
    if CheckOrgCallsign(qryEQsl.FieldByName('CALLSIGN').AsString, qryEQsl.FieldByName('ORGCALLSIGN').AsString) then
      begin
      sqlQsoLogMatch2.Close;
      sqlQsoLogMatch2.UnPrepare;
      sqlQsoLogMatch2.ParamByName('ORGCALLSIGN').AsString    := qryEQsl.FieldByName('ORGCALLSIGN').AsString;
      sqlQsoLogMatch2.ParamByName('MODE').AsString           := qryEQsl.FieldByName('MODE').AsString;
      sqlQsoLogMatch2.ParamByName('BAND').AsInteger          := qryEQsl.FieldByName('BAND').AsInteger;
      sqlQsoLogMatch2.ParamByName('FROMDATETIME').AsDateTime := qryEQsl.FieldByName('ONDATETIME').AsDateTime - FValidityD;
      sqlQsoLogMatch2.ParamByName('TODATETIME').AsDateTime   := qryEQsl.FieldByName('ONDATETIME').AsDateTime + FValidityD;
      if not sqlQsoLogMatch2.Prepared then
        sqlQsoLogMatch2.Prepare;
      sqlQsoLogMatch2.Open;
      sqlQsoLogMatch2.Last;
      if sqlQsoLogMatch2.RecordCount = 1 then
        begin
        result    :=  true;
        QsoLogRec.Num         := sqlQsoLogMatch2.FieldByName('Num').AsInteger;
        QsoLogRec.QslRecv     := sqlQsoLogMatch2.FieldByName('QslRecv').AsString;
        QsoLogRec.NetLogRecv  := sqlQsoLogMatch2.FieldByName('NetLogRecv').AsString;
        QsoLogRec.GridLoc     := sqlQsoLogMatch2.FieldByName('GridLoc').AsString;
        end;
      end;
end;

function TfrmMain.QsoLog_FindNewJCA: boolean;
begin
//  QslRecv(R,E)はSQLの中で判断している
//    SELECT CALLSIGN, ONDATETIME, SUFFIX FROM QSOLOG
//    WHERE SUFFIX = :SUFFIX AND QSLRECV IN ('R', 'E')
//    AND ONDATETIME >= :ONDATETIME;
  result :=  false;
  sqlQsoLogNewJCA.Close;
  sqlQsoLogNewJCA.UnPrepare;
  sqlQsoLogNewJCA.ParamByName('SUFFIX').AsString   := qryEQsl.FieldByName('SUFFIX').AsString;
  sqlQsoLogNewJCA.ParamByName('ONDATETIME').AsDateTime := StrToDateTime('1997/07/15 00:00');
  if not sqlQsoLogNewJCA.Prepared then
    sqlQsoLogNewJCA.Prepare;
  sqlQsoLogNewJCA.Open;
  sqlQsoLogNewJCA.Last;
  if sqlQsoLogNewJCA.RecordCount = 0 then
    result :=  true;
  sqlQsoLogNewJCA.Close;
end;

function TfrmMain.QsoLog_FindNewStation: boolean;
begin
//  QslRecvはSQLの中で判断している
//    SELECT CALLSIGN, QSLRECV FROM QSOLOG
//    WHERE CALLSIGN = :CALLSIGN AND (QSLRECV IS NOT NULL) AND TRIM(QSLRECV)<>'';

  result :=  false;
  sqlQsoLogNewStation.Close;
  sqlQsoLogNewStation.UnPrepare;
  sqlQsoLogNewStation.ParamByName('Callsign').AsString  := qryEQsl.FieldByName('CALLSIGN').AsString;
  if not sqlQsoLogNewStation.Prepared then
    sqlQsoLogNewStation.Prepare;
  sqlQsoLogNewStation.Open;
  sqlQsoLogNewStation.Last;
  if sqlQsoLogNewStation.RecordCount = 0 then
    result :=  true;
  sqlQsoLogNewStation.Close;
end;

function TfrmMain.QsoLog_FindNum(Num: integer; Callsign: string; var QsoLogRec: TQsoLogRec): boolean;
begin
//    SELECT NUM, CALLSIGN, ONDATETIME, MODE, BAND, NETLOGRECV, QSLRECV, QSLRECVDATE, GRIDLOC FROM QSOLOG
//    WHERE NUM = :NUM;
  result := false;

  sqlQsoLogMatch3.Close;
  sqlQsoLogMatch3.UnPrepare;
  sqlQsoLogMatch3.ParamByName('NUM').AsInteger       := Num;
  if not sqlQsoLogMatch3.Prepared then
    sqlQsoLogMatch3.Prepare;
  sqlQsoLogMatch3.Open;
  sqlQsoLogMatch3.Last;
  if (sqlQsoLogMatch3.RecordCount = 1)
  and (sqlQsoLogMatch3.FieldByName('CALLSIGN').AsString = Callsign) then
    begin
    result := true;
    QsoLogRec.Num         := sqlQsoLogMatch3.FieldByName('Num').AsInteger;
    QsoLogRec.QslRecv     := trim(sqlQsoLogMatch3.FieldByName('QSLRECV').AsString);
    QsoLogRec.NetLogRecv  := trim(sqlQsoLogMatch3.FieldByName('NetLogRecv').AsString);
    QsoLogRec.GridLoc     := trim(sqlQsoLogMatch3.FieldByName('GridLoc').AsString);
    end;
end;

function TfrmMain.QsoLog_Update(Num: integer; Callsign: string; GridLoc: string): boolean;
var
  wQsoLogRec: TQsoLogRec;
  wNetLogList: TstringList;
begin
  result := false;
  wNetLogList :=  TstringList.Create;
  try
    if QsoLog_FindNum(NUM, Callsign, wQsoLogRec) then
      begin
//  GridLocの更新
      if wQsoLogRec.GridLoc = '' then
        begin
        wQsoLogRec.GridLoc :=  GridLoc;
        result := true;
        end
      else if (Copy(wQsoLogRec.GridLoc,1,4) = Copy(GridLoc,1,4))
      and (Length(wQsoLogRec.GridLoc) < Length(GridLoc)) then
        begin
        wQsoLogRec.GridLoc :=  GridLoc;
        result := true;
        end;
//  QslRecvの更新
      if wQsoLogRec.QslRecv = '' then
        begin
        wQsoLogRec.QslRecv      :=  'E';
        wQsoLogRec.QSLRECVDATE  :=  now;
        result := true;
        end;
//  NetQSLRecvの更新
      wNetLogList.CommaText := wQsoLogRec.NetLogRecv;
      if wNetLogList.IndexOf('E') < 0 then
        begin
        wNetLogList.Add('E');
        wQsoLogRec.NetLogRecv := wNetLogList.CommaText;
        result := true;
        end;

//    UPDATE QSOLOG SET QSLRECV=:QSLRECV, QSLRECVDATE=:QSLRECVDATE,
//    NETLOGRECV=:NETLOGRECV, GRIDLOC=:GRIDLOC
//    WHERE NUM=:NUM;
      if result then
        begin
        updQsoLog.ParamByName('NUM').AsInteger      :=  Num;
        updQsoLog.ParamByName('QSLRECV').AsString   :=  wQsoLogRec.QslRecv;
        updQsoLog.ParamByName('QSLRECVDATE').AsDate :=  wQsoLogRec.QslRecvDate;
        updQsoLog.ParamByName('NetLogRecv').AsString:=  wQsoLogRec.NetLogRecv;
        updQsoLog.ParamByName('GRIDLOC').AsString   :=  wQsoLogRec.GridLoc;
        updQsoLog.Prepare;
        updQsoLog.ExecQuery;
        end;
      end;
  finally
    FreeAndNil(wNetLogList);
  end;
end;

procedure TfrmMain.MarkingIsNew();
var
  qry: TIBQuery;
  s : string;
begin
  qry := TIBQuery.Create(Self);
  try
    qry.Database := dbEQSLBase;
    s := 'UPDATE EQSL SET ISNEW=:ISNEW WHERE ISNEW <> :ISNEW';
    with qry do
      begin
      Sql.Clear;
      SQL.Add(s);
      ParamByName('ISNEW').AsInteger := integer(false);
      Prepare;
      qry.ExecSQL;
      end;
  finally
    FreeAndNil(qry);
  end;
end;

function TfrmMain.GetDownloadFileName(InBox: TArchived; RecvdSince: double = 0): string;
var
  s: string;
  t: TdateTime;
  PostURL: string;
  PostStream: TStringList;
  StrResponce: string;
  StartPos, EndPos: integer;
begin
  result := '';
  Screen.Cursor := crHourGlass;
  Statusbar1.SimpleText := 'Download1';
  Memo1.Clear;
  PostStream := TStringList.Create;
  try
    try
      PostURL     := c_eQslUrl + c_DownloadUrl;
      PostStream.Add('HamOnly=1');    // HamOnlyの値は何でもよい
      if InBox <> acAll then
        begin
        s := IntToStr(Integer(Inbox));
        PostStream.Add('Archive=' + UniCodeString(HTTPEncode(AnsiString(s))));
        end;
      if RecvdSince <> 0 then
        begin
        t := floatToDateTime(RecvdSince);
        s := FormatDateTime('yyyymmddhhnn', t);
        PostStream.Add('RcvdSince=' + UniCodeString(HTTPEncode(AnsiString(s))));
        end;
      StrResponce := IdHTTP1.Post(PostURL, PostStream);
      Memo1.Lines.Add(StrResponce);
      idHttp1.Disconnect;
      StartPos  := Pos('<LI><A HREF="', StrResponce) + 13;
      EndPos    := PosEx('">.ADI file', StrResponce, StartPos);
      result    := Copy(StrResponce, StartPos, EndPos - StartPos);
    except
      MessageDlg('GetDownloadFileName ', mtError, [mbYes], 0);   //エラー内容はIdHTTP1.ResponseTextで受取る
      exit;
    end;
  finally
    FreeAndNil(PostStream);
    Screen.Cursor := crDefault;
  end;
end;

function TfrmMain.GetADIF(FileName: string): boolean;
var
  PostURL    : String;
  StrResponce: string;
begin
  Result := True;
  Screen.Cursor := crHourGlass;
  Statusbar1.SimpleText := 'Download2';
  Memo1.Clear;
  try
    try
      PostURL     := c_eQslUrl + c_QSLCardUrl + Filename;
      StrResponce := IdHTTP1.Get(PostURL);
      idHttp1.Disconnect;
      Memo1.Lines.Add(StrResponce);
      Memo1.Lines.SaveToFile(AdifFileName);
      if Pos(c_AdifHeader, Memo1.Lines[0]) = 0 then
        begin
        MessageDlg('ADIFファイルを抽出できなかった', mtError, [mbYes], 0);
        result := false;
        end;
    except
      result := false;
      MessageDlg('GetAdif Error', mtError, [mbYes], 0);
      exit;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function TfrmMain.AdifToDataSet(InString: string; Ds: TIBQuery): boolean;
type
  TAdifType = (atInvalid, atFieldName, atFieldLength, atFieldType, atFieldValue);
var
  isHeader: boolean;
  i,j: integer;
  AChar: string;
  AdifType: TAdifType;
  FieldName: string;
  FieldLength: string;
  FieldType: string;
  FieldValue: string;
  Rec: TStringList;
  CallsignRec: TCallsignRec;
  BandList: TstringList;
  DownloadDate: TdateTime;
  function AddDataSet: boolean;
  var
    i: integer;
    s: string;
    dt: TDateTime;
  begin
    result := true;
    s := UpperCase(Rec.Values['CALL']);
    CheckCallsign(s, CallsignRec);
    qryEqsl.Append;
    qryEqsl.FieldByName('Callsign').AsString    :=  s;
    qryEqsl.FieldByName('OrgCallsign').AsString :=  CallsignRec.OrgCallsign;
    qryEqsl.FieldByName('Suffix').AsString      :=  CallsignRec.Suffix;

    dt :=  ToDateTime(Rec.Values['QSO_DATE'], Rec.Values['TIME_ON']);
    qryEqsl.FieldByName('OnDateTime').AsDateTime   :=  dt;

    s :=  UpperCase(Rec.Values['BAND']);    // 単位[M]が小文字[m]でeQSLに登録されているデータがある
    qryEqsl.FieldByName('Band_M').AsString  :=  s;
    qryEqsl.FieldByName('Band').AsInteger   :=  StrToInt(BandList.Values[s]);

    qryEqsl.FieldByName('Mode').AsString    :=  UpperCase(Rec.Values['MODE']);
    qryEqsl.FieldByName('GridLoc').AsString :=  UpperCase(Rec.Values['GRIDSQUARE']);
    qryEqsl.FieldByName('QSLMSG').AsString  :=  Rec.Values['QSLMSG'];

    qryEqsl.FieldByName('Match').AsInteger      :=  Integer(false);
    qryEqsl.FieldByName('NewStation').AsInteger :=  Integer(false);
    qryEqsl.FieldByName('NewJCA').AsInteger     :=  Integer(false);
    qryEqsl.FieldByName('Archived').AsInteger   :=  Integer(false);
    qryEqsl.FieldByName('Printed').AsInteger    :=  Integer(false);
    qryEqsl.FieldByName('isNEW').AsInteger      :=  Integer(true);
    qryEqsl.FieldByName('isMARK').AsInteger     :=  Integer(false);
    qryEqsl.FieldByName('Num').AsInteger        :=  0;
    qryEqsl.FieldByName('DownloadDate').AsDateTime   :=  DownloadDate;
    qryEqsl.FieldByName('MYCALLSIGN').AsString  :=  UserName;
    s :=  qryEqsl.FieldByName('Callsign').AsString
        + '_' + FormatDateTime('yyyymmddhhnn', qryEqsl.FieldByName('OnDateTime').AsDateTime)
        + '_' + qryEqsl.FieldByName('Band_M').AsString
        + '_' + qryEqsl.FieldByName('MODE').AsString;

   i  := CheckDupKey(s);
   if i <> 0 then
     begin
     qryEQSL.Cancel;
     result := false;
     end
   else
     begin
     qryEqsl.FieldByName('DataKey').AsString   :=  s;
     qryEQSL.Post;
     qryEQsl.ApplyUpdates;
     end;
  end;
begin
  result := true;
  rec := TstringList.Create;
  BandList := TstringList.Create;
  qryEQsl.DisableControls;
  try
    DownloadDate := now;
    GetBandList('Band_M', 'Band', BandList);

    isHeader      := true;
    AdifType      := atInvalid;
    i := 0;
    while i < Length(InString) do
      begin
      inc(i);
      AChar := Instring[i];
      if AChar = '<' then
        begin
        AdifType := atFieldName;
        FieldnAME   := '';
        FieldLength := '';
        FieldType   := '';
        FieldValue  := '';
        end
      else if AChar = ':' then
        begin
        if AdifType = atFieldName then
          AdifType := atFieldLength
        else if AdifType = atFieldLength then
          AdifType := atFieldType
        end
      else if AChar = '>' then
        begin
        FieldName := UpperCase(FieldName);
        if FieldName = 'EOH' then
          isHeader := false              // Headerの終わり
        else if FieldName = 'EOR' then
          begin
          AddDataSet;  // ADIF1件を登録する
          rec.Clear
          end
        else
          begin
          j := StrToInt('0' + FieldLength);
          if j <> 0 then
            FieldValue  := Copy(InString, i+1, J);
          if (FieldName <> '') and (FieldValue <> '') then
            begin
            if not isHeader then   //  DATA部を書き出す
              rec.Add(FieldName + '=' + FieldValue);
            end;
          AdifType      := atInvalid;
          end;
        end
      else if AChar < #20 then
        continue
      else
        case AdifType of
        atFieldName:
          FieldName := FieldName + Achar;
        atFieldLength:
          FieldLength := FieldLength + Achar;
        atFieldType:
          FieldType := FieldType + Achar;
      end;
    end;
  finally
    qryEQsl.ApplyUpdates;
//    qryEQsl.DisableControls;
    qryEQsl.Close;
    EQsl_Open;
    qryEQsl.EnableControls;
    FreeAndNil(rec);
    FreeAndNil(BandList);
  end;
end;

procedure TfrmMain.btnDownloadClick(Sender: TObject);
begin

end;

//--------------------------------------------------------------------------------
function TfrmMain.CheckDupKey(MainKey: string): Integer;
var
  i: integer;
  s,t: string;
begin
  sqlSelectEQsl.Close;
  sqlSelectEQsl.ParamByName('DATAKEY').AsString := MainKey + '%';
  sqlSelectEQsl.Open;
  sqlSelectEQsl.Last;
  if sqlSelectEQsl.RecordCount = 0 then
    result :=  0
  else
    begin
    s :=  sqlSelectEQsl.FieldByName('DATAKEY').AsString;
    s :=  Copy(s, Length(s) - 2, 3);
    t :=  Copy(s, Length(s) - 3, 1);
    if TryStrToInt(s, i) and (t = '-') then
      result := i
    else
      result := 1;
    end;
end;

procedure TfrmMain.MatchAndUpdateQsoLog;
var
  startTime: tdateTime;
  RemainTime: double;
  LastCallsign: string;
  fmt: string;
  wQsoLogRec: TQsoLogRec;
begin
  Statusbar1.SimpleText := 'MatchAndUpdate';
  Screen.Cursor := crHourGlass;
  try
    LastCallsign  := '';
    qryEQsl.First;
    qryEQsl.DisableControls;
    StartTime := Now;
    fmt := 'MatchAndUpdate  %d/' + IntToStr(qryEQsl.RecordCount) + '    Remaining time %7.1f sec';
    while not qryEQsl.Eof do
      begin
      RemainTime := (now - StartTime) * (qryEQsl.RecordCount - qryEQsl.RecNo) * 86400 / qryEQsl.RecNo;
      Statusbar1.SimpleText := format(fmt, [qryEQsl.RecNo, RemainTime]);

      if QsoLog_Find(wQsoLogRec) then   // LogBaseのデータを検索　マッチしたかどうか？
        begin
        qryEQSL.Edit;
        qryEQSL.FieldByName('NUM').AsInteger        :=  wQsoLogRec.Num;
        qryEQSL.FieldByName('MATCH').AsInteger      :=  integer(true);
        qryEQSL.FieldByName('NEWSTATION').AsInteger :=  integer(false);
        qryEQSL.FieldByName('NEWJCA').AsInteger     :=  integer(false);
        if qryEQsl.FieldByName('CALLSIGN').AsString <> LastCallsign then
          begin
          qryEQSL.FieldByName('NEWSTATION').AsInteger :=  integer(QsoLog_FindNewStation);
          qryEQSL.FieldByName('NEWJCA').AsInteger     :=  integer(QsoLog_FindNewJCA);
          end
        else
          begin
          end;
        LastCallsign  := qryEQsl.FieldByName('CALLSIGN').AsString;

        qryEQSL.Post;
        qryEQsl.ApplyUpdates;
        end;
      qryEQsl.Next;
      end;
  finally
    Statusbar1.SimpleText := '';
    qryEQsl.EnableControls;
    qryEQsl.Close;
    qryEQsl.Open;
    qryEQsl.Last;
//    qryEQsl.FetchAll;
    DbGrid1.Update;    //  Update,Rfleshu .REPaint;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.LoadXmlIni;
var
  i: integer;
  sl: tstringlist;
  XmlIni: TXmlIniFile;
begin
  XmlIni  := TXMLIniFile.Create(FXmlIniName);
  sl := TStringlist.Create;
  try
    XmlIni.OpenNode('/Application', true);
    LoggingApp    := XmlIni.ReadString('Application', '');
    DataBasePath  := XmlIni.ReadString('DataPath', '');
    ImgFilePath   := XmlIni.ReadString('ImgPath', '');
    TimeZone      := XmlIni.ReadInteger('TimeZoneV', 0);
    Validity      := XmlIni.ReadInteger('ValidityV', 0);

    if XmlIni.OpenNode('/DBGrid/', false) then
      sl.CommaText := XmlIni.ReadString('Order', '')
    else
      for I := 0 to qryEQsl.FieldCount - 1 do
        sl.Add(qryEQsl.Fields[i].FieldName);
    if XmlIni.OpenNode('/DBGrid/Style/', false) then
      begin
      DBGrid1.columns.BeginUpdate;
      DBGrid1.Columns.Clear;
      for i := 0 to sl.Count - 1 do
        begin
        if  XmlIni.OpenNode('/DBGrid/Style/' + sl.Strings[i] + '/', false) then
          begin
          with DBGrid1.Columns.Add    do
            begin
            FieldName  := sl.Strings[i];
            Width      := XmlIni.ReadInteger('Width' , 64);
            Alignment  := TAlignment(XmlIni.ReadInteger('Alignment', 0));
            Title.Caption := XmlIni.ReadString('Title', '');
            Visible    := XmlIni.ReadBool('Visible', true);
            end;
          end;
        end;
      DBGrid1.columns.EndUpdate;
      end;
  finally
    FreeAndNil(xmlIni);
    FreeAndNil(sl);
  end;
end;

function TfrmMain.Login(Auto: boolean): boolean;
var
  PostURL    : String;
  PostStream : TStringList;
  StrResponce: string;
  XmlIni: TXmlIniFile;
begin
  result  := true;
  XmlIni  := TXMLIniFile.Create(FXmlIniName);
  PostStream := TStringList.Create;
  Memo1.Clear;
  try
    Statusbar1.SimpleText := 'Login';
    XMLIni.OpenNode('/Application', true);
    frmLogin.UserName   := XmlIni.ReadString('UserName', '');
    XMLUserPath :=  frmLogin.UserName;
    if frmLogin.UserName = '' then
      begin
      frmLogin.Password   := '';
      frmLogin.AutoLogin  := false;
      end
    else
      begin
      XMLIni.OpenNode(XMLUserPath, true);
      frmLogin.Password   := XmlIni.ReadString('Password', '');
      frmLogin.AutoLogin  := XmlIni.ReadBool('AutoLogin', false);
      end;
    if not Auto then
      begin
      if (frmLogin.ShowModal <> mrOK) or (frmLogin.UserName = '')   then
        begin
        result := false;
        exit;
        end;
      XMLIni.OpenNode('/Application', true);
      XmlIni.WriteString('UserName', frmLogin.UserName);
      XmlIni.CloseNode;
      XmlIni.UpdateFile;
      XMLIni.OpenNode(XMLUserPath, true);
      XmlIni.WriteString('Password', frmLogin.Password);
      XmlIni.WriteBool('AutoLogin', frmLogin.AutoLogin);
      XmlIni.CloseNode;
      XmlIni.UpdateFile;
      end;

    Screen.Cursor := crHourGlass;
    IdHTTP1.HTTPOptions := IdHTTP1.HTTPOptions - [hoForceEncodeParams];      //自動でエンコードしないようにする
    try
      PostURL := c_eQslUrl + 'qslcard/LoginFinish.cfm';
      PostStream.Add('Callsign=' + UniCodeString(HTTPEncode(AnsiString(frmLogin.UserName))));
      PostStream.Add('EnteredPassword=' + UniCodeString(HTTPEncode(AnsiString(frmLogin.Password))));
      PostStream.Add('Login=Go');
      StrResponce := IdHTTP1.Post(PostURL, PostStream);
      Memo1.Lines.Add(StrResponce);
      idHttp1.Disconnect;
      if Pos('Registration Error', StrResponce) <> 0 then
        begin
        Result := false;
        MessageDlg('登録されたCallsignでない', mtError, [mbYes], 0);
        end;
      if Pos('Please enter a Password', StrResponce) <> 0 then
        begin
        Result := false;
        MessageDlg('Passwordが入力されていない', mtError, [mbYes], 0);
        end;
      if Pos('Password Error', StrResponce) <> 0 then
        begin
        Result := false;
        MessageDlg('Passwordが誤っている', mtError, [mbYes], 0);
        end;
      if result then
        begin
        UserName :=  frmLogin.UserName;
        Password  := frmLogin.Password;
        isLogin := true;
        cbxShowAllDataClick(cbxShowAllData);  // テーブルeQSLのオープン
        end;
    except
      Result := false;
      MessageDlg('Login error', mtError, [mbYes], 0);
    end;
  finally
    Statusbar1.SimpleText := '';
    Screen.Cursor := crDefault;
    FreeAndNil(XmlIni);
    FreeAndNil(PostStream);
  end;
end;

function TfrmMain.Logout(): boolean;
var
  PostURL    : String;
  PostStream : TStringList;
  StrResponce: string;
begin
  result  := true;
  PostStream := TStringList.Create;
  Memo1.Clear;
  try
    Statusbar1.SimpleText := 'Logout';
    Screen.Cursor := crHourGlass;
    try
      PostURL := c_eQslUrl + 'qslcard/logout.cfm';
      StrResponce := IdHTTP1.Post(PostURL, PostStream);
      Memo1.Lines.Add(StrResponce);
      idHttp1.Disconnect;
      isLogin := false;
    except
      Result := false;
      MessageDlg('Logout error', mtError, [mbYes], 0);
      exit;
    end;
  finally
    Statusbar1.SimpleText := '';
    Screen.Cursor := crDefault;
    FreeAndNil(PostStream);
  end;
end;

function TfrmMain.GetImageFiles(): boolean;
var
  qry: TIBQuery;
  s : string;
  fmt: string;
  StartTime: tdateTime;
  RemainTime: double;
  FolderName: string;
  SaveFileName: string;
  Num: Integer;
  Callsign: string;
  OnDateTime: TDateTime;
  Band: string;
  Mode: string;
  FileNames: TStringDynArray;
  PostTime: TDateTime;
  LastTime: TDateTime;
  WTime1: double;
  WTime2: double;
  WTime3: double;
  QueryCycle: integer;
begin
  result  := true;
  qry     := TIBQuery.Create(Self);
  Screen.Cursor := crHourGlass;
  StartTime := now;
  try
    if cbxShowAllData.Checked then
      s := 'SELECT * FROM EQSL WHERE MYCALLSIGN=''%s'' AND ARCHIVED=0 AND ISMARK=1 ORDER BY DATAKEY;'
    else
      s := 'SELECT * FROM EQSL WHERE MYCALLSIGN=''%s'' AND ARCHIVED=0 AND ISMARK=1 AND ISNEW=1 ORDER BY DATAKEY;';
    s := format(s, [UserName]);
    qry.Database := dbeQslBase;
    qry.SQL.Clear;
    qry.SQL.Add(s);
    qry.Open;
    qry.Last;
    qry.First;
//    Statusbar1.SimpleText := ' Archive image file';
    QueryCycle  := 15;  // 15秒間隔でeQSLへArchiveをする
    fmt := ' Archive image file  %d/' + IntToStr(qry.RecordCount) + '    Remaining time %7.1f sec';

    RemainTime := QueryCycle * qry.RecordCount;
    Statusbar1.SimpleText := format(fmt, [qry.RecordCount, RemainTime]);
    while not qry.EOF do
      begin
      FolderName    := MakeFolder(qry.FieldByName('Callsign').AsString);
      SaveFileName  := FolderName + '\' + StringReplace(qry.FieldByName('DataKey').AsString, '/', '-', [rfReplaceAll]) + '.*';
      filenames :=  FileNameExists(FolderName, SaveFileName);
      if Length(FileNames) < 1 then
        begin
        Num         := qry.FieldByName('Num').AsInteger;
        Callsign    := qry.FieldByName('Callsign').AsString;
        OnDateTime  := qry.FieldByName('OnDateTime').AsDateTime;
        Band        := qry.FieldByName('Band_M').AsString;
        Mode        := qry.FieldByName('Mode').AsString;

        PostTime  := now;
        if DownloadImageFile(Callsign, OnDateTime, Band, Mode, SaveFileName) then
          if qryEQsl.Locate('DATAKEY', VarArrayOf([qry.FieldByName('DataKey').AsString]), [loCaseInsensitive]) then
            begin
            qryEqsl.Edit;
            qryEQsl.FieldByName('Archived').AsInteger  :=  integer(true);
            qryEQsl.FieldByName('ISMARK').AsInteger :=  integer(false);
            qryEQSL.Post;
            qryEQSL.ApplyUpdates;

            QsoLog_Update(Num, Callsign, qry.FieldByName('GridLoc').AsString);
            end
          else
            begin
            TestLog.Add('Test1 ' + SaveFileName);
            end
        else
          TestLog.Add('Test2 ' + SaveFileName);
        if qry.RecNo <> qry.RecordCount then   // 最後のレコードの時は待つ必要ない
          begin
          LastTime := now;
          WTime1     :=  LastTime - PostTime;               // 日単位差分
          WTime2     :=  WTime1 * 24 * 60 * 60;         // 秒単位差分にする
          WTime3     :=  (QueryCycle - WTime2) * 1000;  // ミリ秒に変換
          if WTime3 > 0 then
            WaitTime(trunc(WTime3));    // 最小15秒Wait
          end;
        end;
      RemainTime := (now - StartTime) * (qry.RecordCount - qry.RecNo) * 86400 / qry.RecNo;
      Statusbar1.SimpleText := format(fmt, [qry.RecNo, RemainTime]);
      qry.next;
      end;
  finally
    FreeAndNil(qry);
    Screen.Cursor := crDefault;
  end;
end;

//function TfrmMain.HavePrintedQSL(Num: integer; Callsign: string): boolean;
//var
//  wQslRecv: string;
//begin
//  result := false;
//
//  sqlQsoLogMatch3.Close;
//  sqlQsoLogMatch3.UnPrepare;
//  sqlQsoLogMatch3.ParamByName('NUM').AsInteger       := Num;
//  if not sqlQsoLogMatch3.Prepared then
//    sqlQsoLogMatch3.Prepare;
//  sqlQsoLogMatch3.Open;
//  sqlQsoLogMatch3.Last;
//  if (sqlQsoLogMatch3.RecordCount = 1)
//  and (sqlQsoLogMatch3.FieldByName('CALLSIGN').AsString = Callsign) then
//    begin
//    wQslRecv  :=  trim(sqlQsoLogMatch3.FieldByName('QSLRECV').AsString);
//    if wQslRecv <> '' then
//      result := true;
//    end;
//end;

function TfrmMain.MakeFolder(Callsign: string): string;
var
  s1,s2: string;
  i: integer;
  FolderName: string;
begin
  result := '';
  s1 := Copy(Callsign, 1, 1);
  s2 := Copy(callsign, 2, 1);
  i := 1;
  if (s1 = 'J') and (s2 >= 'A') and (s2 <= 'S') then
      i := 2
  else if ((s1 = '7') or (s1 = '8')) and (s2 >= 'J') and (s2 <= 'N') then
      i := 2;
  FolderName := FImgFilePath + Copy(Callsign, 1, i);
  if not SysUtils.DirectoryExists(FolderName) then
    SysUtils.ForceDirectories(FolderName);

  result :=  FolderName;
end;

function TfrmMain.DownloadImageFile(Callsign: string; OnDateTime: TDateTime; Band, Mode: string; SavePath: string): boolean;
var
  ext: string;
  PostURL    : String;
  PostStream : TStringList;
  StrResponce: string;
  startPos, EndPos: integer;
  SaveFileName: string;
  LoadFileName: string;
begin
  Result := false;
  IdHTTP1.HandleRedirects := True;
  PostStream := TStringList.Create;
  try
    try
    PostURL := c_eQslUrl + 'qslcard/GeteQSL.cfm';
    PostStream.Add('Username=' + UniCodeString(HTTPEncode(AnsiString(FUserName))));
    PostStream.Add('Password=' + UniCodeString(HTTPEncode(AnsiString(FPassword))));
    PostStream.Add('CallsignFrom=' + UniCodeString(HTTPEncode(AnsiString(Callsign))));
    PostStream.Add('QSOYear=' + UniCodeString(HTTPEncode(AnsiString(FormatDateTime('yyyy', OnDateTime)))));
    PostStream.Add('QSOMonth=' + UniCodeString(HTTPEncode(AnsiString(FormatDateTime('mm', OnDateTime)))));
    PostStream.Add('QSODay=' + UniCodeString(HTTPEncode(AnsiString(FormatDateTime('dd', OnDateTime)))));
    PostStream.Add('QSOHour=' + UniCodeString(HTTPEncode(AnsiString(FormatDateTime('hh', OnDateTime)))));
    PostStream.Add('QSOMinute=' + UniCodeString(HTTPEncode(AnsiString(FormatDateTime('nn', OnDateTime)))));
    PostStream.Add('QSOBand=' + UniCodeString(HTTPEncode(AnsiString(Band))));
    PostStream.Add('QSOMode=' + UniCodeString(HTTPEncode(AnsiString(Mode))));
    StrResponce := IdHTTP1.Post(PostURL, PostStream);

//    memo1.Clear;
    memo1.lines.add('-----' + Callsign + '-----');
    Memo1.Lines.Add(StrResponce);

    if Pos('Error', StrResponce) <> 0 then
      exit;
    if Pos('Warning', StrResponce) <> 0 then
      exit;

    StartPos := Pos('img src="', StrResponce) + length('img src="') + 1;
    if StartPos > 0 then
      begin
      EndPos := PosEx('" alt=', StrResponce, StartPos);
      LoadFileName := Copy(StrResponce, StartPos, EndPos - StartPos);
      ext := ExtractFileExt(LoadFileName);
      SaveFileName := ChangeFileExt(SavePath, ext);
      PostURL := c_eQslUrl + LoadFileName;

      result := URLDownloadToFile(nil, PChar(PostURL), PChar(SaveFileName), 0, nil) = S_OK;
      end;
    except
      MessageDlg('GetImageFile Error', mtError, [mbYes], 0);
      exit;
    end;
  finally
    idHttp1.Disconnect;
    FreeAndNil(PostStream);
  end;
end;

function TfrmMain.DownloadInbox: boolean;
var
  s: string;
  fromDateTime: TDateTime;
begin
  result := true;
  XMLIni  := TXmlIniFile.Create(FXmlIniName);
  try
    XMLIni.OpenNode(XMLUserPath, false);
    fromDateTime := XmlIni.ReadDateTime('FromDateTime', 0);

    MarkingIsNew;  // 前回分を表示しないようにする
    s := GetDownloadFileName(acAll, fromDateTime);
    if s <> '' then
      begin
      GetADIF(s);

      AdifToDataSet(Memo1.Lines.Text, qryEQsl);
      XmlIni.WriteDateTime('LastDateTime', fromDateTime);
      XmlIni.WriteDateTime('FromDateTime', Now);
      XmlIni.CloseNode;
      XmlIni.UpdateFile;
      end
    else
      result := false;
  finally
    FreeAndNil(XmlIni);
  end;
end;

function TfrmMain.EQsl_Open: boolean;
begin
  result := true;
  try
    qryEQsl.Open;
    qryEqsl.Last;
    qryEQsl.First;
  except
    result := false;
  end;
end;

procedure TfrmMain.SaveXmlIni;
var
  i: integer;
  s: string;
  sl: TStringList;
  XmlIni: TXmlIniFile;
begin
  XmlIni  := TXMLIniFile.Create(FXmlIniName);
  sl := TStringList.Create;
  try
    for i := 0 to DBGrid1.Columns.Count - 1 do
      begin
      s := DBGrid1.Columns[i].FieldName;
      sl.Add(DBGrid1.Columns[i].FieldName);
      XmlIni.OpenNode('/DBGrid/Style/' + s, True);
      XmlIni.WriteInteger('Width', DBGrid1.Columns[i].Width);
      XmlIni.WriteInteger('Alignment', Integer(DBGrid1.Columns[i].Alignment));
      XmlIni.WriteString('Title', DBGrid1.Columns[i].Title.Caption);
      XmlIni.WriteBool('Visible', DBGrid1.Columns[i].Visible);    // 不要?
      XmlIni.CloseNode;
      end;
    XmlIni.OpenNode('/DBGrid/', True);
    XmlIni.WriteString('Order', sl.CommaText);
    XmlIni.CloseNode;
    XmlIni.UpdateFile;
  finally
    FreeAndNil(XmlIni);
    FreeAndNil(sl);
  end;
end;

procedure TfrmMain.SetAppName(const Value: string);
begin
  FAppName := Value;
end;

procedure TfrmMain.SetAppPath(const Value: string);
begin
  FAppPath := Value;
end;

procedure TfrmMain.SetAutoLogin(const Value: boolean);
begin
  FAutoLogin := Value;
end;

procedure TfrmMain.SetButttons;
begin
  actDownload.Enabled := true;
  actMarking.Enabled  := true;
  actArchive.Enabled  := true;
  actPrint.Enabled    := true;
  actExport.Enabled   := true;
  cmbSelect.Enabled   := true;

  if not isLogin then
    begin
    actDownload.Enabled := false;
    actArchive.Enabled  := false;
    end;
  if qryEQsl.RecordCount = 0 then
    begin
    cmbSelect.Enabled   := false;
    actMarking.Enabled  := false;
    actArchive.Enabled  := false;
    actPrint.Enabled    := false;
    actExport.Enabled   := false;
    end;
end;

procedure TfrmMain.SetDataBasePath(const Value: string);
begin
  FDataBasePath := Value;
end;

procedure TfrmMain.SetImageFilePath(const Value: string);
begin
  if Copy(Value, length(Value), 1) = '\' then
    FImageFilePath := Value
  else
    FImageFilePath := Value + '\';
end;

procedure TfrmMain.SetImgFilePath(const Value: string);
begin
  FImgFilePath := Value;
end;

procedure TfrmMain.SetLoggingApp(const Value: string);
begin
  FLoggingApp := Value;
end;

procedure TfrmMain.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TfrmMain.SetUserName(const Value: string);
begin
  FUserName     := Value;
  FXMLUserPath  := '/' + Value;
end;

procedure TfrmMain.SetValidity(const Value: integer);
begin
  FValidity := Value;
  FValidityD  :=  FValidity / 24 / 60;
end;

procedure TfrmMain.SetValidityD(const Value: double);
begin
  FValidityD := Value;
end;

procedure TfrmMain.SetXMLIniName(const Value: string);
begin
  FXMLIniName := Value;
end;

procedure TfrmMain.SetXMLUserPath(const Value: string);
begin
  FXMLUserPath  := '/' + Value;
end;

procedure TfrmMain.ShowAbout;
begin
   AboutBox.show
end;

procedure TfrmMain.makeMarking;
var
  qry: TIBQuery;
  s : string;
begin
  if qryEQsl.UpdatesPending then
    qryEQsl.ApplyUpdates();
  qry := TIBQuery.Create(Self);
  try
    if cmbSelect.ItemIndex = 0 then
      s := 'UPDATE EQSL SET ISMARK=0 WHERE ISNEW=1'
    else if cmbSelect.ItemIndex = 1 then
      s := 'UPDATE EQSL SET ISMARK=1 WHERE ISNEW=1'
    else if cmbSelect.ItemIndex = 2 then
      s := 'UPDATE EQSL SET ISMARK=1 WHERE ISNEW=1 AND MATCH=1'
    else if cmbSelect.ItemIndex = 3 then
      s := 'UPDATE EQSL SET ISMARK=1 WHERE ISNEW=1 AND MATCH<>1'
    else if cmbSelect.ItemIndex = 4 then
      s := 'UPDATE EQSL SET ISMARK=1 WHERE ISNEW=1 AND NEWSTATION=1'
    else if cmbSelect.ItemIndex = 5 then
      s := 'UPDATE EQSL SET ISMARK=1 WHERE ISNEW=1 AND NEWJCA=1';
    s := s + ' AND MYCALLSIGN=''' + Username + ''';';
    with qry do
      begin
      Database := dbeQslBase;
      Sql.Clear;
      SQL.Add(s);
      ExecSQL;
      end;
  finally
    qryEqsl.DisableControls;
    qryEQsl.Close;
    EQsl_Open;
    qryEQsl.EnableControls;
    FreeAndNil(qry);
  end;
end;

/////////////////////////////////////////////////////////////
//
//    周波数、バンドのリストを作成する
//
////////////////////////////////////////////////////////////
procedure TfrmMain.GetBandList(FromBand, ToBand: string; var BandList: TStringList);
var
  qry: TIBQuery;
  s : string;
begin
  qry := TIBQuery.Create(Self);
  try
    qry.Database := dbeQSLBase;
    qry.UniDirectional := true;
    BandList.Clear;
    if FromBand = ToBand then
      exit;
    s := format('Select %0:s, %1:s FROM Band ORDER BY %0:s;', [FromBand, ToBand]);
    with qry do
      begin
      Sql.Clear;
      SQL.Add(s);
      Prepare;
      Open;
      First;
      while not Eof do
        begin
        s := UpperCase(Fields[0].AsString) + '=' + Fields[1].AsString;
        BandList.Add(s);
        Next;
        end;
      Close;
      end;
  finally
    FreeAndNil(qry);
  end;
end;

/////////////////////////////////////////////////////////////
//
//    CallsignからOrgCallsign,Prefix,Suffix,Areaを作成する
//
////////////////////////////////////////////////////////////
function TfrmMain.CheckCallsign(vCallsign: string; var CallsignRec: TCallsignRec): boolean;
const
//    Callsignは、数字が0または1桁 英字が1桁以上 数字が1桁以上 英字が1桁以上　
  gCallsign='([1-9]?[A-Z]+)([0-9]+)([A-Z]+)';
//    Prefixは、数字が0または1桁 英字が1桁以上 数字が0桁以上　
  gPrefix='([1-9]?[A-Z]+)([0-9]{0,1})';
//  gPrefix2='([1-9]?[A-Z]+)([0-9]*)([A-Z]*)';
//    Areaは、数字が1桁　
  gArea='([0-9])';
var
  Brx: TSkRegExp;
  s,s1,s2: string;
  t: string;
  c1,c2: boolean;
begin
  result  :=  true;
  Brx := TSkRegExp.Create;
  try
    CallsignRec.Callsign    := vCallsign;
    CallsignRec.OrgCallsign := '';
    CallsignRec.Prefix      := '';
    CallsignRec.Suffix      := '';
    CallsignRec.Area        := '';
    CallsignRec.result      := true;

    s   := CallsignRec.Callsign;
//  /MM,/QRP,/P(英一文字)などを削除
    s := RegReplace('/([A-Z]|MM|QRP|QRPP|)$', s, '');
//  orgCallsignのみ  ex. 'JA7FKF'
    Brx.Expression := '^' + gCallsign + '$';
    if Brx.Exec(s) then
      begin
      CallsignRec.OrgCallsign := s;
      CallsignRec.Prefix      := Brx.Match[1] + Brx.Match[2];
      CallsignRec.Suffix      := Brx.Match[3];
      CallsignRec.Area        := copy(Brx.Match[2], 1, 1);
//'7K1AAA'などのAreaを設定
      Brx.Expression := '^(7[K-N][1-4][A-Z]{3})$';
      if Brx.Exec(s) then
        CallsignRec.Area   := '1';
      exit;
      end;
// orgCallsign + Area   ex. 'JA7FKF/1' → Prifix=JA1
    Brx.Expression := '^'+gCallsign+'/'+gArea+'$';
    if Brx.Exec(s) then
      begin
      CallsignRec.OrgCallsign := Brx.Match[1]+Brx.Match[2]+Brx.Match[3];
      CallsignRec.Area        := Copy(Brx.Match[4],1,1);
      CallsignRec.Prefix      := Brx.Match[1] + CallsignRec.Area;
      CallsignRec.Suffix      := Brx.Match[3];
      exit;
      end;
// PreCallsign+ orgCallsign  ex. 'KH0/JA7FKF'
    Brx.Expression := '^'+gPrefix+'/'+gCallsign+'$';
    if Brx.Exec(s) then
      begin
      CallsignRec.OrgCallsign := Brx.Match[3]+Brx.Match[4]+Brx.Match[5];
      if Brx.Match[2] <> '' then
        CallsignRec.Area   := Copy(Brx.Match[2],1,1)
      else
        CallsignRec.Area   := Copy(Brx.Match[4],1,1);
      CallsignRec.Prefix := Brx.Match[1] + CallsignRec.Area;
      CallsignRec.Suffix := Brx.Match[5];
      exit;
      end;
// orgCallsign + PreCallsign   ex. 'JA7FKF/JD1'
    Brx.Expression := '^'+gCallsign+'/'+gPrefix+'$';
    if Brx.Exec(s) then
      begin
      CallsignRec.OrgCallsign := Brx.Match[1]+Brx.Match[2]+Brx.Match[3];
      if Brx.Match[5] <> '' then
        CallsignRec.Area   := Copy(Brx.Match[5],1,1)
      else
        CallsignRec.Area   := Copy(Brx.Match[2],1,1);
        CallsignRec.Prefix := Brx.Match[4] + CallsignRec.Area;
        CallsignRec.Suffix := Brx.Match[3];
        exit;
      end;

    Brx.Expression := '^(\w+)/(\w+)$';
    if Brx.Exec(s) then
      begin
      if Brx.GroupCount <= 3 then      // [/]が一個
        begin
        s1 := Brx.Match[1];
        s2 := Brx.Match[2];
        c1 := RegIsMatch('^'+gCallsign+'$', s1);
        c2 := RegIsMatch('^'+gCallsign+'$', s2);
        if c1 and c2 then
          begin
// orgCallsign + orgCallsign  ex. 'AH3C/KH5J' 'JA7FKF/BY1BJ'
          Brx.Expression := '^'+gCallsign+'/'+gCallsign+'$';
          Brx.Exec(s);
          if (Length(s1) > Length(s2)) and (Length(s2) <= 4) then
            begin
            CallsignRec.OrgCallsign := s1;
            CallsignRec.Area              := Copy(Brx.Match[5],1,1);
            CallsignRec.Prefix            := Brx.Match[4] + CallsignRec.Area;
            CallsignRec.Suffix            := Brx.Match[3];
            exit;
            end
          else
            if (Length(s1) < Length(s2)) and (Length(s1) <= 4)  then
              begin
              CallsignRec.OrgCallsign      := s2;
              CallsignRec.Area             := Copy(Brx.Match[2],1,1);
              CallsignRec.Prefix           := Brx.Match[1] + CallsignRec.Area;
              CallsignRec.Suffix           := Brx.Match[6];
              exit;
              end
          end
        else
          begin
          if c1 or c2 then
            begin
            if c1 then
              s := s1
            else
              s := s2;
              Brx.Expression := '^'+gCallsign+'$';
              Brx.Exec(s);
              CallsignRec.OrgCallsign       := s1;
              CallsignRec.Area              := Copy(Brx.Match[2],1,1);
              CallsignRec.Prefix            := Brx.Match[1] + CallsignRec.Area;
              CallsignRec.Suffix            := Brx.Match[3];
              exit;
            end;
          end;
        end;
      end;
// JARL記念局・特別局    ex. '8J1T40A/7'
    t := '(8[JNM])([0-9])([A-Z0-9]+)';
    Brx.Expression := '^' + t + '$';
    if Brx.Exec(s) then
      begin
      CallsignRec.OrgCallsign := s;
      CallsignRec.Area        := Brx.Match[2];
      CallsignRec.Prefix      := Brx.Match[1] + Brx.Match[2];
      CallsignRec.Suffix      := '';
      exit;
      end;
    Brx.Expression := '^' + t + '/'+(gArea)+'$';
    if Brx.Exec(s) then
      begin
      CallsignRec.OrgCallsign := Brx.Match[1] + Brx.Match[2] + Brx.Match[3];
      CallsignRec.Area        := Brx.Match[4];
      CallsignRec.Prefix      := Brx.Match[1] + Brx.Match[2];
      CallsignRec.Suffix      := '';
      exit;
      end;
// 'P5RS7' '9M9/CCL' 'JY1' 'BW2000' などは判断できない
      CallsignRec.OrgCallsign := CallsignRec.Callsign;
      CallsignRec.Area        := '';
      CallsignRec.Prefix      := '';
      CallsignRec.Suffix      := '';
      CallsignRec.result      := false;
  finally
    FreeAndNil(Brx);
    result      := CallsignRec.result;
  end;
end;

end.




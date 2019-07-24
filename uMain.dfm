object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'eQslBase'
  ClientHeight = 644
  ClientWidth = 1128
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  PopupMode = pmAuto
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 620
    Width = 1128
    Height = 24
    Panels = <>
    SimplePanel = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1128
    Height = 49
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 1
    DesignSize = (
      1128
      49)
    object btnDownload: TButton
      Left = 8
      Top = 8
      Width = 65
      Height = 33
      Action = actDownload
      TabOrder = 0
    end
    object btnExit: TButton
      Left = 1048
      Top = 8
      Width = 65
      Height = 33
      Action = actExit
      Anchors = [akTop, akRight]
      TabOrder = 5
    end
    object btnLogin: TButton
      Left = 977
      Top = 8
      Width = 65
      Height = 33
      Action = actLogin_out
      Anchors = [akTop, akRight]
      TabOrder = 7
    end
    object btnPrint: TButton
      Left = 371
      Top = 8
      Width = 65
      Height = 33
      Action = actPrint
      TabOrder = 4
    end
    object btnFile: TButton
      Left = 300
      Top = 8
      Width = 65
      Height = 33
      Action = actArchive
      TabOrder = 3
    end
    object cmbSelect: TComboBox
      Left = 79
      Top = 14
      Width = 144
      Height = 21
      TabOrder = 1
      Text = 'ALL CLEAR'
      Items.Strings = (
        'ALL CLEAR'
        'ALL DATA'
        'MATCH DATA'
        'NO MATCH DATA'
        'NEW STATION ONLY'
        'NEW JCA ONLY')
    end
    object btnMarking: TButton
      Left = 229
      Top = 8
      Width = 65
      Height = 33
      Action = actMarking
      TabOrder = 2
    end
    object btnExport: TButton
      Left = 442
      Top = 8
      Width = 65
      Height = 33
      Action = actExport
      TabOrder = 6
    end
    object cbxShowAllData: TCheckBox
      Left = 520
      Top = 16
      Width = 161
      Height = 17
      Caption = 'Show all data'
      TabOrder = 8
      OnClick = cbxShowAllDataClick
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 55
    Width = 1108
    Height = 266
    Caption = 'Panel2'
    TabOrder = 2
    object Panel21: TPanel
      Left = 1
      Top = 1
      Width = 1106
      Height = 42
      Align = alTop
      Caption = 'Panel21'
      TabOrder = 0
      DesignSize = (
        1106
        42)
      object DBNavigator1: TDBNavigator
        Left = 790
        Top = 0
        Width = 292
        Height = 33
        DataSource = dsEQSL
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Anchors = [akTop, akRight]
        TabOrder = 0
      end
      object Panel4: TPanel
        Left = 24
        Top = 8
        Width = 233
        Height = 28
        BevelOuter = bvNone
        Caption = 'Panel22'
        Enabled = False
        TabOrder = 1
        object edtRecordNo: TLabeledEdit
          Left = 64
          Top = 2
          Width = 97
          Height = 21
          Alignment = taCenter
          EditLabel.Width = 34
          EditLabel.Height = 13
          EditLabel.Caption = 'Record'
          LabelPosition = lpLeft
          LabelSpacing = 5
          TabOrder = 0
        end
      end
    end
    object Panel22: TPanel
      Left = 1
      Top = 43
      Width = 1106
      Height = 222
      Align = alClient
      Caption = 'Panel22'
      TabOrder = 1
      object DBGrid1: TDBGrid
        Left = 88
        Top = 6
        Width = 969
        Height = 193
        DataSource = dsEQSL
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = DBGrid1CellClick
        OnDrawColumnCell = DBGrid1DrawColumnCell
        Columns = <
          item
            Expanded = False
            FieldName = 'DATAKEY'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CALLSIGN'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ORGCALLSIGN'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ONDATETIME'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BAND'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BAND_M'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MODE'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SUFFIX'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'GridLoc'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'QslMsg'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NUM'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MATCH'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NEWSTATION'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NEWJCA'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ARCHIVED'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PRINTED'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ISNEW'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ISMARK'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DOWNLOADDATE'
            Visible = True
          end>
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 332
    Width = 1128
    Height = 288
    Align = alBottom
    Caption = 'Panel3'
    TabOrder = 3
    object Memo1: TMemo
      Left = 0
      Top = -5
      Width = 1080
      Height = 257
      Lines.Strings = (
        'Memo1')
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 216
    Top = 152
  end
  object PrintDialog1: TPrintDialog
    Left = 280
    Top = 152
  end
  object dbEQSLBase: TIBDatabase
    DatabaseName = 'C:\LogBase Projects\eQslBase V1.00\eQSLBase.FDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'Password=masterkey'
      'lc_ctype=UTF8')
    LoginPrompt = False
    ServerType = 'IBServer'
    TraceFlags = [tfQPrepare, tfQExecute, tfQFetch, tfError, tfStmt, tfConnect, tfTransact, tfBlob, tfService, tfMisc]
    Left = 40
    Top = 336
  end
  object dbLogBase: TIBDatabase
    DatabaseName = 'C:\LogBase Projects\eQslBase V1.00\LOGBASE.FDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'Password=masterkey')
    LoginPrompt = False
    DefaultTransaction = trnLogBase
    ServerType = 'IBServer'
    Left = 464
    Top = 344
  end
  object trnLogBase: TIBTransaction
    DefaultDatabase = dbLogBase
    DefaultAction = TACommitRetaining
    Params.Strings = (
      'concurrency'
      'nowait')
    AutoStopAction = saCommitRetaining
    Left = 464
    Top = 408
  end
  object trnEQSLBase: TIBTransaction
    DefaultDatabase = dbEQSLBase
    DefaultAction = TACommitRetaining
    Params.Strings = (
      'concurrency'
      'nowait')
    AutoStopAction = saCommitRetaining
    Left = 112
    Top = 336
  end
  object dsEQSL: TDataSource
    DataSet = qryEQsl
    Left = 40
    Top = 456
  end
  object ActionManager1: TActionManager
    Left = 128
    Top = 152
    StyleName = 'Platform Default'
    object actLogin_out: TAction
      Caption = 'Login'
      OnExecute = actLogin_outExecute
    end
    object actExit: TAction
      Caption = 'Exit'
      OnExecute = actExitExecute
    end
    object actDownload: TAction
      Caption = 'Download'
      OnExecute = actDownloadExecute
    end
    object actArchive: TAction
      Caption = 'Archive'
      OnExecute = actArchiveExecute
    end
    object actPrint: TAction
      Caption = 'Print'
      OnExecute = actPrintExecute
    end
    object actMarking: TAction
      Caption = 'Marking'
      OnExecute = actMarkingExecute
    end
    object actExport: TAction
      Caption = 'Export'
      OnExecute = actExportExecute
    end
    object actAllCleare: TAction
      Caption = 'All Cleare'
      OnExecute = actAllCleareExecute
    end
    object actAbout: TAction
      Caption = 'About'
      OnExecute = actAboutExecute
    end
    object actOptions: TAction
      Caption = 'Options'
      OnExecute = actOptionsExecute
    end
  end
  object sqlSelectEQsl: TIBQuery
    Database = dbEQSLBase
    Transaction = trnEQSLBase
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'SELECT DATAKEY FROM EQSL '
      'WHERE DATAKEY Like :DATAKEY;')
    Left = 216
    Top = 480
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DATAKEY'
        ParamType = ptUnknown
      end>
  end
  object sqlQsoLogMatch1: TIBQuery
    Database = dbLogBase
    Transaction = trnLogBase
    AutoCalcFields = False
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'SELECT NUM, CALLSIGN, ONDATETIME, MODE, BAND, NETLOGRECV, QSLREC' +
        'V, QSLRECVDATE, GRIDLOC FROM QSOLOG '
      'WHERE CALLSIGN = :CALLSIGN AND MODE = :MODE AND BAND = :BAND'
      'AND ONDATETIME >= :FROMDATETIME and ONDATETIME <= :TODATETIME'
      'ORDER BY ABS(DATEDIFF(MINUTE, ONDATETIME,  :ONDATETIME));'
      '')
    UniDirectional = True
    Left = 560
    Top = 344
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CALLSIGN'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'MODE'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'BAND'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'FROMDATETIME'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'TODATETIME'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'ONDATETIME'
        ParamType = ptUnknown
      end>
  end
  object sqlQsoLogNewStation: TIBQuery
    Database = dbLogBase
    Transaction = trnLogBase
    AutoCalcFields = False
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'SELECT CALLSIGN, QSLRECV FROM QSOLOG '
      
        'WHERE (CALLSIGN = :CALLSIGN) AND (QSLRECV IS NOT NULL) AND (TRIM' +
        '(QSLRECV)<>'#39#39');'
      '')
    UniDirectional = True
    Left = 560
    Top = 408
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CALLSIGN'
        ParamType = ptUnknown
      end>
  end
  object sqlQsoLogNewJCA: TIBQuery
    Database = dbLogBase
    Transaction = trnLogBase
    AutoCalcFields = False
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'SELECT CALLSIGN, ONDATETIME, SUFFIX FROM QSOLOG '
      'WHERE SUFFIX = :SUFFIX AND QSLRECV IN ('#39'R'#39', '#39'E'#39')'
      'AND ONDATETIME >= :ONDATETIME;'
      '')
    UniDirectional = True
    Left = 560
    Top = 472
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'SUFFIX'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'ONDATETIME'
        ParamType = ptUnknown
      end>
  end
  object qryEQsl: TIBQuery
    Database = dbEQSLBase
    Transaction = trnEQSLBase
    AfterScroll = cdsEQslAfterScroll
    OnUpdateRecord = qryEQslUpdateRecord
    BufferChunks = 1000
    CachedUpdates = True
    ParamCheck = True
    UpdateObject = updEQsl
    Filtered = True
    Left = 40
    Top = 400
    object qryEQslDATAKEY: TIBStringField
      DisplayLabel = 'DataKey'
      FieldName = 'DATAKEY'
      Origin = '"EQSL"."DATAKEY"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
      Required = True
      Size = 48
    end
    object qryEQslCALLSIGN: TIBStringField
      DisplayLabel = 'Callsign'
      FieldName = 'CALLSIGN'
      Origin = '"EQSL"."CALLSIGN"'
      ReadOnly = True
      Size = 16
    end
    object qryEQslORGCALLSIGN: TIBStringField
      DisplayLabel = 'OrgCallsign'
      FieldName = 'ORGCALLSIGN'
      Origin = '"EQSL"."ORGCALLSIGN"'
      ReadOnly = True
      Size = 16
    end
    object qryEQslONDATETIME: TDateTimeField
      DisplayLabel = 'OnDateTime'
      FieldName = 'ONDATETIME'
      Origin = '"EQSL"."ONDATETIME"'
      ReadOnly = True
      OnGetText = cdsEQslONDATETIMEGetText
      DisplayFormat = 'YYYY-MM-DD HH:NN'
    end
    object qryEQslBAND: TLargeintField
      DisplayLabel = 'Band'
      FieldName = 'BAND'
      Origin = '"EQSL"."BAND"'
      ReadOnly = True
      OnGetText = cdsEQslBANDGetText
    end
    object qryEQslBAND_M: TIBStringField
      DisplayLabel = 'Band_M'
      FieldName = 'BAND_M'
      Origin = '"EQSL"."BAND_M"'
      ReadOnly = True
      Size = 10
    end
    object qryEQslMODE: TIBStringField
      DisplayLabel = 'Mode'
      FieldName = 'MODE'
      Origin = '"EQSL"."MODE"'
      ReadOnly = True
      Size = 10
    end
    object qryEQslSUFFIX: TIBStringField
      DisplayLabel = 'Suffix'
      FieldName = 'SUFFIX'
      Origin = '"EQSL"."SUFFIX"'
      ReadOnly = True
      Size = 10
    end
    object qryEQslGRIDLOC: TIBStringField
      FieldName = 'GridLoc'
      Origin = '"EQSL"."GRIDLOC"'
      ReadOnly = True
      Size = 6
    end
    object qryEQslQSLMSG: TIBStringField
      DisplayWidth = 100
      FieldName = 'QslMsg'
      Origin = '"EQSL"."QSLMSG"'
      ReadOnly = True
      Size = 240
    end
    object qryEQslNUM: TLargeintField
      DisplayLabel = 'Num'
      FieldName = 'NUM'
      Origin = '"EQSL"."NUM"'
      ReadOnly = True
    end
    object qryEQslMATCH: TSmallintField
      DisplayLabel = 'Match'
      FieldName = 'MATCH'
      Origin = '"EQSL"."MATCH"'
      ReadOnly = True
    end
    object qryEQslNEWSTATION: TSmallintField
      DisplayLabel = 'NewStation'
      FieldName = 'NEWSTATION'
      Origin = '"EQSL"."NEWSTATION"'
      ReadOnly = True
    end
    object qryEQslNEWJCA: TSmallintField
      DisplayLabel = 'NewJCA'
      FieldName = 'NEWJCA'
      Origin = '"EQSL"."NEWJCA"'
      ReadOnly = True
    end
    object qryEQslArchived: TSmallintField
      DisplayLabel = 'Archived'
      FieldName = 'ARCHIVED'
      Origin = '"EQSL"."ARCHIVED"'
      ReadOnly = True
    end
    object qryEQslPRINTED: TSmallintField
      DisplayLabel = 'Printed'
      FieldName = 'PRINTED'
      Origin = '"EQSL"."PRINTED"'
      ReadOnly = True
    end
    object qryEQslISNEW: TSmallintField
      DisplayLabel = 'isNew'
      FieldName = 'ISNEW'
      Origin = '"EQSL"."ISNEW"'
      ReadOnly = True
    end
    object qryEQslISMARK: TSmallintField
      DisplayLabel = 'isMark'
      FieldName = 'ISMARK'
      Origin = '"EQSL"."ISMARK"'
    end
    object qryEQslDOWNLOADDATE: TDateTimeField
      DisplayLabel = 'DownloadDate'
      FieldName = 'DOWNLOADDATE'
      Origin = '"EQSL"."DOWNLOADDATE"'
      ReadOnly = True
      DisplayFormat = 'YYYY-MM-DD HH:NN'
    end
    object qryEQslMYCALLSIGN: TWideStringField
      FieldName = 'MYCALLSIGN'
      Size = 16
    end
  end
  object updEQsl: TIBUpdateSQL
    ModifySQL.Strings = (
      'UPDATE EQSL SET NUM=:NUM, MATCH=:MATCH, '
      'NEWSTATION=:NEWSTATION, NEWJCA=:NEWJCA, '
      'ARCHIVED=:ARCHIVED, PRINTED=:PRINTED, ISMARK=:ISMARK'
      'WHERE DATAKEY = :DATAKEY;')
    InsertSQL.Strings = (
      
        'INSERT INTO EQSL(DATAKEY,  CALLSIGN, ORGCALLSIGN, ONDATETIME, BA' +
        'ND, BAND_M, MODE, SUFFIX, GRIDLOC, QSLMSG, NUM, MATCH, NEWSTATIO' +
        'N, NEWJCA, Archived, PRINTED, ISNEW, ISMARK, DOWNLOADDATE, MYCAL' +
        'LSIGN)'
      
        ' VALUES(:DATAKEY, :CALLSIGN, :ORGCALLSIGN, :ONDATETIME, :BAND, :' +
        'BAND_M, :MODE, :SUFFIX, :GRIDLOC, :QSLMSG, :NUM, :MATCH, :NEWSTA' +
        'TION, :NEWJCA, :Archived, :PRINTED, :ISNEW, :ISMARK, :DOWNLOADDA' +
        'TE, :MYCALLSIGN);')
    Left = 112
    Top = 400
  end
  object PopupMenu1: TPopupMenu
    Left = 376
    Top = 152
    object Options1: TMenuItem
      Action = actOptions
    end
    object About1: TMenuItem
      Action = actAbout
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object AllCleare1: TMenuItem
      Action = actAllCleare
    end
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 464
    Top = 152
  end
  object sqlQsoLogMatch2: TIBQuery
    Database = dbLogBase
    Transaction = trnLogBase
    AutoCalcFields = False
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'SELECT NUM, CALLSIGN, ONDATETIME, MODE, BAND, NETLOGRECV, QSLREC' +
        'V, QSLRECVDATE, GRIDLOC FROM QSOLOG '
      
        'WHERE ORGCALLSIGN = :ORGCALLSIGN AND MODE = :MODE AND BAND = :BA' +
        'ND'
      'AND ONDATETIME >= :FROMDATETIME and ONDATETIME <= :TODATETIME'
      'ORDER BY ABS(DATEDIFF(MINUTE, ONDATETIME,  :ONDATETIME));'
      '')
    UniDirectional = True
    Left = 672
    Top = 344
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ORGCALLSIGN'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'MODE'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'BAND'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'FROMDATETIME'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'TODATETIME'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'ONDATETIME'
        ParamType = ptUnknown
      end>
  end
  object updQsoLog: TIBSQL
    Database = dbLogBase
    SQL.Strings = (
      'UPDATE QSOLOG SET QSLRECV=:QSLRECV, QSLRECVDATE=:QSLRECVDATE, '
      'NETLOGRECV=:NETLOGRECV, GRIDLOC=:GRIDLOC '
      'WHERE NUM=:NUM;')
    Transaction = trnLogBase
    Left = 768
    Top = 416
  end
  object sqlQsoLogMatch3: TIBQuery
    Database = dbLogBase
    Transaction = trnLogBase
    AutoCalcFields = False
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      
        'SELECT NUM, CALLSIGN, ONDATETIME, MODE, BAND, NETLOGRECV, QSLREC' +
        'V, QSLRECVDATE, GRIDLOC FROM QSOLOG '
      'WHERE NUM = :NUM;'
      '')
    UniDirectional = True
    Left = 768
    Top = 344
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'NUM'
        ParamType = ptUnknown
      end>
  end
end

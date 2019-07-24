object Engine: TEngine
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 701
  Width = 658
  object dsQsoStatus: TDataSource
    DataSet = cdsQsoStatus
    Left = 336
    Top = 272
  end
  object dsFindRegion: TDataSource
    DataSet = cdsFindRegion
    Left = 192
    Top = 632
  end
  object dsQso: TDataSource
    DataSet = cdsQso
    Left = 32
    Top = 272
  end
  object dbLogBase: TIBDatabase
    DatabaseName = 'C:\LogBase Projects\LogBase V1.1.0\LOGBASE.FDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'Password=masterkey')
    LoginPrompt = False
    DefaultTransaction = trnLogBase
    ServerType = 'IBServer'
    Left = 32
    Top = 32
  end
  object tblQsoLog2: TIBTable
    Database = dbLogBase
    Transaction = trnLogBase
    AutoCalcFields = False
    BufferChunks = 1000000
    CachedUpdates = False
    FieldDefs = <
      item
        Name = 'NUM'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'CALLSIGN'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'ORGCALLSIGN'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'CQ'
        DataType = ftSmallint
      end
      item
        Name = 'SWL'
        DataType = ftSmallint
      end
      item
        Name = 'ONDATETIME'
        DataType = ftDateTime
      end
      item
        Name = 'OFFDATETIME'
        DataType = ftDateTime
      end
      item
        Name = 'FREQ'
        DataType = ftLargeint
      end
      item
        Name = 'BAND'
        DataType = ftLargeint
      end
      item
        Name = 'RECVFREQ'
        DataType = ftLargeint
      end
      item
        Name = 'RECVBAND'
        DataType = ftLargeint
      end
      item
        Name = 'MODE'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ROUTE'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'REPEATER'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'HISREPORT'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYREPORT'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'NAME'
        DataType = ftWideString
        Size = 32
      end
      item
        Name = 'MEMO'
        DataType = ftWideString
        Size = 256
      end
      item
        Name = 'QSL'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'QSLSEND'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'QSLRECV'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'QSLSENDDATE'
        DataType = ftDate
      end
      item
        Name = 'QSLRECVDATE'
        DataType = ftDate
      end
      item
        Name = 'QSLMANAGER'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'NETLOGSEND'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'NETLOGRECV'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'PREFIX'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'SUFFIX'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'COUNTRY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'REGION'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ENTITY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'GRIDLOC'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'CONTINENT'
        DataType = ftWideString
        Size = 2
      end
      item
        Name = 'ITUZONE'
        DataType = ftWideString
        Size = 2
      end
      item
        Name = 'CQZONE'
        DataType = ftWideString
        Size = 2
      end
      item
        Name = 'IOTA'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'ETC1'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC2'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC3'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC4'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC5'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYCALLSIGN'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'MYCOUNTRY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYREGION'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYENTITY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYGRIDLOC'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'MYRIG'
        DataType = ftWideString
        Size = 32
      end
      item
        Name = 'MYANT'
        DataType = ftWideString
        Size = 32
      end
      item
        Name = 'MYMEMO'
        DataType = ftWideString
        Size = 128
      end>
    IndexDefs = <
      item
        Name = 'PK_QSOLOG'
        Fields = 'NUM'
        Options = [ixUnique]
      end
      item
        Name = 'IDX_REGION'
        Fields = 'COUNTRY;REGION'
      end>
    IndexName = 'PK_QSOLOG'
    StoreDefs = True
    TableName = 'QSOLOG'
    UniDirectional = True
    Left = 112
    Top = 104
  end
  object trnLogBase: TIBTransaction
    DefaultDatabase = dbLogBase
    DefaultAction = TACommitRetaining
    Params.Strings = (
      'concurrency'
      'nowait')
    AutoStopAction = saCommitRetaining
    Left = 112
    Top = 32
  end
  object tblQso2: TIBTable
    Database = dbLogBase
    Transaction = trnLogBase
    BufferChunks = 1000
    CachedUpdates = False
    FieldDefs = <
      item
        Name = 'NUM'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'CALLSIGN'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'ORGCALLSIGN'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'CQ'
        DataType = ftSmallint
      end
      item
        Name = 'SWL'
        DataType = ftSmallint
      end
      item
        Name = 'ONDATETIME'
        DataType = ftDateTime
      end
      item
        Name = 'OFFDATETIME'
        DataType = ftDateTime
      end
      item
        Name = 'FREQ'
        DataType = ftLargeint
      end
      item
        Name = 'BAND'
        DataType = ftLargeint
      end
      item
        Name = 'RECVFREQ'
        DataType = ftLargeint
      end
      item
        Name = 'RECVBAND'
        DataType = ftLargeint
      end
      item
        Name = 'MODE'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ROUTE'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'REPEATER'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'HISREPORT'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYREPORT'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'NAME'
        DataType = ftWideString
        Size = 32
      end
      item
        Name = 'MEMO'
        DataType = ftWideString
        Size = 256
      end
      item
        Name = 'QSL'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'QSLSEND'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'QSLRECV'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'QSLSENDDATE'
        DataType = ftDate
      end
      item
        Name = 'QSLRECVDATE'
        DataType = ftDate
      end
      item
        Name = 'QSLMANAGER'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'NETLOGSEND'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'NETLOGRECV'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'PREFIX'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'SUFFIX'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'COUNTRY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'REGION'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ENTITY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'GRIDLOC'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'CONTINENT'
        DataType = ftWideString
        Size = 2
      end
      item
        Name = 'ITUZONE'
        DataType = ftWideString
        Size = 2
      end
      item
        Name = 'CQZONE'
        DataType = ftWideString
        Size = 2
      end
      item
        Name = 'IOTA'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'ETC1'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC2'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC3'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC4'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'ETC5'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYCALLSIGN'
        DataType = ftWideString
        Size = 16
      end
      item
        Name = 'MYCOUNTRY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYREGION'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYENTITY'
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MYGRIDLOC'
        DataType = ftWideString
        Size = 6
      end
      item
        Name = 'MYRIG'
        DataType = ftWideString
        Size = 32
      end
      item
        Name = 'MYANT'
        DataType = ftWideString
        Size = 32
      end
      item
        Name = 'MYMEMO'
        DataType = ftWideString
        Size = 128
      end>
    IndexDefs = <
      item
        Name = 'PK_QSO'
        Fields = 'NUM'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'QSO'
    UniDirectional = False
    Left = 32
    Top = 104
  end
  object qryCommon: TIBQuery
    Database = dbReference
    Transaction = trnReference
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 264
    Top = 464
  end
  object qryQsoLog: TIBQuery
    Database = dbLogBase
    Transaction = trnLogBase
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      '')
    Left = 432
    Top = 104
  end
  object qryFindRegion: TIBQuery
    Database = dbReference
    Transaction = trnReference
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      '')
    Left = 192
    Top = 464
  end
  object qryRegion: TIBQuery
    Database = dbReference
    Transaction = trnReference
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select COUNTRY, REGION, NAME, TODATE from REGION_V;')
    Left = 112
    Top = 464
  end
  object qryEntity: TIBQuery
    Database = dbReference
    Transaction = trnReference
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'SELECT  ENTITY, NAME FROM ENTITY;')
    Left = 40
    Top = 464
  end
  object cdsEntity: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspEntity'
    Left = 40
    Top = 576
    object cdsEntityENTITY: TWideStringField
      FieldName = 'ENTITY'
      Origin = '"ENTITY"."ENTITY"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Size = 10
    end
    object cdsEntityNAME: TWideStringField
      FieldName = 'NAME'
      Origin = '"ENTITY"."NAME"'
      Size = 32
    end
  end
  object dspEntity: TDataSetProvider
    DataSet = qryEntity
    Left = 40
    Top = 520
  end
  object dspRegion: TDataSetProvider
    DataSet = qryRegion
    Left = 112
    Top = 520
  end
  object cdsRegion: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspRegion'
    Left = 112
    Top = 576
  end
  object dsQsoLogSel: TDataSource
    DataSet = cdsQsoLogSel
    Left = 176
    Top = 272
  end
  object dsQsoLog: TDataSource
    DataSet = cdsQsoLog
    OnStateChange = dsQsoLogStateChange
    Left = 112
    Top = 272
  end
  object cdsFindRegion: TClientDataSet
    Aggregates = <>
    Filter = 'ToDate is null or ToDate >='#39'2005/01/01'#39
    Filtered = True
    FilterOptions = [foCaseInsensitive]
    Params = <>
    ProviderName = 'dspFindRegion'
    ReadOnly = True
    Left = 192
    Top = 576
  end
  object dspFindRegion: TDataSetProvider
    DataSet = qryFindRegion
    Left = 192
    Top = 520
  end
  object cdsQsoStatus: TClientDataSet
    Aggregates = <>
    AutoCalcFields = False
    Filtered = True
    FieldDefs = <
      item
        Name = 'CATEGORY'
        Attributes = [faRequired]
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'KEY'
        Attributes = [faRequired]
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'MODELEVEL'
        Attributes = [faRequired]
        DataType = ftSmallint
      end
      item
        Name = 'MODE'
        Attributes = [faRequired]
        DataType = ftWideString
        Size = 10
      end
      item
        Name = 'NAME'
        DataType = ftWideString
        Size = 32
      end
      item
        Name = 'KEYLEVEL'
        DataType = ftSmallint
      end
      item
        Name = 'BAND00'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND01'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND02'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND03'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND04'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND05'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND06'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND07'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND08'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND09'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND10'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND11'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND12'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND13'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND14'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end
      item
        Name = 'BAND15'
        Attributes = [faFixed]
        DataType = ftWideString
        Size = 1
      end>
    IndexDefs = <>
    IndexFieldNames = 'CATEGORY;KEY;MODE'
    Params = <>
    ProviderName = 'dspQsoStatus'
    StoreDefs = True
    Left = 336
    Top = 208
    object cdsQsoStatusCATEGORY: TWideStringField
      FieldName = 'CATEGORY'
      Required = True
      Size = 10
    end
    object cdsQsoStatusKEY: TWideStringField
      FieldName = 'KEY'
      Required = True
      Size = 10
    end
    object cdsQsoStatusMODELEVEL: TSmallintField
      FieldName = 'MODELEVEL'
      Required = True
    end
    object cdsQsoStatusMODE: TWideStringField
      FieldName = 'MODE'
      Required = True
      Size = 10
    end
    object cdsQsoStatusNAME: TWideStringField
      FieldName = 'NAME'
      Size = 32
    end
    object cdsQsoStatusKEYLEVEL: TSmallintField
      FieldName = 'KEYLEVEL'
    end
    object cdsQsoStatusBAND00: TWideStringField
      FieldName = 'BAND00'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND01: TWideStringField
      FieldName = 'BAND01'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND02: TWideStringField
      FieldName = 'BAND02'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND03: TWideStringField
      FieldName = 'BAND03'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND04: TWideStringField
      FieldName = 'BAND04'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND05: TWideStringField
      FieldName = 'BAND05'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND06: TWideStringField
      FieldName = 'BAND06'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND07: TWideStringField
      FieldName = 'BAND07'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND08: TWideStringField
      FieldName = 'BAND08'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND09: TWideStringField
      FieldName = 'BAND09'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND10: TWideStringField
      FieldName = 'BAND10'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND11: TWideStringField
      FieldName = 'BAND11'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND12: TWideStringField
      FieldName = 'BAND12'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND13: TWideStringField
      FieldName = 'BAND13'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND15: TWideStringField
      FieldName = 'BAND15'
      FixedChar = True
      Size = 1
    end
    object cdsQsoStatusBAND14: TWideStringField
      FieldName = 'BAND14'
      FixedChar = True
      Size = 1
    end
  end
  object cdsQso: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspQso'
    OnNewRecord = cdsQsoNewRecord
    Left = 32
    Top = 216
    object cdsQsoNUM: TIntegerField
      FieldName = 'NUM'
      Required = True
    end
    object cdsQsoCALLSIGN: TWideStringField
      FieldName = 'CALLSIGN'
      OnChange = cdsQsoCALLSIGNChange
      OnValidate = cdsQsoCALLSIGNValidate
      Size = 16
    end
    object cdsQsoORGCALLSIGN: TWideStringField
      FieldName = 'ORGCALLSIGN'
      OnChange = cdsQsoORGCALLSIGNChange
      OnValidate = cdsQsoORGCALLSIGNValidate
      Size = 16
    end
    object cdsQsoCQ: TSmallintField
      FieldName = 'CQ'
      OnChange = cdsQsoCQChange
    end
    object cdsQsoSWL: TSmallintField
      FieldName = 'SWL'
      OnChange = cdsQsoSWLChange
    end
    object cdsQsoONDATETIME: TDateTimeField
      FieldName = 'ONDATETIME'
      OnChange = cdsQsoONDATETIMEChange
      OnValidate = cdsQsoONDATETIMEValidate
    end
    object cdsQsoOFFDATETIME: TDateTimeField
      FieldName = 'OFFDATETIME'
      OnChange = cdsQsoOFFDATETIMEChange
      OnValidate = cdsQsoOFFDATETIMEValidate
    end
    object cdsQsoFREQ: TLargeintField
      FieldName = 'FREQ'
      OnChange = cdsQsoFREQChange
      OnValidate = cdsQsoFREQValidate
    end
    object cdsQsoBAND: TLargeintField
      FieldName = 'BAND'
    end
    object cdsQsoRECVFREQ: TLargeintField
      FieldName = 'RECVFREQ'
      OnChange = cdsQsoRECVFREQChange
      OnValidate = cdsQsoRECVFREQValidate
    end
    object cdsQsoRECVBAND: TLargeintField
      FieldName = 'RECVBAND'
    end
    object cdsQsoMODE: TWideStringField
      FieldName = 'MODE'
      OnChange = cdsQsoMODEChange
      OnValidate = cdsQsoMODEValidate
      Size = 10
    end
    object cdsQsoROUTE: TWideStringField
      FieldName = 'ROUTE'
      OnChange = cdsQsoROUTEChange
      OnValidate = cdsQsoROUTEValidate
      Size = 10
    end
    object cdsQsoREPEATER: TWideStringField
      FieldName = 'REPEATER'
      OnChange = cdsQsoREPEATERChange
      OnValidate = cdsQsoREPEATERValidate
      Size = 10
    end
    object cdsQsoHISREPORT: TWideStringField
      FieldName = 'HISREPORT'
      OnChange = cdsQsoHISREPORTChange
      OnValidate = cdsQsoHISREPORTValidate
      Size = 10
    end
    object cdsQsoMYREPORT: TWideStringField
      FieldName = 'MYREPORT'
      OnChange = cdsQsoMYREPORTChange
      OnValidate = cdsQsoMYREPORTValidate
      Size = 10
    end
    object cdsQsoNAME: TWideStringField
      FieldName = 'NAME'
      OnChange = cdsQsoNAMEChange
      Size = 32
    end
    object cdsQsoMEMO: TWideStringField
      FieldName = 'MEMO'
      OnChange = cdsQsoMEMOChange
      Size = 256
    end
    object cdsQsoQSL: TWideStringField
      FieldName = 'QSL'
      OnChange = cdsQsoQSLChange
      OnValidate = cdsQsoQSLValidate
      Size = 1
    end
    object cdsQsoQSLSEND: TWideStringField
      FieldName = 'QSLSEND'
      OnChange = cdsQsoQSLSENDChange
      OnValidate = cdsQsoQSLSENDValidate
      Size = 1
    end
    object cdsQsoQSLRECV: TWideStringField
      FieldName = 'QSLRECV'
      OnChange = cdsQsoQSLRECVChange
      OnValidate = cdsQsoQSLRECVValidate
      Size = 1
    end
    object cdsQsoQSLSENDDATE: TDateField
      FieldName = 'QSLSENDDATE'
      OnChange = cdsQsoQSLSENDDATEChange
      OnValidate = cdsQsoQSLSENDDATEValidate
    end
    object cdsQsoQSLRECVDATE: TDateField
      FieldName = 'QSLRECVDATE'
      OnChange = cdsQsoQSLSENDDATEChange
      OnValidate = cdsQsoQSLSENDDATEValidate
    end
    object cdsQsoQSLMANAGER: TWideStringField
      FieldName = 'QSLMANAGER'
      OnChange = cdsQsoQSLMANAGERChange
      Size = 16
    end
    object cdsQsoNETLOGSEND: TWideStringField
      FieldName = 'NETLOGSEND'
      OnChange = cdsQsoNETLOGSENDChange
      Size = 16
    end
    object cdsQsoNETLOGRECV: TWideStringField
      FieldName = 'NETLOGRECV'
      OnChange = cdsQsoNETLOGRECVChange
      Size = 16
    end
    object cdsQsoPREFIX: TWideStringField
      FieldName = 'PREFIX'
      OnChange = cdsQsoPREFIXChange
      OnValidate = cdsQsoPREFIXValidate
      Size = 10
    end
    object cdsQsoSUFFIX: TWideStringField
      FieldName = 'SUFFIX'
      OnChange = cdsQsoSUFFIXChange
      OnValidate = cdsQsoSUFFIXValidate
      Size = 10
    end
    object cdsQsoCOUNTRY: TWideStringField
      FieldName = 'COUNTRY'
      OnChange = cdsQsoCOUNTRYChange
      OnValidate = cdsQsoCOUNTRYValidate
      Size = 10
    end
    object cdsQsoREGION: TWideStringField
      FieldName = 'REGION'
      OnChange = cdsQsoREGIONChange
      OnValidate = cdsQsoREGIONValidate
      Size = 10
    end
    object cdsQsoENTITY: TWideStringField
      FieldName = 'ENTITY'
      OnChange = cdsQsoENTITYChange
      OnValidate = cdsQsoENTITYValidate
      Size = 10
    end
    object cdsQsoGRIDLOC: TWideStringField
      FieldName = 'GRIDLOC'
      OnChange = cdsQsoGRIDLOCChange
      OnValidate = cdsQsoGRIDLOCValidate
      Size = 6
    end
    object cdsQsoCONTINENT: TWideStringField
      FieldName = 'CONTINENT'
      OnChange = cdsQsoCONTINENTChange
      OnValidate = cdsQsoCONTINENTValidate
      Size = 2
    end
    object cdsQsoITUZONE: TWideStringField
      FieldName = 'ITUZONE'
      OnChange = cdsQsoITUZONEChange
      OnValidate = cdsQsoITUZONEValidate
      Size = 2
    end
    object cdsQsoCQZONE: TWideStringField
      FieldName = 'CQZONE'
      OnChange = cdsQsoCQZONEChange
      OnValidate = cdsQsoCQZONEValidate
      Size = 2
    end
    object cdsQsoIOTA: TWideStringField
      FieldName = 'IOTA'
      OnChange = cdsQsoIOTAChange
      OnValidate = cdsQsoIOTAValidate
      Size = 6
    end
    object cdsQsoETC1: TWideStringField
      FieldName = 'ETC1'
      OnChange = cdsQsoETC1Change
      OnValidate = cdsQsoETC1Validate
      Size = 10
    end
    object cdsQsoETC2: TWideStringField
      FieldName = 'ETC2'
      OnChange = cdsQsoETC2Change
      OnValidate = cdsQsoETC2Validate
      Size = 10
    end
    object cdsQsoETC3: TWideStringField
      FieldName = 'ETC3'
      OnChange = cdsQsoETC3Change
      OnValidate = cdsQsoETC3Validate
      Size = 10
    end
    object cdsQsoETC4: TWideStringField
      FieldName = 'ETC4'
      OnChange = cdsQsoETC4Change
      OnValidate = cdsQsoETC4Validate
      Size = 10
    end
    object cdsQsoETC5: TWideStringField
      FieldName = 'ETC5'
      OnChange = cdsQsoETC5Change
      OnValidate = cdsQsoETC5Validate
      Size = 10
    end
    object cdsQsoMYCALLSIGN: TWideStringField
      FieldName = 'MYCALLSIGN'
      Size = 16
    end
    object cdsQsoMYCOUNTRY: TWideStringField
      FieldName = 'MYCOUNTRY'
      Size = 10
    end
    object cdsQsoMYREGION: TWideStringField
      FieldName = 'MYREGION'
      Size = 10
    end
    object cdsQsoMYENTITY: TWideStringField
      FieldName = 'MYENTITY'
      Size = 10
    end
    object cdsQsoMYGRIDLOC: TWideStringField
      FieldName = 'MYGRIDLOC'
      Size = 6
    end
    object cdsQsoMYRIG: TWideStringField
      FieldName = 'MYRIG'
      Size = 32
    end
    object cdsQsoMYANT: TWideStringField
      FieldName = 'MYANT'
      Size = 32
    end
    object cdsQsoMYMEMO: TWideStringField
      FieldName = 'MYMEMO'
      Size = 128
    end
  end
  object dspQso: TDataSetProvider
    DataSet = tblQso
    Left = 32
    Top = 160
  end
  object dspQsoLog: TDataSetProvider
    DataSet = tblQsoLog
    Left = 112
    Top = 160
  end
  object cdsQsoLog: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspQsoLog'
    BeforePost = cdsQsoLogBeforePost
    AfterPost = cdsQsoLogAfterPost
    BeforeDelete = cdsQsoLogBeforeDelete
    OnCalcFields = cdsQsoLogCalcFields
    Left = 112
    Top = 216
    object cdsQsoLogNUM: TIntegerField
      FieldName = 'NUM'
      Origin = '"QSOLOG"."NUM"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsQsoLogCALLSIGN: TWideStringField
      FieldName = 'CALLSIGN'
      Origin = '"QSOLOG"."CALLSIGN"'
      Size = 16
    end
    object cdsQsoLogORGCALLSIGN: TWideStringField
      FieldName = 'ORGCALLSIGN'
      Origin = '"QSOLOG"."ORGCALLSIGN"'
      Size = 16
    end
    object cdsQsoLogCQ: TSmallintField
      FieldName = 'CQ'
      Origin = '"QSOLOG"."CQ"'
      OnGetText = cdsQsoLogCQGetText
    end
    object cdsQsoLogSWL: TSmallintField
      FieldName = 'SWL'
      Origin = '"QSOLOG"."SWL"'
    end
    object cdsQsoLogONDATETIME: TDateTimeField
      FieldName = 'ONDATETIME'
      Origin = '"QSOLOG"."ONDATETIME"'
      OnGetText = cdsQsoLogONDATETIMEGetText
    end
    object cdsQsoLogOFFDATETIME: TDateTimeField
      FieldName = 'OFFDATETIME'
      Origin = '"QSOLOG"."OFFDATETIME"'
      OnGetText = cdsQsoLogONDATETIMEGetText
    end
    object cdsQsoLogFREQ: TLargeintField
      FieldName = 'FREQ'
      Origin = '"QSOLOG"."FREQ"'
      OnGetText = cdsQsoLogFREQGetText
    end
    object cdsQsoLogBAND: TLargeintField
      FieldName = 'BAND'
      Origin = '"QSOLOG"."BAND"'
      OnGetText = cdsQsoLogFREQGetText
    end
    object cdsQsoLogRECVFREQ: TLargeintField
      FieldName = 'RECVFREQ'
      Origin = '"QSOLOG"."RECVFREQ"'
      OnGetText = cdsQsoLogFREQGetText
    end
    object cdsQsoLogRECVBAND: TLargeintField
      FieldName = 'RECVBAND'
      Origin = '"QSOLOG"."RECVBAND"'
      OnGetText = cdsQsoLogFREQGetText
    end
    object cdsQsoLogMODE: TWideStringField
      FieldName = 'MODE'
      Origin = '"QSOLOG"."MODE"'
      Size = 10
    end
    object cdsQsoLogROUTE: TWideStringField
      FieldName = 'ROUTE'
      Origin = '"QSOLOG"."ROUTE"'
      Size = 10
    end
    object cdsQsoLogREPEATER: TWideStringField
      FieldName = 'REPEATER'
      Origin = '"QSOLOG"."REPEATER"'
      Size = 10
    end
    object cdsQsoLogHISREPORT: TWideStringField
      FieldName = 'HISREPORT'
      Origin = '"QSOLOG"."HISREPORT"'
      Size = 10
    end
    object cdsQsoLogMYREPORT: TWideStringField
      FieldName = 'MYREPORT'
      Origin = '"QSOLOG"."MYREPORT"'
      Size = 10
    end
    object cdsQsoLogNAME: TWideStringField
      FieldName = 'NAME'
      Origin = '"QSOLOG"."NAME"'
      Size = 32
    end
    object cdsQsoLogMEMO: TWideStringField
      FieldName = 'MEMO'
      Origin = '"QSOLOG"."MEMO"'
      Size = 256
    end
    object cdsQsoLogQSL: TWideStringField
      FieldName = 'QSL'
      Origin = '"QSOLOG"."QSL"'
      Size = 1
    end
    object cdsQsoLogQSLSEND: TWideStringField
      FieldName = 'QSLSEND'
      Origin = '"QSOLOG"."QSLSEND"'
      Size = 1
    end
    object cdsQsoLogQSLRECV: TWideStringField
      FieldName = 'QSLRECV'
      Origin = '"QSOLOG"."QSLRECV"'
      Size = 1
    end
    object cdsQsoLogQSLSENDDATE: TDateField
      FieldName = 'QSLSENDDATE'
      Origin = '"QSOLOG"."QSLSENDDATE"'
    end
    object cdsQsoLogQSLRECVDATE: TDateField
      FieldName = 'QSLRECVDATE'
      Origin = '"QSOLOG"."QSLRECVDATE"'
    end
    object cdsQsoLogQSLMANAGER: TWideStringField
      FieldName = 'QSLMANAGER'
      Origin = '"QSOLOG"."QSLMANAGER"'
      Size = 16
    end
    object cdsQsoLogNETLOGSEND: TWideStringField
      FieldName = 'NETLOGSEND'
      Size = 16
    end
    object cdsQsoLogNETLOGRECV: TWideStringField
      FieldName = 'NETLOGRECV'
      Size = 16
    end
    object cdsQsoLogPREFIX: TWideStringField
      FieldName = 'PREFIX'
      Origin = '"QSOLOG"."PREFIX"'
      Size = 10
    end
    object cdsQsoLogSUFFIX: TWideStringField
      FieldName = 'SUFFIX'
      Origin = '"QSOLOG"."SUFFIX"'
      Size = 10
    end
    object cdsQsoLogCOUNTRY: TWideStringField
      FieldName = 'COUNTRY'
      Origin = '"QSOLOG"."COUNTRY"'
      Size = 10
    end
    object cdsQsoLogREGION: TWideStringField
      FieldName = 'REGION'
      Origin = '"QSOLOG"."REGION"'
      Size = 10
    end
    object cdsQsoLogENTITY: TWideStringField
      FieldName = 'ENTITY'
      Origin = '"QSOLOG"."ENTITY"'
      Size = 10
    end
    object cdsQsoLogGRIDLOC: TWideStringField
      FieldName = 'GRIDLOC'
      Origin = '"QSOLOG"."GRIDLOC"'
      Size = 6
    end
    object cdsQsoLogCONTINENT: TWideStringField
      FieldName = 'CONTINENT'
      Origin = '"QSOLOG"."CONTINENT"'
      Size = 2
    end
    object cdsQsoLogITUZONE: TWideStringField
      FieldName = 'ITUZONE'
      Origin = '"QSOLOG"."ITUZONE"'
      Size = 2
    end
    object cdsQsoLogCQZONE: TWideStringField
      FieldName = 'CQZONE'
      Origin = '"QSOLOG"."CQZONE"'
      Size = 2
    end
    object cdsQsoLogIOTA: TWideStringField
      FieldName = 'IOTA'
      Origin = '"QSOLOG"."IOTA"'
      Size = 6
    end
    object cdsQsoLogETC1: TWideStringField
      FieldName = 'ETC1'
      Origin = '"QSOLOG"."ETC1"'
      Size = 10
    end
    object cdsQsoLogETC2: TWideStringField
      FieldName = 'ETC2'
      Origin = '"QSOLOG"."ETC2"'
      Size = 10
    end
    object cdsQsoLogETC3: TWideStringField
      FieldName = 'ETC3'
      Origin = '"QSOLOG"."ETC3"'
      Size = 10
    end
    object cdsQsoLogETC4: TWideStringField
      FieldName = 'ETC4'
      Origin = '"QSOLOG"."ETC4"'
      Size = 10
    end
    object cdsQsoLogETC5: TWideStringField
      FieldName = 'ETC5'
      Origin = '"QSOLOG"."ETC5"'
      Size = 10
    end
    object cdsQsoLogMYCALLSIGN: TWideStringField
      FieldName = 'MYCALLSIGN'
      Origin = '"QSOLOG"."MYCALLSIGN"'
      Size = 16
    end
    object cdsQsoLogMYCOUNTRY: TWideStringField
      FieldName = 'MYCOUNTRY'
      Origin = '"QSOLOG"."MYCOUNTRY"'
      Size = 10
    end
    object cdsQsoLogMYREGION: TWideStringField
      FieldName = 'MYREGION'
      Origin = '"QSOLOG"."MYREGION"'
      Size = 10
    end
    object cdsQsoLogMYENTITY: TWideStringField
      FieldName = 'MYENTITY'
      Origin = '"QSOLOG"."MYENTITY"'
      Size = 10
    end
    object cdsQsoLogMYGRIDLOC: TWideStringField
      FieldName = 'MYGRIDLOC'
      Origin = '"QSOLOG"."MYGRIDLOC"'
      Size = 6
    end
    object cdsQsoLogMYRIG: TWideStringField
      FieldName = 'MYRIG'
      Origin = '"QSOLOG"."MYRIG"'
      Size = 32
    end
    object cdsQsoLogMYANT: TWideStringField
      FieldName = 'MYANT'
      Origin = '"QSOLOG"."MYANT"'
      Size = 32
    end
    object cdsQsoLogMYMEMO: TWideStringField
      FieldName = 'MYMEMO'
      Origin = '"QSOLOG"."MYMEMO"'
      Size = 128
    end
    object cdsQsoLogQslG: TWideStringField
      FieldKind = fkInternalCalc
      FieldName = 'QslG'
      Size = 3
    end
    object cdsQsoLogRegionName: TWideStringField
      FieldKind = fkLookup
      FieldName = 'RegionName'
      LookupDataSet = cdsRegion
      LookupKeyFields = 'COUNTRY;REGION'
      LookupResultField = 'NAME'
      KeyFields = 'COUNTRY;REGION'
      Size = 36
      Lookup = True
    end
    object cdsQsoLogEntityName: TWideStringField
      FieldKind = fkLookup
      FieldName = 'EntityName'
      LookupDataSet = cdsEntity
      LookupKeyFields = 'Entity'
      LookupResultField = 'Name'
      KeyFields = 'ENTITY'
      Size = 36
      Lookup = True
    end
  end
  object cdsQsoLogSel: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dspQsoLog'
    OnCalcFields = cdsQsoLogCalcFields
    Left = 176
    Top = 216
    object cdsQsoLogSelNUM: TIntegerField
      FieldName = 'NUM'
      Origin = '"QSOLOG"."NUM"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object cdsQsoLogSelCALLSIGN: TWideStringField
      FieldName = 'CALLSIGN'
      Origin = '"QSOLOG"."CALLSIGN"'
      Size = 16
    end
    object cdsQsoLogSelORGCALLSIGN: TWideStringField
      FieldName = 'ORGCALLSIGN'
      Origin = '"QSOLOG"."ORGCALLSIGN"'
      Size = 16
    end
    object cdsQsoLogSelCQ: TSmallintField
      FieldName = 'CQ'
      Origin = '"QSOLOG"."CQ"'
      OnGetText = cdsQsoLogCQGetText
    end
    object cdsQsoLogSelSWL: TSmallintField
      FieldName = 'SWL'
      Origin = '"QSOLOG"."SWL"'
    end
    object cdsQsoLogSelONDATETIME: TDateTimeField
      FieldName = 'ONDATETIME'
      Origin = '"QSOLOG"."ONDATETIME"'
      OnGetText = cdsQsoLogONDATETIMEGetText
    end
    object cdsQsoLogSelOFFDATETIME: TDateTimeField
      FieldName = 'OFFDATETIME'
      Origin = '"QSOLOG"."OFFDATETIME"'
      OnGetText = cdsQsoLogONDATETIMEGetText
    end
    object cdsQsoLogSelFREQ: TLargeintField
      FieldName = 'FREQ'
      Origin = '"QSOLOG"."FREQ"'
      OnGetText = cdsQsoLogFREQGetText
    end
    object cdsQsoLogSelBAND: TLargeintField
      FieldName = 'BAND'
      Origin = '"QSOLOG"."BAND"'
      OnGetText = cdsQsoLogFREQGetText
    end
    object cdsQsoLogSelRECVFREQ: TLargeintField
      FieldName = 'RECVFREQ'
      Origin = '"QSOLOG"."RECVFREQ"'
      OnGetText = cdsQsoLogFREQGetText
    end
    object cdsQsoLogSelRECVBAND: TLargeintField
      FieldName = 'RECVBAND'
      Origin = '"QSOLOG"."RECVBAND"'
      OnGetText = cdsQsoLogFREQGetText
    end
    object cdsQsoLogSelMODE: TWideStringField
      FieldName = 'MODE'
      Origin = '"QSOLOG"."MODE"'
      Size = 10
    end
    object cdsQsoLogSelROUTE: TWideStringField
      FieldName = 'ROUTE'
      Origin = '"QSOLOG"."ROUTE"'
      Size = 10
    end
    object cdsQsoLogSelREPEATER: TWideStringField
      FieldName = 'REPEATER'
      Origin = '"QSOLOG"."REPEATER"'
      Size = 10
    end
    object cdsQsoLogSelHISREPORT: TWideStringField
      FieldName = 'HISREPORT'
      Origin = '"QSOLOG"."HISREPORT"'
      Size = 10
    end
    object cdsQsoLogSelMYREPORT: TWideStringField
      FieldName = 'MYREPORT'
      Origin = '"QSOLOG"."MYREPORT"'
      Size = 10
    end
    object cdsQsoLogSelNAME: TWideStringField
      FieldName = 'NAME'
      Origin = '"QSOLOG"."NAME"'
      Size = 32
    end
    object cdsQsoLogSelMEMO: TWideStringField
      FieldName = 'MEMO'
      Origin = '"QSOLOG"."MEMO"'
      Size = 256
    end
    object cdsQsoLogSelQSL: TWideStringField
      FieldName = 'QSL'
      Origin = '"QSOLOG"."QSL"'
      Size = 1
    end
    object cdsQsoLogSelQSLSEND: TWideStringField
      FieldName = 'QSLSEND'
      Origin = '"QSOLOG"."QSLSEND"'
      Size = 1
    end
    object cdsQsoLogSelQSLRECV: TWideStringField
      FieldName = 'QSLRECV'
      Origin = '"QSOLOG"."QSLRECV"'
      Size = 1
    end
    object cdsQsoLogSelQSLSENDDATE: TDateField
      FieldName = 'QSLSENDDATE'
      Origin = '"QSOLOG"."QSLSENDDATE"'
    end
    object cdsQsoLogSelQSLRECVDATE: TDateField
      FieldName = 'QSLRECVDATE'
      Origin = '"QSOLOG"."QSLRECVDATE"'
    end
    object cdsQsoLogSelQSLMANAGER: TWideStringField
      FieldName = 'QSLMANAGER'
      Origin = '"QSOLOG"."QSLMANAGER"'
      Size = 16
    end
    object cdsQsoLogSelNETLOGSEND: TWideStringField
      FieldName = 'NETLOGSEND'
      Size = 16
    end
    object cdsQsoLogSelNETLOGRECV: TWideStringField
      FieldName = 'NETLOGRECV'
      Size = 16
    end
    object cdsQsoLogSelPREFIX: TWideStringField
      FieldName = 'PREFIX'
      Origin = '"QSOLOG"."PREFIX"'
      Size = 10
    end
    object cdsQsoLogSelSUFFIX: TWideStringField
      FieldName = 'SUFFIX'
      Origin = '"QSOLOG"."SUFFIX"'
      Size = 10
    end
    object cdsQsoLogSelCOUNTRY: TWideStringField
      FieldName = 'COUNTRY'
      Origin = '"QSOLOG"."COUNTRY"'
      Size = 10
    end
    object cdsQsoLogSelREGION: TWideStringField
      FieldName = 'REGION'
      Origin = '"QSOLOG"."REGION"'
      Size = 10
    end
    object cdsQsoLogSelENTITY: TWideStringField
      FieldName = 'ENTITY'
      Origin = '"QSOLOG"."ENTITY"'
      Size = 10
    end
    object cdsQsoLogSelGRIDLOC: TWideStringField
      FieldName = 'GRIDLOC'
      Origin = '"QSOLOG"."GRIDLOC"'
      Size = 6
    end
    object cdsQsoLogSelCONTINENT: TWideStringField
      FieldName = 'CONTINENT'
      Origin = '"QSOLOG"."CONTINENT"'
      Size = 2
    end
    object cdsQsoLogSelITUZONE: TWideStringField
      FieldName = 'ITUZONE'
      Origin = '"QSOLOG"."ITUZONE"'
      Size = 2
    end
    object cdsQsoLogSelCQZONE: TWideStringField
      FieldName = 'CQZONE'
      Origin = '"QSOLOG"."CQZONE"'
      Size = 2
    end
    object cdsQsoLogSelIOTA: TWideStringField
      FieldName = 'IOTA'
      Origin = '"QSOLOG"."IOTA"'
      Size = 6
    end
    object cdsQsoLogSelETC1: TWideStringField
      FieldName = 'ETC1'
      Origin = '"QSOLOG"."ETC1"'
      Size = 10
    end
    object cdsQsoLogSelETC2: TWideStringField
      FieldName = 'ETC2'
      Origin = '"QSOLOG"."ETC2"'
      Size = 10
    end
    object cdsQsoLogSelETC3: TWideStringField
      FieldName = 'ETC3'
      Origin = '"QSOLOG"."ETC3"'
      Size = 10
    end
    object cdsQsoLogSelETC4: TWideStringField
      FieldName = 'ETC4'
      Origin = '"QSOLOG"."ETC4"'
      Size = 10
    end
    object cdsQsoLogSelETC5: TWideStringField
      FieldName = 'ETC5'
      Origin = '"QSOLOG"."ETC5"'
      Size = 10
    end
    object cdsQsoLogSelMYCALLSIGN: TWideStringField
      FieldName = 'MYCALLSIGN'
      Origin = '"QSOLOG"."MYCALLSIGN"'
      Size = 16
    end
    object cdsQsoLogSelMYCOUNTRY: TWideStringField
      FieldName = 'MYCOUNTRY'
      Origin = '"QSOLOG"."MYCOUNTRY"'
      Size = 10
    end
    object cdsQsoLogSelMYREGION: TWideStringField
      FieldName = 'MYREGION'
      Origin = '"QSOLOG"."MYREGION"'
      Size = 10
    end
    object cdsQsoLogSelMYENTITY: TWideStringField
      FieldName = 'MYENTITY'
      Origin = '"QSOLOG"."MYENTITY"'
      Size = 10
    end
    object cdsQsoLogSelMYGRIDLOC: TWideStringField
      FieldName = 'MYGRIDLOC'
      Origin = '"QSOLOG"."MYGRIDLOC"'
      Size = 6
    end
    object cdsQsoLogSelMYRIG: TWideStringField
      FieldName = 'MYRIG'
      Origin = '"QSOLOG"."MYRIG"'
      Size = 32
    end
    object cdsQsoLogSelMYANT: TWideStringField
      FieldName = 'MYANT'
      Origin = '"QSOLOG"."MYANT"'
      Size = 32
    end
    object cdsQsoLogSelMYMEMO: TWideStringField
      FieldName = 'MYMEMO'
      Origin = '"QSOLOG"."MYMEMO"'
      Size = 128
    end
    object cdsQsoLogSelQslG: TWideStringField
      FieldKind = fkInternalCalc
      FieldName = 'QslG'
      Size = 3
    end
    object cdsQsoLogSelRegionName: TWideStringField
      FieldKind = fkLookup
      FieldName = 'RegionName'
      LookupDataSet = cdsRegion
      LookupKeyFields = 'COUNTRY;REGION'
      LookupResultField = 'NAME'
      KeyFields = 'COUNTRY;REGION'
      Size = 36
      Lookup = True
    end
    object cdsQsoLogSelEntityName: TWideStringField
      FieldKind = fkLookup
      FieldName = 'EntityName'
      LookupDataSet = cdsEntity
      LookupKeyFields = 'Entity'
      LookupResultField = 'Name'
      KeyFields = 'ENTITY'
      Size = 36
      Lookup = True
    end
  end
  object dspQsoStatus: TDataSetProvider
    DataSet = tblQsoStatus
    Left = 336
    Top = 160
  end
  object tblQsoStatus2: TIBTable
    Database = dbLogBase
    Transaction = trnLogBase
    BufferChunks = 1000
    CachedUpdates = False
    IndexDefs = <
      item
        Name = 'PK_QSOSTATUS'
        Fields = 'CATEGORY;KEY;MODELEVEL;MODE'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'QSOSTATUS2'
    UniDirectional = False
    Left = 336
    Top = 96
  end
  object qryQsoLogSel: TIBQuery
    Database = dbLogBase
    Transaction = trnLogBase
    OnCalcFields = cdsQsoLogCalcFields
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'SELECT * FROM QsoLog;')
    Left = 184
    Top = 104
    object qryQsoLogSelNUM: TIntegerField
      FieldName = 'NUM'
      Origin = '"QSOLOG"."NUM"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryQsoLogSelCALLSIGN: TIBStringField
      FieldName = 'CALLSIGN'
      Origin = '"QSOLOG"."CALLSIGN"'
      Size = 16
    end
    object qryQsoLogSelORGCALLSIGN: TIBStringField
      FieldName = 'ORGCALLSIGN'
      Origin = '"QSOLOG"."ORGCALLSIGN"'
      Size = 16
    end
    object qryQsoLogSelCQ: TSmallintField
      FieldName = 'CQ'
      Origin = '"QSOLOG"."CQ"'
      OnGetText = cdsQsoLogCQGetText
    end
    object qryQsoLogSelSWL: TSmallintField
      FieldName = 'SWL'
      Origin = '"QSOLOG"."SWL"'
    end
    object qryQsoLogSelONDATETIME: TDateTimeField
      FieldName = 'ONDATETIME'
      Origin = '"QSOLOG"."ONDATETIME"'
      OnGetText = cdsQsoLogONDATETIMEGetText
    end
    object qryQsoLogSelOFFDATETIME: TDateTimeField
      FieldName = 'OFFDATETIME'
      Origin = '"QSOLOG"."OFFDATETIME"'
      OnGetText = cdsQsoLogONDATETIMEGetText
    end
    object qryQsoLogSelFREQ: TLargeintField
      FieldName = 'FREQ'
      Origin = '"QSOLOG"."FREQ"'
      OnGetText = cdsQsoLogFREQGetText
    end
    object qryQsoLogSelBAND: TLargeintField
      FieldName = 'BAND'
      Origin = '"QSOLOG"."BAND"'
      OnGetText = cdsQsoLogFREQGetText
    end
    object qryQsoLogSelRECVFREQ: TLargeintField
      FieldName = 'RECVFREQ'
      Origin = '"QSOLOG"."RECVFREQ"'
      OnGetText = cdsQsoLogFREQGetText
    end
    object qryQsoLogSelRECVBAND: TLargeintField
      FieldName = 'RECVBAND'
      Origin = '"QSOLOG"."RECVBAND"'
      OnGetText = cdsQsoLogFREQGetText
    end
    object qryQsoLogSelMODE: TIBStringField
      FieldName = 'MODE'
      Origin = '"QSOLOG"."MODE"'
      Size = 10
    end
    object qryQsoLogSelROUTE: TIBStringField
      FieldName = 'ROUTE'
      Origin = '"QSOLOG"."ROUTE"'
      Size = 10
    end
    object qryQsoLogSelREPEATER: TIBStringField
      FieldName = 'REPEATER'
      Origin = '"QSOLOG"."REPEATER"'
      Size = 10
    end
    object qryQsoLogSelHISREPORT: TIBStringField
      FieldName = 'HISREPORT'
      Origin = '"QSOLOG"."HISREPORT"'
      Size = 10
    end
    object qryQsoLogSelMYREPORT: TIBStringField
      FieldName = 'MYREPORT'
      Origin = '"QSOLOG"."MYREPORT"'
      Size = 10
    end
    object qryQsoLogSelNAME: TIBStringField
      FieldName = 'NAME'
      Origin = '"QSOLOG"."NAME"'
      Size = 32
    end
    object qryQsoLogSelMEMO: TIBStringField
      FieldName = 'MEMO'
      Origin = '"QSOLOG"."MEMO"'
      Size = 256
    end
    object qryQsoLogSelQSL: TIBStringField
      FieldName = 'QSL'
      Origin = '"QSOLOG"."QSL"'
      FixedChar = True
      Size = 1
    end
    object qryQsoLogSelQSLSEND: TIBStringField
      FieldName = 'QSLSEND'
      Origin = '"QSOLOG"."QSLSEND"'
      FixedChar = True
      Size = 1
    end
    object qryQsoLogSelQSLRECV: TIBStringField
      FieldName = 'QSLRECV'
      Origin = '"QSOLOG"."QSLRECV"'
      FixedChar = True
      Size = 1
    end
    object qryQsoLogSelQSLSENDDATE: TDateField
      FieldName = 'QSLSENDDATE'
      Origin = '"QSOLOG"."QSLSENDDATE"'
    end
    object qryQsoLogSelQSLRECVDATE: TDateField
      FieldName = 'QSLRECVDATE'
      Origin = '"QSOLOG"."QSLRECVDATE"'
    end
    object qryQsoLogSelQSLMANAGER: TIBStringField
      FieldName = 'QSLMANAGER'
      Origin = '"QSOLOG"."QSLMANAGER"'
      Size = 16
    end
    object qryQsoLogSelNETLOGSEND: TIBStringField
      FieldName = 'NETLOGSEND'
      Origin = '"QSOLOG"."NETLOGSEND"'
      Size = 16
    end
    object qryQsoLogSelNETLOGRECV: TIBStringField
      FieldName = 'NETLOGRECV'
      Origin = '"QSOLOG"."NETLOGRECV"'
      Size = 16
    end
    object qryQsoLogSelPREFIX: TIBStringField
      FieldName = 'PREFIX'
      Origin = '"QSOLOG"."PREFIX"'
      Size = 10
    end
    object qryQsoLogSelSUFFIX: TIBStringField
      FieldName = 'SUFFIX'
      Origin = '"QSOLOG"."SUFFIX"'
      Size = 10
    end
    object qryQsoLogSelCOUNTRY: TIBStringField
      FieldName = 'COUNTRY'
      Origin = '"QSOLOG"."COUNTRY"'
      Size = 10
    end
    object qryQsoLogSelREGION: TIBStringField
      FieldName = 'REGION'
      Origin = '"QSOLOG"."REGION"'
      Size = 10
    end
    object qryQsoLogSelENTITY: TIBStringField
      FieldName = 'ENTITY'
      Origin = '"QSOLOG"."ENTITY"'
      Size = 10
    end
    object qryQsoLogSelGRIDLOC: TIBStringField
      FieldName = 'GRIDLOC'
      Origin = '"QSOLOG"."GRIDLOC"'
      Size = 6
    end
    object qryQsoLogSelCONTINENT: TIBStringField
      FieldName = 'CONTINENT'
      Origin = '"QSOLOG"."CONTINENT"'
      Size = 2
    end
    object qryQsoLogSelITUZONE: TIBStringField
      FieldName = 'ITUZONE'
      Origin = '"QSOLOG"."ITUZONE"'
      Size = 2
    end
    object qryQsoLogSelCQZONE: TIBStringField
      FieldName = 'CQZONE'
      Origin = '"QSOLOG"."CQZONE"'
      Size = 2
    end
    object qryQsoLogSelIOTA: TIBStringField
      FieldName = 'IOTA'
      Origin = '"QSOLOG"."IOTA"'
      Size = 6
    end
    object qryQsoLogSelETC1: TIBStringField
      FieldName = 'ETC1'
      Origin = '"QSOLOG"."ETC1"'
      Size = 10
    end
    object qryQsoLogSelETC2: TIBStringField
      FieldName = 'ETC2'
      Origin = '"QSOLOG"."ETC2"'
      Size = 10
    end
    object qryQsoLogSelETC3: TIBStringField
      FieldName = 'ETC3'
      Origin = '"QSOLOG"."ETC3"'
      Size = 10
    end
    object qryQsoLogSelETC4: TIBStringField
      FieldName = 'ETC4'
      Origin = '"QSOLOG"."ETC4"'
      Size = 10
    end
    object qryQsoLogSelETC5: TIBStringField
      FieldName = 'ETC5'
      Origin = '"QSOLOG"."ETC5"'
      Size = 10
    end
    object qryQsoLogSelMYCALLSIGN: TIBStringField
      FieldName = 'MYCALLSIGN'
      Origin = '"QSOLOG"."MYCALLSIGN"'
      Size = 16
    end
    object qryQsoLogSelMYCOUNTRY: TIBStringField
      FieldName = 'MYCOUNTRY'
      Origin = '"QSOLOG"."MYCOUNTRY"'
      Size = 10
    end
    object qryQsoLogSelMYREGION: TIBStringField
      FieldName = 'MYREGION'
      Origin = '"QSOLOG"."MYREGION"'
      Size = 10
    end
    object qryQsoLogSelMYENTITY: TIBStringField
      FieldName = 'MYENTITY'
      Origin = '"QSOLOG"."MYENTITY"'
      Size = 10
    end
    object qryQsoLogSelMYGRIDLOC: TIBStringField
      FieldName = 'MYGRIDLOC'
      Origin = '"QSOLOG"."MYGRIDLOC"'
      Size = 6
    end
    object qryQsoLogSelMYRIG: TIBStringField
      FieldName = 'MYRIG'
      Origin = '"QSOLOG"."MYRIG"'
      Size = 32
    end
    object qryQsoLogSelMYANT: TIBStringField
      FieldName = 'MYANT'
      Origin = '"QSOLOG"."MYANT"'
      Size = 32
    end
    object qryQsoLogSelMYMEMO: TIBStringField
      FieldName = 'MYMEMO'
      Origin = '"QSOLOG"."MYMEMO"'
      Size = 128
    end
    object qryQsoLogSelQslG: TWideStringField
      FieldKind = fkCalculated
      FieldName = 'QslG'
      Calculated = True
    end
    object qryQsoLogSelRegionName: TWideStringField
      FieldKind = fkLookup
      FieldName = 'RegionName'
      LookupDataSet = cdsRegion
      LookupKeyFields = 'Country;Region'
      LookupResultField = 'NAME'
      KeyFields = 'Country;Region'
      Size = 36
      Lookup = True
    end
    object qryQsoLogSelEntityName: TWideStringField
      FieldKind = fkLookup
      FieldName = 'EntityName'
      LookupDataSet = cdsEntity
      LookupKeyFields = 'Entity'
      LookupResultField = 'name'
      KeyFields = 'Entity'
      Size = 36
      Lookup = True
    end
  end
  object dbReference: TIBDatabase
    DatabaseName = 'C:\LogBase Projects\LogBase V1.1.0\Reference.FDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'Password=masterkey')
    LoginPrompt = False
    DefaultTransaction = trnLogBase
    ServerType = 'IBServer'
    Left = 40
    Top = 400
  end
  object trnReference: TIBTransaction
    DefaultDatabase = dbReference
    DefaultAction = TACommitRetaining
    Params.Strings = (
      'concurrency'
      'nowait')
    AutoStopAction = saCommitRetaining
    Left = 112
    Top = 400
  end
  object tmrLotw: TTimer
    Enabled = False
    Interval = 0
    Left = 432
    Top = 232
  end
  object qryLoTW: TIBQuery
    Database = dbLogBase
    Transaction = trnLogBase
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      '')
    Left = 432
    Top = 168
  end
  object tblQso: TIBDataSet
    Database = dbLogBase
    Transaction = trnLogBase
    BufferChunks = 1000
    CachedUpdates = False
    SelectSQL.Strings = (
      'select * from QSO;')
    ParamCheck = True
    UniDirectional = False
    DataSource = dsQso
    Left = 328
    Top = 360
  end
  object tblQsoLog: TIBDataSet
    Database = dbLogBase
    Transaction = trnLogBase
    BufferChunks = 1000
    CachedUpdates = False
    SelectSQL.Strings = (
      'select * from QSOLOG;')
    ParamCheck = True
    UniDirectional = False
    DataSource = dsQsoLog
    Left = 392
    Top = 360
  end
  object tblQsoStatus: TIBDataSet
    Database = dbLogBase
    Transaction = trnLogBase
    BufferChunks = 1000
    CachedUpdates = False
    SelectSQL.Strings = (
      'select * from QSOSTATUS;')
    ParamCheck = True
    UniDirectional = False
    DataSource = dsQsoStatus
    Left = 472
    Top = 360
  end
  object qryQsoLog2: TIBQuery
    Database = dbLogBase
    Transaction = trnLogBase
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      '')
    Left = 504
    Top = 104
  end
end

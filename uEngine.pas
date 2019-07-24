unit uEngine;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IBCustomDataSet,
  IBTable, IBDatabase, Datasnap.Provider, Datasnap.DBClient,
  IBSQL, IBQuery, DateUtils, Data.DB, MidasLib,
  Variants, StrUtils, UITypes,
  FileCtrl, ActiveX ,
  Winapi.ShellAPI,
  ComObj, Vcl.ExtDlgs,
  uRoutine, uRecord, uConstant, uInternet,
  SkRegExpW, XmlIniFile, uTransceiver,
  ADX, Xml.XMLIntf, Vcl.ExtCtrls,                       // 2015/08/15
  MMSystem;

type TDirection = (drNext, drPrior);

type
// TEngineのスレッド
  TChangeCommentEvent     = procedure(Sender: TObject; const Comment: string) of object;
  TChangeDirAndDistEvent  = procedure(Sender: TObject; const Direction: Double; const Distance: Double) of object;
  TChangeJarlMemberEvent  = procedure(Sender: TObject; const isMember, isQslService: boolean) of object;
  TChangeLicenceEvent     = procedure(Sender: TObject; const isLicenced: boolean) of object;
//  TChangeMyCallsignEvent  = procedure(Sender: TObject; const MyCallsign, MyRegionName: string) of object;
  TChangeProcessingEvent  = procedure(Sender: TObject; const Processing: TProcessing) of object;
  TChangeQsoStateEvent    = procedure(Sender: TObject; const QsoState: TQsoState) of object;

type
  EValueWarningError = class(Exception);
  EValueFatalError   = class(Exception);

type
  TEngine = class(TDataModule)
    cdsEntity: TClientDataSet;
    cdsEntityENTITY: TWideStringField;
    cdsEntityNAME: TWideStringField;
    cdsFindRegion: TClientDataSet;

    cdsQso: TClientDataSet;
    cdsQsoBAND: TLargeintField;
    cdsQsoCALLSIGN: TWideStringField;
    cdsQsoCONTINENT: TWideStringField;
    cdsQsoCOUNTRY: TWideStringField;
    cdsQsoCQ: TSmallintField;
    cdsQsoCQZONE: TWideStringField;
    cdsQsoENTITY: TWideStringField;
    cdsQsoETC1: TWideStringField;
    cdsQsoETC2: TWideStringField;
    cdsQsoETC3: TWideStringField;
    cdsQsoETC4: TWideStringField;
    cdsQsoETC5: TWideStringField;
    cdsQsoFREQ: TLargeintField;
    cdsQsoGRIDLOC: TWideStringField;
    cdsQsoHISREPORT: TWideStringField;
    cdsQsoIOTA: TWideStringField;
    cdsQsoITUZONE: TWideStringField;
    cdsQsoMEMO: TWideStringField;
    cdsQsoMODE: TWideStringField;
    cdsQsoMYANT: TWideStringField;
    cdsQsoMYCALLSIGN: TWideStringField;
    cdsQsoMYCOUNTRY: TWideStringField;
    cdsQsoMYENTITY: TWideStringField;
    cdsQsoMYGRIDLOC: TWideStringField;
    cdsQsoMYMEMO: TWideStringField;
    cdsQsoMYREGION: TWideStringField;
    cdsQsoMYREPORT: TWideStringField;
    cdsQsoMYRIG: TWideStringField;
    cdsQsoNAME: TWideStringField;
    cdsQsoNUM: TIntegerField;
    cdsQsoOFFDATETIME: TDateTimeField;
    cdsQsoONDATETIME: TDateTimeField;
    cdsQsoORGCALLSIGN: TWideStringField;
    cdsQsoPREFIX: TWideStringField;
    cdsQsoQSL: TWideStringField;
    cdsQsoQSLMANAGER: TWideStringField;
    cdsQsoQSLRECV: TWideStringField;
    cdsQsoQSLRECVDATE: TDateField;
    cdsQsoQSLSEND: TWideStringField;
    cdsQsoQSLSENDDATE: TDateField;
    cdsQsoRECVBAND: TLargeintField;
    cdsQsoRECVFREQ: TLargeintField;
    cdsQsoREGION: TWideStringField;
    cdsQsoREPEATER: TWideStringField;
    cdsQsoROUTE: TWideStringField;
    cdsQsoSUFFIX: TWideStringField;
    cdsQsoSWL: TSmallintField;

    cdsRegion: TClientDataSet;

    cdsQsoLog: TClientDataSet;
    cdsQsoLogBAND: TLargeintField;
    cdsQsoLogCALLSIGN: TWideStringField;
    cdsQsoLogCONTINENT: TWideStringField;
    cdsQsoLogCOUNTRY: TWideStringField;
    cdsQsoLogCQ: TSmallintField;
    cdsQsoLogCQZONE: TWideStringField;
    cdsQsoLogENTITY: TWideStringField;
    cdsQsoLogEntityName: TWideStringField;
    cdsQsoLogETC1: TWideStringField;
    cdsQsoLogETC2: TWideStringField;
    cdsQsoLogETC3: TWideStringField;
    cdsQsoLogETC4: TWideStringField;
    cdsQsoLogETC5: TWideStringField;
    cdsQsoLogFREQ: TLargeintField;
    cdsQsoLogGRIDLOC: TWideStringField;
    cdsQsoLogHISREPORT: TWideStringField;
    cdsQsoLogIOTA: TWideStringField;
    cdsQsoLogITUZONE: TWideStringField;
    cdsQsoLogMEMO: TWideStringField;
    cdsQsoLogMODE: TWideStringField;
    cdsQsoLogMYANT: TWideStringField;
    cdsQsoLogMYCALLSIGN: TWideStringField;
    cdsQsoLogMYCOUNTRY: TWideStringField;
    cdsQsoLogMYENTITY: TWideStringField;
    cdsQsoLogMYGRIDLOC: TWideStringField;
    cdsQsoLogMYMEMO: TWideStringField;
    cdsQsoLogMYREGION: TWideStringField;
    cdsQsoLogMYREPORT: TWideStringField;
    cdsQsoLogMYRIG: TWideStringField;
    cdsQsoLogNAME: TWideStringField;
    cdsQsoLogNUM: TIntegerField;
    cdsQsoLogOFFDATETIME: TDateTimeField;
    cdsQsoLogONDATETIME: TDateTimeField;
    cdsQsoLogORGCALLSIGN: TWideStringField;
    cdsQsoLogPREFIX: TWideStringField;
    cdsQsoLogQSL: TWideStringField;
    cdsQsoLogQslG: TWideStringField;
    cdsQsoLogQSLMANAGER: TWideStringField;
    cdsQsoLogQSLRECV: TWideStringField;
    cdsQsoLogQSLRECVDATE: TDateField;
    cdsQsoLogQSLSEND: TWideStringField;
    cdsQsoLogQSLSENDDATE: TDateField;
    cdsQsoLogRECVBAND: TLargeintField;
    cdsQsoLogRECVFREQ: TLargeintField;
    cdsQsoLogREGION: TWideStringField;
    cdsQsoLogRegionName: TWideStringField;
    cdsQsoLogREPEATER: TWideStringField;
    cdsQsoLogROUTE: TWideStringField;

    cdsQsoLogSel: TClientDataSet;
    cdsQsoLogSelBAND: TLargeintField;
    cdsQsoLogSelCALLSIGN: TWideStringField;
    cdsQsoLogSelCONTINENT: TWideStringField;
    cdsQsoLogSelCOUNTRY: TWideStringField;
    cdsQsoLogSelCQ: TSmallintField;
    cdsQsoLogSelCQZONE: TWideStringField;
    cdsQsoLogSelENTITY: TWideStringField;
    cdsQsoLogSelEntityName: TWideStringField;
    cdsQsoLogSelETC1: TWideStringField;
    cdsQsoLogSelETC2: TWideStringField;
    cdsQsoLogSelETC3: TWideStringField;
    cdsQsoLogSelETC4: TWideStringField;
    cdsQsoLogSelETC5: TWideStringField;
    cdsQsoLogSelFREQ: TLargeintField;
    cdsQsoLogSelGRIDLOC: TWideStringField;
    cdsQsoLogSelHISREPORT: TWideStringField;
    cdsQsoLogSelIOTA: TWideStringField;
    cdsQsoLogSelITUZONE: TWideStringField;
    cdsQsoLogSelMEMO: TWideStringField;
    cdsQsoLogSelMODE: TWideStringField;
    cdsQsoLogSelMYANT: TWideStringField;
    cdsQsoLogSelMYCALLSIGN: TWideStringField;
    cdsQsoLogSelMYCOUNTRY: TWideStringField;
    cdsQsoLogSelMYENTITY: TWideStringField;
    cdsQsoLogSelMYGRIDLOC: TWideStringField;
    cdsQsoLogSelMYMEMO: TWideStringField;
    cdsQsoLogSelMYREGION: TWideStringField;
    cdsQsoLogSelMYREPORT: TWideStringField;
    cdsQsoLogSelMYRIG: TWideStringField;
    cdsQsoLogSelNAME: TWideStringField;
    cdsQsoLogSelNUM: TIntegerField;
    cdsQsoLogSelOFFDATETIME: TDateTimeField;
    cdsQsoLogSelONDATETIME: TDateTimeField;
    cdsQsoLogSelORGCALLSIGN: TWideStringField;
    cdsQsoLogSelPREFIX: TWideStringField;
    cdsQsoLogSelQSL: TWideStringField;
    cdsQsoLogSelQslG: TWideStringField;
    cdsQsoLogSelQSLMANAGER: TWideStringField;
    cdsQsoLogSelQSLRECV: TWideStringField;
    cdsQsoLogSelQSLRECVDATE: TDateField;
    cdsQsoLogSelQSLSEND: TWideStringField;
    cdsQsoLogSelQSLSENDDATE: TDateField;
    cdsQsoLogSelRECVBAND: TLargeintField;
    cdsQsoLogSelRECVFREQ: TLargeintField;
    cdsQsoLogSelREGION: TWideStringField;
    cdsQsoLogSelRegionName: TWideStringField;
    cdsQsoLogSelREPEATER: TWideStringField;
    cdsQsoLogSelROUTE: TWideStringField;
    cdsQsoLogSelSUFFIX: TWideStringField;
    cdsQsoLogSelSWL: TSmallintField;
    cdsQsoLogSUFFIX: TWideStringField;
    cdsQsoLogSWL: TSmallintField;
    cdsQsoStatus: TClientDataSet;

    dbLogBase: TIBDatabase;
    dsFindRegion: TDataSource;
    dsQso: TDataSource;
    dsQsoLog: TDataSource;
    dsQsoLogSel: TDataSource;
    dsQsoStatus: TDataSource;

    dspEntity: TDataSetProvider;
    dspFindRegion: TDataSetProvider;
    dspQso: TDataSetProvider;
    dspQsoLog: TDataSetProvider;
    dspRegion: TDataSetProvider;
    trnLogBase: TIBTransaction;

    qryCommon: TIBQuery;
    qryEntity: TIBQuery;
    qryFindRegion: TIBQuery;
    qryQsoLog: TIBQuery;
    qryRegion: TIBQuery;
    tblQso2: TIBTable;
    tblQsoLog2: TIBTable;
    cdsQsoLogNETLOGSEND: TWideStringField;
    cdsQsoLogNETLOGRECV: TWideStringField;
    cdsQsoLogSelNETLOGSEND: TWideStringField;
    cdsQsoLogSelNETLOGRECV: TWideStringField;
    cdsQsoNETLOGSEND: TWideStringField;
    cdsQsoNETLOGRECV: TWideStringField;
    dspQsoStatus: TDataSetProvider;
    tblQsoStatus2: TIBTable;
    cdsQsoStatusCATEGORY: TWideStringField;
    cdsQsoStatusKEY: TWideStringField;
    cdsQsoStatusMODELEVEL: TSmallintField;
    cdsQsoStatusMODE: TWideStringField;
    cdsQsoStatusNAME: TWideStringField;
    cdsQsoStatusKEYLEVEL: TSmallintField;
    cdsQsoStatusBAND00: TWideStringField;
    cdsQsoStatusBAND01: TWideStringField;
    cdsQsoStatusBAND02: TWideStringField;
    cdsQsoStatusBAND03: TWideStringField;
    cdsQsoStatusBAND04: TWideStringField;
    cdsQsoStatusBAND05: TWideStringField;
    cdsQsoStatusBAND06: TWideStringField;
    cdsQsoStatusBAND07: TWideStringField;
    cdsQsoStatusBAND08: TWideStringField;
    cdsQsoStatusBAND09: TWideStringField;
    cdsQsoStatusBAND10: TWideStringField;
    cdsQsoStatusBAND11: TWideStringField;
    cdsQsoStatusBAND12: TWideStringField;
    cdsQsoStatusBAND13: TWideStringField;
    cdsQsoStatusBAND14: TWideStringField;
    cdsQsoStatusBAND15: TWideStringField;
    qryQsoLogSel: TIBQuery;
    qryQsoLogSelNUM: TIntegerField;
    qryQsoLogSelCALLSIGN: TIBStringField;
    qryQsoLogSelORGCALLSIGN: TIBStringField;
    qryQsoLogSelCQ: TSmallintField;
    qryQsoLogSelSWL: TSmallintField;
    qryQsoLogSelONDATETIME: TDateTimeField;
    qryQsoLogSelOFFDATETIME: TDateTimeField;
    qryQsoLogSelFREQ: TLargeintField;
    qryQsoLogSelBAND: TLargeintField;
    qryQsoLogSelRECVFREQ: TLargeintField;
    qryQsoLogSelRECVBAND: TLargeintField;
    qryQsoLogSelMODE: TIBStringField;
    qryQsoLogSelROUTE: TIBStringField;
    qryQsoLogSelREPEATER: TIBStringField;
    qryQsoLogSelHISREPORT: TIBStringField;
    qryQsoLogSelMYREPORT: TIBStringField;
    qryQsoLogSelNAME: TIBStringField;
    qryQsoLogSelMEMO: TIBStringField;
    qryQsoLogSelQSL: TIBStringField;
    qryQsoLogSelQSLSEND: TIBStringField;
    qryQsoLogSelQSLRECV: TIBStringField;
    qryQsoLogSelQSLSENDDATE: TDateField;
    qryQsoLogSelQSLRECVDATE: TDateField;
    qryQsoLogSelQSLMANAGER: TIBStringField;
    qryQsoLogSelNETLOGSEND: TIBStringField;
    qryQsoLogSelNETLOGRECV: TIBStringField;
    qryQsoLogSelPREFIX: TIBStringField;
    qryQsoLogSelSUFFIX: TIBStringField;
    qryQsoLogSelCOUNTRY: TIBStringField;
    qryQsoLogSelREGION: TIBStringField;
    qryQsoLogSelENTITY: TIBStringField;
    qryQsoLogSelGRIDLOC: TIBStringField;
    qryQsoLogSelCONTINENT: TIBStringField;
    qryQsoLogSelITUZONE: TIBStringField;
    qryQsoLogSelCQZONE: TIBStringField;
    qryQsoLogSelIOTA: TIBStringField;
    qryQsoLogSelETC1: TIBStringField;
    qryQsoLogSelETC2: TIBStringField;
    qryQsoLogSelETC3: TIBStringField;
    qryQsoLogSelETC4: TIBStringField;
    qryQsoLogSelETC5: TIBStringField;
    qryQsoLogSelMYCALLSIGN: TIBStringField;
    qryQsoLogSelMYCOUNTRY: TIBStringField;
    qryQsoLogSelMYREGION: TIBStringField;
    qryQsoLogSelMYENTITY: TIBStringField;
    qryQsoLogSelMYGRIDLOC: TIBStringField;
    qryQsoLogSelMYRIG: TIBStringField;
    qryQsoLogSelMYANT: TIBStringField;
    qryQsoLogSelMYMEMO: TIBStringField;
    qryQsoLogSelQslG: TWideStringField;
    qryQsoLogSelRegionName: TWideStringField;
    qryQsoLogSelEntityName: TWideStringField;
    dbReference: TIBDatabase;
    trnReference: TIBTransaction;
    tmrLotw: TTimer;
    qryLoTW: TIBQuery;
    tblQso: TIBDataSet;
    tblQsoLog: TIBDataSet;
    tblQsoStatus: TIBDataSet;
    qryQsoLog2: TIBQuery;

    procedure cdsQsoLogCalcFields(DataSet: TDataSet);
//    procedure swl(Sender: TField);
    procedure cdsQsoCALLSIGNValidate(Sender: TField);
    procedure cdsQsoORGCALLSIGNChange(Sender: TField);
    procedure cdsQsoORGCALLSIGNValidate(Sender: TField);
    procedure cdsQsoONDATETIMEChange(Sender: TField);
    procedure cdsQsoONDATETIMEValidate(Sender: TField);
    procedure cdsQsoOFFDATETIMEValidate(Sender: TField);
    procedure cdsQsoFREQValidate(Sender: TField);
    procedure cdsQsoRECVFREQValidate(Sender: TField);
    procedure cdsQsoMODEValidate(Sender: TField);
    procedure cdsQsoREPEATERValidate(Sender: TField);
    procedure cdsQsoHISREPORTValidate(Sender: TField);
    procedure cdsQsoMYREPORTValidate(Sender: TField);
    procedure cdsQsoNAMEChange(Sender: TField);
    procedure cdsQsoMEMOChange(Sender: TField);
    procedure cdsQsoQSLValidate(Sender: TField);
    procedure cdsQsoQSLSENDValidate(Sender: TField);
    procedure cdsQsoQSLRECVValidate(Sender: TField);
    procedure cdsQsoPREFIXChange(Sender: TField);
    procedure cdsQsoPREFIXValidate(Sender: TField);
    procedure cdsQsoSUFFIXChange(Sender: TField);
    procedure cdsQsoSUFFIXValidate(Sender: TField);
    procedure cdsQsoCOUNTRYChange(Sender: TField);
    procedure cdsQsoCOUNTRYValidate(Sender: TField);
    procedure cdsQsoENTITYChange(Sender: TField);
    procedure cdsQsoENTITYValidate(Sender: TField);
    procedure cdsQsoGRIDLOCValidate(Sender: TField);
    procedure cdsQsoCONTINENTValidate(Sender: TField);
    procedure cdsQsoCQZONEValidate(Sender: TField);
    procedure cdsQsoIOTAValidate(Sender: TField);
    procedure cdsQsoETC1Validate(Sender: TField);
    procedure cdsQsoLogONDATETIMEGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsQsoLogFREQGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsQsoLogBeforeDelete(DataSet: TDataSet);
    procedure cdsQsoLogBeforePost(DataSet: TDataSet);
    procedure cdsQsoREGIONValidate(Sender: TField);
    procedure cdsQsoREGIONChange(Sender: TField);
    procedure cdsQsoROUTEValidate(Sender: TField);
    procedure cdsQsoITUZONEValidate(Sender: TField);
    procedure cdsQsoNewRecord(DataSet: TDataSet);
    procedure cdsQsoFREQChange(Sender: TField);
    procedure cdsQsoRECVFREQChange(Sender: TField);
    procedure cdsQsoOFFDATETIMEChange(Sender: TField);
    procedure cdsQsoMODEChange(Sender: TField);
    procedure cdsQsoROUTEChange(Sender: TField);
    procedure cdsQsoREPEATERChange(Sender: TField);
    procedure cdsQsoHISREPORTChange(Sender: TField);
    procedure cdsQsoMYREPORTChange(Sender: TField);
    procedure cdsQsoQSLChange(Sender: TField);
    procedure cdsQsoQSLRECVChange(Sender: TField);
    procedure cdsQsoQSLMANAGERChange(Sender: TField);
    procedure cdsQsoGRIDLOCChange(Sender: TField);
    procedure cdsQsoCONTINENTChange(Sender: TField);
    procedure cdsQsoITUZONEChange(Sender: TField);
    procedure cdsQsoCQZONEChange(Sender: TField);
    procedure cdsQsoIOTAChange(Sender: TField);
    procedure cdsQsoETC1Change(Sender: TField);
    procedure cdsQsoETC2Change(Sender: TField);
    procedure cdsQsoETC3Change(Sender: TField);
    procedure cdsQsoETC4Change(Sender: TField);
    procedure cdsQsoETC5Change(Sender: TField);
    procedure cdsQsoETC2Validate(Sender: TField);
    procedure cdsQsoETC3Validate(Sender: TField);
    procedure cdsQsoETC4Validate(Sender: TField);
    procedure cdsQsoETC5Validate(Sender: TField);
    procedure cdsQsoNETLOGSENDChange(Sender: TField);
    procedure cdsQsoNETLOGRECVChange(Sender: TField);
    procedure cdsQsoLogAfterPost(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure cdsQsoLogCQGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure cdsQsoCQChange(Sender: TField);
    procedure cdsFindRegionCalcFields(DataSet: TDataSet);
    procedure cdsQsoSWLChange(Sender: TField);
    procedure cdsQsoCALLSIGNChange(Sender: TField);
    procedure DataModuleDestroy(Sender: TObject);
    procedure cdsQsoQSLSENDDATEChange(Sender: TField);
    procedure cdsQsoQSLRECVDATEChange(Sender: TField);
    procedure cdsQsoQSLSENDDATEValidate(Sender: TField);
    procedure cdsQsoQSLSENDChange(Sender: TField);
    procedure dsQsoLogStateChange(Sender: TObject);

  private
    { Private 宣言 }
//  日付定数を定義できないため。OnCreateで定数を設定する。
    FLowDate:        TDateTime;
    FHighDate:       TDateTime;
    PastQso:        TPastQso;           //  同一Callsignでの前のQSO内容
    PrevQso:        TPrevQso;           //  直前のQSO内容
//  Key入力有無判断
    bAutoInput:     array of SmallInt;  // 自動でFieldを設定する
    bManualInput:   array of boolean;   // 手動（Key入力）で Fieldを設定した

//  RealTime/Batch切り替え用
    isQsoDateOver:  boolean;
    iDateOverCnt:   integer;
//  Check.... 用
    cCallsignRec:   TCallsignRec;
    cCountryRec:    TCountryRec;
    cEntityRec:     TEntityRec;
    cFreqRec:       TFreqRec;
    cHamLog:        THamLog;
    cIotaRec:       TIotaRec;
    cModeRec:       TModeRec;
    cRegionRec:     TRegionRec;
    cZipCodeRec:    TZipCodeRec;
    cRepeaterRec:   TRepeaterRec;
    cRouteRec:      TRouteRec;
    isValidEtcRec:  array[1..5] of boolean;
    cEtcRec:        array[1..5] of TEtcRec;

    dStartTime: TDateTime;      //デバッグ用
    dEndTime:   TDateTime;
//    dElapsTime: TDateTime;
//    dMessage:   string;

    FDbChanged:     boolean;      // Databeseに交信がかかった
//TTimeZoneInformationのByauを日付型にそのまま加算できる値
    FTimeZoneInformation: TTimeZoneInformation;
    FTimeZOneName: string;
    FTimeZoneBiasM: Integer;  // 分単位    JSTでは、＋540  （9×60）
    FTimeZoneBiasH: Double;   // 時間単位　JSTでは、+9.0
    FTimeZoneBiasD: Double;   // 日単位　 JSTでは、 +9÷24

//  Propertyの保存値
    FQsoState:      TQsoState;
    FSupportQso:           TSupportQso;
    FProcessing:    TProcessing;
    FMyDataRec:     TMyDataRec;
    FDirection:     Double;
    FDistance:      Double;
    FContinentList: TStringList;
    FCqZoneList:    TStringList;
    FItuZoneList:   TStringList;
    FEntityList:    TStringList;
    FIotaList:      TStringList;
    FRegionList:    TStringList;
    FRepeaterList:  TStringList;
    FRouteList:     TStringList;
    FQslDefault:    string;
    FQslRecvDefault: string;
    FQslSendDefault: string;
    FQslSendDate:     TDate;
    FQslRecvDate:     TDate;

    pFreqFormatList:  TStringList;
    pQslList:         TstringList;
    pQslSendList:     TStringList;
    pQslRecvList:     TStringList;
    pBandList_BM:     TStringList;
    pCallbookEx:      TCallbookEx;
    pCallbook:        TCallbook;
    pEntityListKey1:  String;
    pEntityListKey2:  TDate;
    pRegionListKey1:  String;
    pRegionListKey2:  string;
    pRegionListKey3:  TDateTime;
    pLocationLevel:   integer;
    pFindRegionCountry: string;
    pQslSendAction:   string;
    pQslRecvAction:   string;

    JarlThread: TJarl;
    LicenceThread: TLicence;
    LicencedRegionName: string;

    Trcv: TTransceiver;

    FOnChangeComment:     TChangeCommentEvent;
    FOnChangeDirAndDist:  TChangeDirAndDistEvent;
//    FOnChangeMyCallsign:  TChangeMyCallsignEvent;
    FOnChangeProcessing:  TChangeProcessingEvent;
    FOnChangeQsoState:    TChangeQsoStateEvent;
    FOnChangeJarlMember:  TChangeJarlMemberEvent;
    FOnChangeLicence:     TChangeLicenceEvent;

    FAppPath: string;         // ex. 'D:\LogBase\'   右端に\がある
    FMyDocPath: string;       // ex. 'C:\Users\<User Name>\Documents\
    FJournalPath: string;
//    FAppDataPath: string;     // ex  'C:\Users\<User Name>\AppData\Local\LogBase\
//    FUserDataPath: string;

    FDataBase: string;      // ex. 'LogBase.FDB
    FDataBaseName: string;  // ex. 'D:\Logbase\LogBase.FDB' データベース名
    FReferenceDB: string;
    FReferenceDBName: string;
    FXmlIniFileName: string;

    FJournalName:  string;
    Journal: TextFile;
    FTrcvActive: boolean;
//  IniFileから読み込んだOptionsの値
    FOptionsData: TOptionsData;
    FQsoMyDataRec: TMyDataRec;
//    FDataBaseExName: string;

    procedure JARLThreadGet(Sender: TObject; const isMember, isQslService: boolean; const QslManager: String);
    procedure LicenceThreadGet(Sender: TObject; const isLicenced: boolean; const RegionName: string);

    function CheckEtc(vTable, vCode: string; var EtcRec: TEtcRec): boolean;
    function CheckFreq(vFreq: Int64; var FreqRec: TFreqRec): boolean;
    function CheckHamLog(vHamLog: string): boolean;
    function CheckIOTA(vEntity, vIOTA: string; var IotaRec: TIotaRec): Boolean;
    function CheckMode(vMode: string; var ModeRec: TModeRec): boolean;
    function CheckQso(var ControlName: string): boolean;
    function CheckOnOffDateTime: boolean;
    function CheckRepeater(vRoute, vRepeater: string; var RepeaterRec: TRepeaterRec): boolean;
    function CheckRoute(vRoute: string; var RouteRec: TRouteRec): boolean;
    function CheckReport(vMode, vReport: string):Boolean;

    procedure DoCleareQso(All: boolean);
    function DoDeleteQsoLog(Num: Integer): Boolean;

    function GetPastQSO(vCallsign, vOrgCallsign: string): boolean;
    function GetCallbookEx(vCallsign:string; vOnDate:tDateTime): Boolean;
    function GetCallbook(vCallsign:string): Boolean;
    procedure GetRegionList_JA;

    function SetFromPastQso(vCallsign, vOrgCallsign: string): boolean;
    function SetFromCallbookEx(vCallsign: string; vDt: TDateTime): Boolean;
    function SetFromCallbook(vCallsign: string): Boolean;
    function SetFromOrgCallbook(vCallsign: string): Boolean;
    function GetQsoFromQsoLog(): Boolean;
    function SetQsoToQsoLog(): Boolean;
//    procedure GetQslCommonList(Qsl: string; var List: TStringList; var Default: string);
    procedure GetQslCommonList(Qsl: string; var List: TStringList);

//    function UpdateCallbook():Boolean;
//    procedure PutCallbook();
//    procedure SetCallbook();

    procedure OutPutJournal(UpDate: string; DataSet: TDataSet);

//    procedure QSLSendMarkSet;
    function AutoBackupDB1(BackupPath: string): boolean;
//    function AutoBackupDB: boolean;
    function CopyDB(Source, Destination: string): boolean;
    procedure ForwardQsoState;

    procedure SettblQsoStringField(FieldName: string; Value: string);
    procedure SettblQsoInt64Field(FieldName: string; Value: Int64);
//    procedure SettblQsoSmallIntField(FieldName: string; Value: smallInt);
    procedure SettblQsoDateTimeField(FieldName: string; Value: TDateTime);

    procedure SetMyDataRec(const Value: TMyDataRec);
    procedure SetMyCallsign(const Value: string);
    procedure SetMyEntity(const Value: string);
    procedure SetMyCountry(const Value: string);
    procedure SetMyRegion(const Value: string);
    procedure SetMyGridLoc(const Value: string);
    procedure SetMyRig(const Value: string);
    procedure SetMyAnt(const Value: string);
    procedure SetMyMemo(const Value: string);
    function GetNewNumOfQsoLog: Integer;
    function PrepareJournal(DataSet: TDataSet): boolean;

//    procedure ChangeMyCallsign(); Virtual;
    procedure ChangeQsoState(QsoState: TQsoState); Virtual;
    procedure ChangeJarlMember(isJarlMember, isQslService: boolean); Virtual;
    procedure ChangeLicence(isLicenced: boolean); Virtual;
//    procedure ChangeComment(); Virtual;
    procedure SetQsoState(const QsoState: TQsoState);
    function GetRegionFromName(RegionName: string; var Region: string): boolean;
//    procedure UpdateFromHamlog(FileAction: TFileAction);
    procedure GetFreqFormatList(var FreqFormatList: TStringList);
    procedure ModifycdsQsoLog;
    procedure SimplifycdsQsoLog;
    procedure ModifycdsQsoLogSel();
    procedure SimplifycdsQsoLogSel();
    procedure ChangeDirAndDist(Longitude, Latitude: string; Level: integer);
    procedure SetProcessing(const Value: TProcessing);
    procedure ChangeProcessing;
    procedure CheckValidEtcRec(vTable: string);
    procedure TrcvRecvInfo(Sender: TObject; Information: TInformation);
//    procedure TrcvClear;
    function cdsQsoCallsignValidate_Edit(Sender: TField): boolean;
    function cdsQsoCallsignValidate_Insert(Sender: TField): boolean;
    function cdsQsoCallsignValidate_Setting(Sender: TField): boolean;
    procedure SetcdsQsoDateTimeField(FieldName: string; Value: TDateTime);
    procedure SetcdsQsoInt64Field(FieldName: string; Value: Int64);
    procedure SetcdsQsoStringField(FieldName, Value: string);
    procedure cdsQsoLargeIntFieldChange(Sender: TField);
    procedure cdsQsoSmallIntFieldChange(Sender: TField);
    procedure cdsStringFieldChange(Sender: TField);
    procedure cdsQsoDateFieldChange(Sender: TField);
    function GetTimeZoneBias(var Bias: Double): boolean;
    function GetHamlogQslList(var QslList: TStringList): boolean;
    function BackupDirExist(BackupPath: string): boolean;
//    function FormatHamlog(InpS, OutS, ErrS: TStringList): boolean;
    function DoDeleteAllQsoLog: boolean;
    procedure ModeCopy;
//    function CopyFile(Source, Destination: string): boolean;
    function GetEntityByEntityCode(EntityCode: string; var EntityRec: TentityRec): boolean;
    function UpdateLotw(Update: string): boolean;
    procedure cdsQsoCALLSIGNValidate_Sub(Country, Callsign: string);
//    function AppendQsoLog(FileAction: TFileAction; DataList: TstringList): boolean;
    function AppendADIF_Sub(Num: integer; Adx: TAdx; var ErrMsg: string; BandList: TstringList): boolean;
    function AppendHamlog_Sub(Num: Integer; InpRec: string; var ErrMsg: string): boolean;
    function AppendCTestWin_Sub(Num: Integer; InpRec: string; var ErrMsg: string; Bias: double; Comment: string): boolean;
    function AppendCabrillo_sub(Num: Integer; InpRec: string; var ErrMsg: string; Bias: double; Comment: string): boolean;
    function AppendZlog_Sub(Num: Integer; InpRec: string; var ErrMsg: string; Bias: double; Comment: string): boolean;
    procedure SetOptionsData(const Value: TOptionsData);
    procedure SetQsoMyDataRec(const Value: TMyDataRec);
//    function CheckNewJCA(Suffix: string; DateTime: TDateTime): boolean;
    function MarkingNetLogRecv_Sub(Num: Integer; Adx: TAdx; NetLogMark: string; var ErrMsg: string; BandList: TStringList): boolean;

  public
    { Public 宣言 }
    property AppPath: string read FAppPath;         // ex. 'D:\LogBase\'   右端に\がある
    property DataBaseName:    string read FDataBaseName;
    property XmlIniFileName:  string read FXmlIniFileName;
//    property DataBaseExName:  string read FDataBaseExName;

    property LowDate: TDateTime read FLowDate;
    property HighDate: TDateTime read FHighDate;
    property TimeZoneInformation: TTimeZoneInformation read FTimeZoneInformation;
    property TimeZoneBiasM: Integer read FTimeZoneBiasM;
    property TimeZoneBiasH: double read FTimeZoneBiasH;
    property TimeZoneBiasD: double read FTimeZoneBiasD;
    property Processing: TProcessing read FProcessing write SetProcessing;
    property SupportQso: TSupportQso Read FSupportQso;
    property QsoState: TQsoState read FQsoState;
    property MyDataRec: TMyDataRec Read FMyDataRec write SetMyDataRec;
    property QsoMyDataRec: TMyDataRec Read FQsoMyDataRec write SetQsoMyDataRec;
    property OptionsData: TOptionsData read FOptionsData write SetOptionsData;
    property Direction: Double Read FDirection;
    property Distance:  Double Read FDistance;

    property QslDefault: String read FQslDefault;
    property QslSendDefault: string read FQslSendDefault;
    property QslRecvDefault: string read FQslRecvDefault;
    property QslSendDate: TDate read FQslSendDate;
    property QslRecvDate: TDate read FQslRecvDate;
    property OnChangeQsoState: TChangeQsoStateEvent read FOnChangeQsoState write FOnChangeQsoState;
    property OnChangeDirAndDist: TChangeDirAndDistEvent read FOnChangeDirAndDist write FOnChangeDirAndDist;
    property OnChangeProcessing: TChangeProcessingEvent read FOnChangeProcessing write FOnChangeProcessing;
    property OnChangeJarlMember: TChangeJarlMemberEvent read FOnChangeJarlMember write FOnChangeJarlMember;
    property OnChangeLicence: TChangeLicenceEvent read FOnChangeLicence write FOnChangeLicence;
    property OnChangeComment: TChangeCommentEvent read FOnChangeComment write FOnChangeComment;
    property TrcvActive: boolean read FTrcvActive;

    function DataBaseClose: boolean;
    function DataBaseOpen: boolean;
    function Prepare(): boolean;
    function ClearQso(Forced: boolean): boolean;
    function DeleteQsoLog(): Boolean;
    function LocateQsoLog(pNum:Integer): Boolean;
    function MoveQsoLog(Direction: TDirection): Boolean;
    function InsertQsoLog(var ControlName: string): Boolean;
    function UpdateQsoLog(var ControlName: string): Boolean;
    function UpdateQslSend(pNum:Integer; pMk:string): Boolean;
    function UpdateQslSendBySQL(Nums: string; pMk: string): Boolean;
//    procedure UpdatNetLogSend_F;
//    procedure UpdatNetLogSend_P;
    function UpdatNetLogRecv(pNum: Integer; pMk: boolean): Boolean;
    function MoveQsoLogSel(Direction: TDirection): boolean;

    function CheckCallsign(vCallsign: string; var CallsignRec: TCallsignRec): boolean;
    function CheckCountry(vCountry: string; var CountryRec: TCountryRec): boolean;
    function CheckEntity(vEntity: string; var EntityRec: TEntityRec): boolean;
    function CheckRegion(vCountry, vRegion: string; var RegionRec: TRegionRec): boolean;
    function CheckZipCode(vCountry, vZipCode: string; var ZipCodeRec: TZipCodeRec): boolean;

    procedure GetBandList(FromBand, ToBand: string; var BandList: TStringList);
    procedure GetContinentList(Entity: string; var ContinentList: TStringList);
    procedure GetCqZoneList(Entity: string; var CqZoneList: TStringList);
    procedure GetEntityList(Prefix, Suffix: string; OnDate: TDateTime; var EntityList: TStringList);
    procedure GetEtcList(Table, Country, Region: string; var List: TStringList);
    procedure GetIOTAListByEntity(Entity: string; var IotaList: TStringList);
    procedure GetIOTAListByRegion(Country, Region: string; var IotaList: TStringList);
    procedure GetItuZoneList(Entity: string; var ItuZoneList: TStringList);
    procedure GetModeList(var ModeList: TStringList);
    procedure GetQslList(var QslList: TStringList);
    procedure GetQsoLog(Num: Integer; var QsoList: TStringList);
    procedure GetQslSendList(var QslSendList: TStringList);
    procedure GetQslRecvList(var QslRecvList: TStringList);
    procedure GetRegionList(Country, Region: string; OnDate: TDateTime; var RegionList: TStringList);
    procedure GetRepeaterList(Route: string; var RepeaterList: TStringList);
    procedure GetRouteList(var RouteList: TStringList);
    procedure GetOptionsData();
    procedure GetMyDataRec();
    procedure SetQsoFromMyDataRec(const Value: TMyDataRec);

    function GetEntityName(vEntity: string): string;

    procedure LocateQsoLogSel(pNum: integer);
    procedure RefreshQsoLogSel;
    procedure SetGLfmBeforeQSO();
    procedure SetIotafmBeforeQSO;

//    function CleareDB: boolean;
    function AutoBackupDB: boolean;
    function BackupDB(): boolean;
    function RestoreDB: boolean;
    procedure AppendADIF;
    procedure AppendCabrillo;
    procedure AppendCTestWin;
    procedure AppendHamlog();
    procedure AppendZlog();
    procedure ExportADIF();
    procedure ExportExcel;
    procedure ExportHamLogCVS();
    procedure ExportQslData();
    procedure ExportText();
    procedure MarkingNetLogSend;
    procedure MarkingNetLogRecv;
    procedure SortQsoLog();
    procedure DeleteAllQsoLog;

    function OpenFindRegion(aCountry: string): boolean;
    function CloseFindRegion: boolean;

    function TrcvOpen(TrcvNo: string): boolean;
    procedure TrcvClose;
    procedure TrcvGetInfo;
    procedure TrcvSetPtt(Ptt: TTrcvPtt);

    procedure ReNewList;

    procedure MarkingQslSend;
    function  SettleJournal: boolean;
    function FormationgQslData(Rec: TFields): string;
end;

var
  Engine: TEngine;

implementation

uses uLogBaseApp, uQsoList, uQsoStatus,
     uProgressDlg, hamlog50, uGridLoc,
     uNetLogDlg, uTimeZoneDlg, uOpenning;

{$R *.DFM}

{ TEngine }
function TEngine.DataBaseOpen(): boolean;
var
  i:  Integer;
//  TempDataBaseName: string;
//  procedure DBRefernceCopy;
//  var
//    TempDB: TIBDataBase;
//    TempTrans: TIBTransaction;
//    TempQuery: TIBQuery;
//    NewVer,OldVer: integer;
//  begin
//// Refernce.FBDが新しくなっているかをチェックし、置き換える
//    NewVer := 0;
//    OldVer := 0;
//    TempDataBaseName :=  FAppDataPath + 'Reference.FDB';    // ProgramFilesで
//    TempDb    :=  TIBDatabase.Create(Self);
//    TempTrans :=  TIBTransaction.Create(self);
//    TempQuery :=  TIBQuery.Create(self);
//    try
//      TempDB.DatabaseName := TempDataBaseName;
//      TempTrans.DefaultDatabase := TempDB;
//      TempQuery.Transaction :=  TempTrans;
//      TempDb.LoginPrompt := false;
//      TempDb.Params.Add('user_name=SYSDBA');
//      TempDB.Params.Add('Password=masterkey');
//      TempDb.Open;
//      TempQuery.SQL.Clear;
//      TempQuery.SQL.Add('SELECT * FROM MANAGER WHERE ID=''Version'';');
//      TempQuery.Open;
//      if TempQuery.RecordCount <> 0 then
//        begin
//        TryStrToInt(TempQuery.FieldByName('Content').AsString, NewVer);
//        end;
//      TempQuery.Close;
//      TempDb.Close;
//
//      try
//        qryCommon.Close;
//        qryCommon.SQL.Clear;
//        qryCommon.SQL.Add('SELECT * FROM MANAGER WHERE ID=''Version'';');
//        qryCommon.Open;
//        if qryCommon.RecordCount <> 0 then
//          begin
//          TryStrToInt(qryCommon.FieldByName('Content').AsString, OldVer);
//          end;
//      except
//        qryCommon.Close;
//      end;
//      if NewVer > OldVer then
//        begin
//        dbReference.Close;
//        DeleteFile(FReferenceDBName);
//        CopyFile(FAppPath + FReferenceDB, FReferenceDBName);
//        dbReference.Open();
//        end;
//    finally
//      DeleteFile(TempDataBaseName);
//      FreeAndNil(TempQuery);
//      FreeAndNil(TempTrans);
//      FreeAndNil(TempDB);
//    end;
//  end;
begin
  result := true;

  dbReference.Close;
  dbReference.DatabaseName  := FReferenceDBName;
  dbReference.Open();
  dbLogBase.Close;
  dbLogBase.DatabaseName    := FDataBaseName;
  dbLogBase.Open();

//  DBRefernceCopy; // ReferenceDBが古いときは複写する

  ModeCopy;
  qryRegion.Open;
  qryEntity.Open;
  tblQsoLog.Open;
  cdsQsoLog.Open;
  cdsQsoLog.Last;
  cdsQsoLogSel.CloneCursor(cdsQsoLog,false,false);
  cdsQsoLogSel.First;

  cdsQso.Open;
  cdsQso.EmptyDataSet;
  cdsQso.Append;
  SetLength(bAutoInput,   cdsQso.Fields.Count);
  SetLength(bManualInput, cdsQso.Fields.Count);
  DoCleareQso(true);
  with cdsQsoStatus do
    begin
    Close;
    Open;
    end;

  for I := 1 to 5 do
    CheckValidEtcRec('Etc' + IntToStr(i));
  GetQslList(pQslList);
  GetQslSendList(pQslSendList);
  GetQslRecvList(pQslRecvList);
  GetFreqFormatList(pFreqFormatList);
  GetBandList('Band', 'Band_M', pBandList_BM);
end;

procedure TEngine.ModeCopy();
begin
//  このTableとQsoLogをQsoStatus用にJoinするためCopyする
//  Table Modeのレイアウト
//  MODE,COLLECTIVEMODE,DEFAULTREPORT,REPORTREGEX,FREQFORMAT,USE
  qryQsoLog.Close;
  qryQsoLog.SQL.Clear;
  qryQsoLog.SQL.Add('DELETE FROM MODE'); //  EmptyDataSetだけでは実データが削除されない為
  qryQsoLog.ExecSQL;
  qryQsoLog.Close;

  qryCommon.Close;
  qryCommon.SQL.Clear;
  qryCommon.SQL.Add('SELECT * FROM MODE');
  qryCommon.Open;
  qryQsoLog.SQL.Clear;
  qryQsoLog.SQL.Add('INSERT INTO MODE VALUES(:p0, :p1, :p2, :p3, :p4, :p5);');
  while not qryCommon.EOF do
    begin
    qryQsoLog.ParamByName('p0').AsString  := qryCommon.Fields[0].AsString;
    qryQsoLog.ParamByName('p1').AsString  := qryCommon.Fields[1].AsString;
    qryQsoLog.ParamByName('p2').AsString  := qryCommon.Fields[2].AsString;
    qryQsoLog.ParamByName('p3').AsString  := qryCommon.Fields[3].AsString;
    qryQsoLog.ParamByName('p4').AsString  := qryCommon.Fields[4].AsString;
    qryQsoLog.ParamByName('p5').AsInteger  := qryCommon.Fields[5].AsInteger;
    qryQsoLog.ExecSQL;
    qryCommon.Next;
    end;
  qryQsoLog.Close;
  qryCommon.Close;
  trnLogBase.Commit;
end;


procedure TEngine.DataModuleCreate(Sender: TObject);
begin
  FDbChanged      := False;   // AutoBackupでもリセットする
// Nullからの変換をエラーにしない
  NullStrictConvert := false;
// 日付定数を定義できないため。OnCreateで定数を設定する。
  FLowDate   :=  StrToDate('1901/01/01');
  FHighDate  :=  StrToDate('2099/12/31');
  GetTimeZoneInformation(FTimeZoneInformation);
  FTimeZoneName   := FTimeZoneInformation.StandardName;
  FTimeZoneBiasM  := - FTimeZoneInformation.Bias;
  FTimeZoneBiasH  := FTimeZoneBiasM / 60;
  FTimeZoneBiasD  := FTimeZoneBiasH / 24;

// 以下は複数User対応のためUser毎のFileを作成
  FAppPath      := ExtractFilePath(Application.ExeName);                // ApplicationのPath
  FMyDocPath    := GetSpecialFolderPath(CSIDL_PERSONAL, false);         // My DocumentsのPath
  if FMyDocPath = '' then
    begin
    MessageDlg('My Documentsが見つからない', mtError, [mbOK], 0);
    LogBaseApp.Close;
    end;
  FMyDocPath    := FMyDocPath + '\';
//  FAppDataPath  := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA, false);    // Application DataのPath
//  if FMyDocPath = '' then
//    begin
//    MessageDlg('Application Dataが見つからない', mtError, [mbOK], 0);
//    LogBaseApp.Close;
//    end;
//  FAppDataPath :=  FAppDataPath + '\LogBase\';
//  if not SysUtils.DirectoryExists(FAppDataPath, true) then              // Application Data内に必要なDirectoryを作成
//    MkDir(FAppDataPath);
  FJournalPath :=  FAppPath + 'Journal\';
//  if not SysUtils.DirectoryExists(FJournalPath, true) then
//    MkDir(FJournalPath);
//  FUserDataPath :=  FAppDataPath + 'User\';
//  if not SysUtils.DirectoryExists(FUserDataPath, true) then
//    MkDir(FUserDataPath);

  FDataBase     :=  'LogBase.FDB';                                      // Application Dataに必要なFileを複製
  FDataBaseName :=  FAppPath + FDataBase;
//  FDataBaseName :=  FAppDataPath + FDataBase;
//  if Not FileExists(FDataBaseName) then
//    begin
//    CopyFile(FAppPath + FDataBase, FDataBaseName);
//    end;
  FReferenceDB     :=  'Reference.FDB';                                 // DbOpen時にVersionを確認して再度複製する必要あり
  FReferenceDBName :=  FAppPath + FReferenceDB;                     // （Referrence.FBDが更新されたとき）
//  FReferenceDBName :=  FAppDataPath + FReferenceDB;                     // （Referrence.FBDが更新されたとき）
//  if Not FileExists(FReferenceDBName) then
//    begin
//    CopyFile(FAppPath + FReferenceDB, FReferenceDBName);
//    end;
  FXmlIniFileName   :=  FAppPath + 'LogBase.xml';
//  FXmlIniFileName   :=  FAppDataPath + 'LogBase.xml';
//  if Not FileExists(FXmlIniFileName) then
//    begin
//    CopyFile(FAppPath + 'LogBase.xml', FXmlIniFileName);
//    end;
//  CopyFiles(FAppPath + 'User\*.*', FUserDataPath);                      // 複数ファイルの複写

  FJournalName    :=  FJournalPath + FormatDateTime('yyyymmdd',now) + '.TXT';  // JournalのFile名作成
  PrepareJournal(cdsQsoLog);

  Trcv := TTransceiver.Create(self);

  pQslList        := TStringList.Create;
  pQslSendList    := TstringList.Create;
  pQslRecvList    := TStringList.Create;
  pFreqFormatList := TStringList.Create;
  pBandList_BM    := TStringList.Create;
  FContinentList  := TStringList.Create;
  FCqZoneList     := TStringList.Create;
  FEntityList     := TStringList.Create;
  FIotaList       := TStringList.Create;
  FItuZoneList    := TStringList.Create;
  FRegionList     := TStringList.Create;
  FRepeaterList   := TStringList.Create;
  FRouteList      := TStringList.Create;

  GetOptionsData;
  GetMyDataRec;
end;

procedure TEngine.DataModuleDestroy(Sender: TObject);
begin
  Engine.AutoBackupDB;
  Engine.SettleJournal;    // Journalの整理をする
  if Assigned(Trcv) then
    begin
    If Trcv.Active then
      Trcv.Close;
    FreeAndNil(Trcv);
    end;

  if Assigned(JarlThread) then
    begin
    JarlThread.Terminate;
    while (JarlThread.Running) do
      Sleep(100);
    FreeAndNil(JarlThread);
    end;
  if Assigned(LicenceThread) then
    begin
    LicenceThread.Terminate;
    while (LicenceThread.Running) do
      Sleep(100);
    FreeAndNil(LicenceThread);
    end;
//  if Assigned(Trcv) then     // 2015/08/15
//    FreeAndNil(Trcv);
  FreeAndNil(pQslList);
  FreeAndNil(pQslSendList);
  FreeAndNil(pQslRecvList);
  FreeAndNil(pFreqFormatList);
  FreeAndNil(pBandList_BM);
  FreeAndNil(FContinentList);
  FreeAndNil(FCqZoneList);
  FreeAndNil(FEntityList);
  FreeAndNil(FIotaList);
  FreeAndNil(FItuZoneList);
  FreeAndNil(FRegionList);
  FreeAndNil(FRePeaterList);
  FreeAndNil(FRouteList);
end;

function TEngine.DataBaseClose(): boolean;
begin
  result := true;
  ClearQso(false);
  SetQsoState(lgClose);
  cdsQso.Close;
  cdsQsoLogSel.Close;
  cdsQsoLog.Close;
  cdsQsoStatus.Close;
  cdsEntity.Close;
  cdsRegion.Close;
  tblQso.Close;
  tblQsoLog.Close;
  qryRegion.Close;
  qryEntity.Close;
  dbLogBase.Close;
  dbReference.Close;
  CoUninitialize;         // COM をシャットダウン
end;

//  使っていない Viewで処理している
procedure TEngine.cdsFindRegionCalcFields(DataSet: TDataSet);
var
  s: string;
begin
  with DataSet do
    begin
    if FieldByName('Country').AsString = 'JPN' then
      s :=  FieldByName('Name1').AsString
        +   FieldByName('Name2').AsString + FieldByName('Name3').AsString
    else
      begin
      s :=  FieldByName('Name1').AsString;
      if FieldByName('Name2').AsString <> '' then
        begin
        s := s + ', ' + FieldByName('Name2').AsString ;
        if FieldByName('Name3').AsString <> '' then
          s := s +  ', ' + FieldByName('Name3').AsString ;
        end;
    end;
    FieldByName('Name').AsString := s;
    end;
end;

/////////////////////////////////////////////////////////////////////////////
//
//  Qsoに関する処理
//
/////////////////////////////////////////////////////////////////////////////
//  現在レコードをクリアする
function TEngine.ClearQso(Forced: boolean): boolean;
var
  s: string;
begin
  result  := true;
  if not Forced then
    begin
    if (FQsoState = lgInsert) or (FQsoState = lgEdit) then
      begin
      s := '入力したデータはまだ登録されていない。' + #13
         + '登録しないままでクリアしてよいか？';
      if MessageDlg(s,mtConfirmation,[mbYes,mbNo],0) = mrNo then
        Exit(false);
      end;
    end;
  if QsoState = lgClose  then
    exit(true);
  DoCleareQso(True);   //  全項目クリア
  SetQsoState(lgClear);
end;

procedure TEngine.DoCleareQso(All: boolean);
var
  i:  integer;
begin
  with FSupportQso do
    begin
    CountryName    := '';
    RegionName     := '';
    EntityName     := '';
    IOTAName       := '';
    ETCName[1]     := '';
    ETCName[2]     := '';
    ETCName[3]     := '';
    ETCName[4]     := '';
    ETCName[5]     := '';
    Latitude       := '';
    Longitude      := '';
    Comment        := '';
    DefaultFreqFormat := '#0.0000;;#';
    end;
  QsoMyDataRec   :=  FMyDataRec;
  cdsQso.CancelUpdates;
  cdsQso.Append;
  for i := 0 to cdsQso.Fields.Count - 1 do
    begin
    if All or (UpperCase(cdsQso.Fields[i].FieldName) <> 'CALLSIGN') then
      begin
      bAutoInput[i]   := -1;      //  OnValidate,OnChangeを実行させないため
      if cdsQso.Fields[i].DataType = ftWideString then  // Nullになるのを防ぐため  2017/08/13
        cdsQso.Fields[i].asString := ''
      else
        cdsQso.Fields[i].Clear;
      bAutoInput[i]   := 0;
      bManualInput[i] := false;
      end;
    end;
  if QsoState <> lgClose then
    begin
    i := cdsQsoCq.Index;
    bAutoInput[i]   := -1;      //  OnValidate,OnChangeを実行させないため
    i := cdsQsoSwl.Index;
    bAutoInput[i]   := -1;      //  OnValidate,OnChangeを実行させないため
    cdsQsoCq.AsInteger  := PrevQso.CQ;
    cdsQsoSWL.AsInteger := kFalse;
    if Processing = prBatch then
      begin
      cdsQsoOnDateTime.AsDateTime := PrevQso.OnDateTime;
      cdsQsoFreq.AsInteger        := PrevQso.Freq;
      cdsQsoMode.AsString         := PrevQso.Mode;
      end;
    SetQsoFromMyDataRec(QsoMyDataRec);
    bAutoInput[i]   := 0;
    bManualInput[i] := false;
    end;
  SetQsoState(lgClear);

  ChangeJarlMember(false, false);
  ChangeLicence(false);
  ChangeDirAndDist('', '', 0);
end;

function TEngine.GetQsoFromQsoLog(): Boolean;
var
  fd: TField;
  Event: TFieldNotifyEvent;

  i: integer;
  wMyData: TMyDataRec;
  wCallsignRec: TCallsignRec;
  wEntityRec: TEntityRec;
begin
  with wMyData do                 // テーブルQSOにデータを設定す前に処理する必要あり
    begin
    MyCallsign   := cdsQsoLog.FieldByName('MyCallsign').AsString;
    MyCountry    := cdsQsoLog.FieldByName('MyCountry').AsString;
    MyRegion     := cdsQsoLog.FieldByName('MyRegion').AsString;
    MyEntity     := cdsQsoLog.FieldByName('MyEntity').AsString;
    MyGridLoc    := cdsQsoLog.FieldByName('MyGridLoc').AsString;
    MyRig        := cdsQsoLog.FieldByName('MyRig').AsString;
    MyAnt        := cdsQsoLog.FieldByName('MyAnt').AsString;
    MyMemo       := cdsQsoLog.FieldByName('MyMemo').AsString;
    end;
  QsoMyDataRec  :=  wMyData;

  for fd in cdsQsoLog.Fields do
    begin
    if fd.FieldKind = fkData  then
      begin
      Event := cdsQso.FieldByName(fd.FieldName).OnValidate;
      cdsQso.FieldByName(fd.FieldName).OnValidate := nil;
      Inc(bAutoInput[cdsQso.FieldByName(fd.FieldName).Index]);
      case fd.DataType of
        ftWideString:
          begin
          cdsQso.FieldByName(fd.FieldName).AsString :=  trim(fd.AsString);
          end;
        ftDateTime:
          if fd.AsString <> '' then
            cdsQso.FieldByName(fd.FieldName).AsDateTime :=  fd.AsDateTime + FTimeZoneBiasD
          else
            cdsQso.FieldByName(fd.FieldName).AsDateTime :=  null;
        else
          cdsQso.FieldByName(fd.FieldName).Value   :=  fd.Value;
        end;
      Dec(bAutoInput[cdsQso.FieldByName(fd.FieldName).Index]);
      cdsQso.FieldByName(fd.FieldName).OnValidate := event;
      end;
    end;

  for i := 0 to High(bManualInput) do
    bManualInput[i] := false;

  CheckCallsign(cdsQsoCallsign.AsString, wCallsignRec);    // CallsignからOrgCallsign,Prefix,
  if wCallsignRec.result then
//      if Pos(Value, cdsQsoOrgCallsign.Value) = 0 then
      begin
      FSupportQso.Area  :=  wCallsignRec.Area;
//      SetTblQsoStringField('OrgCallsign', wCallsignRec.OrgCallsign);
//      SetTblQsoStringField('Prefix', wCallsignRec.Prefix);
//      SetTblQsoStringField('Suffix', wCallsignRec.Suffix);
      end;


// AppendしたデータでCountryが設定されていないときの処理
  if (cdsQsoEntity.Value <> '') and (cdsQsoCountry.Value = '') then
    begin
    CheckEntity(cdsQsoEntity.Value, wEntityRec);
    if wEntityRec.result then
      begin
      SetcdsQsoStringField('Country', wEntityRec.Country);
      SetcdsQsoStringField('Continent', wEntityRec.Continent);
      SetcdsQsoStringField('ItuZone', wEntityRec.ItuZone);
      SetcdsQsoStringField('CqZone', wEntityRec.CqZone);
//      ChangeDirAndDist(wEntityRec.Longitude, wEntityRec.Latitude, 1);
      end;
    end;

  Result := true;
end;

function TEngine.SetQsoToQsoLog(): Boolean;
var
  fd: TField;
  Event: TDataSetNotifyEvent;
begin
// FieldのValueを設定するごとにOnCalcFieldsエベントが発生するので、それを避ける為
// EventをNilにする
  event := cdsQsoLog.OnCalcFields;
  cdsQsoLog.OnCalcFields := nil;
  for fd in cdsQso.Fields do
    begin
    if fd.DataType = ftDateTime then
      if fd.AsString <> '' then
        cdsQsoLog.FieldByName(fd.FieldName).AsDateTime :=  fd.AsDateTime - FTimeZoneBiasD
      else
        cdsQsoLog.FieldByName(fd.FieldName).AsString :=  ''
    else
      begin
      cdsQsoLog.FieldByName(fd.FieldName).Value   :=  fd.Value;
      end;
    end;
  cdsQsoLog.OnCalcFields := event;
  Result := true;
end;

function TEngine.CheckQso(var ControlName: string):boolean;
var
  s: string;
begin
   s := '';
  ControlName := '';
  if cdsQsoCallsign.AsString ='' then
    begin
    s := 'Callsignが入力されていないため、保存できません。';
    ControlName := 'Callsign';
    end
  else if cdsQsoOnDateTime.Value = null then
    begin
    s := 'OnDateTimeが入力されていないため、保存できません。';
    ControlName := 'OnDate';
    end
  else if cdsQsoFreq.AsLargeInt = 0 then
    begin
    s := 'Freqが入力されていないため、保存できません。';
    ControlName := 'Freq';
    end
  else if cdsQsoMode.AsString = '' then
    begin
    s := 'Modeが入力されていないため、保存できません。';
    ControlName := 'Mode';
    end
  else if cdsQsoHisReport.AsString = '' then
    begin
    s := 'HisReportが入力されていないため、保存できません。';
    ControlName := 'HisReport';
    end
  else if cdsQsoMyReport.AsString = '' then
    begin
    s := 'MyReportが入力されていないため、保存できません。';
    ControlName := 'MyReport';
    end;
  if s = '' then
    Result := true
  else
    begin
    MessageDlg(s, mtError, [mbOK], 0);
    Result := false;
    end;
end;

procedure TEngine.SetQsoMyDataRec(const Value: TMyDataRec);
  var
  wEntityRec:  TEntityRec;
  wRegionRec: TRegionRec;
begin
  FQsoMyDataRec := Value;

  CheckEntity(FQsoMyDataRec.MyEntity, wEntityRec);
  FQsoMyDataRec.MyEntityName := wEntityRec.Name;
  CheckRegion(FQsoMyDataRec.MyCountry, FQsoMyDataRec.MyRegion, wRegionRec);
  FQsoMyDataRec.MyRegionName := wRegionRec.Name;
end;

procedure TEngine.SetQsoFromMyDataRec(const Value: TMyDataRec);
begin
  SetMYCallsign(Value.MyCallsign);
  SetMyEntity(Value.MyEntity);
  SetMyCountry(Value.MyCountry);
  SetMyRegion(Value.MyRegion);
  SetMyGridLoc(Value.MyGridLoc);
  SetMyRig(Value.MyRIG);
  SetMyAnt(Value.MyAnt);
  SetMyMemo(Value.MyMemo);
end;

procedure TEngine.SetQsoState(const QsoState: TQsoState);
begin
  FQsoState   := QsoState;
  ChangeQsoState(FQsoState);
end;

/////////////////////////////////////////////////////////////////////////////
//
//  QsoLog,QsoLogに関する共通処理
//
/////////////////////////////////////////////////////////////////////////////
procedure TEngine.ReNewList;
begin
  if FQsoState = lgInsert then
    begin
    with Engine.cdsQsoLogSel do
      begin
      Last;
      end;
    with Engine.cdsQsoLog do
      begin
      Last;
      end;
    end;
end;

/////////////////////////////////////////////////////////////////////////////
//
//  QsoLogに関する処理
//
/////////////////////////////////////////////////////////////////////////////
//  現在レコードを削除する
function TEngine.DeleteQsoLog(): Boolean;
var
  s: string;
begin
  Result := false;
  if (FQsoState = lgEdit) or (FQsoState = lgBrowse) then
    begin
    s := '表示中のデータを削除してよいか？';
    if MessageDlg(s,mtConfirmation,[mbYes,mbNo],0) = mrNo then
      exit;
    if DoDeleteQsoLog(cdsQsoNum.Value) then
      begin
      DoCleareQso(True);
      SetQsoState(lgClear);
      end;
    end;
end;

function TEngine.DoDeleteQsoLog(Num:Integer): Boolean;
begin
  result := true;
  try
    with cdsQsoLog do
      begin
      if cdsQsoNum.Value <> Num then
        cdsQsoLog.Locate('Num', Num, []);
      if cdsQsoNum.Value = Num then
        begin
        if not trnLogBase.InTransaction then
          trnLogBase.StartTransaction;
        Delete;
        cdsQsoLog.ApplyUpdates(1);
        trnLogBase.Commit;
        end
      else
        raise EValueWarningError.Create('');
      end;
  except
    MessageDlg('DoDeleteQso　----ERROR ',mtInformation	, [mbYes],0);
    result := False;
  end;
end;

procedure TEngine.dsQsoLogStateChange(Sender: TObject);
begin

end;

//  指定レコードに位置ずける
function TEngine.LocateQsoLog(pNum:Integer): Boolean;
var
  s: string;
begin
  result  := false;
  try
    if (FQsoState = lgInsert) or (FQsoState = lgEdit) then
      begin
      s := '入力データはまだ登録されていない。' + #13
         + '入力データをクリアしてよいか？';
      if MessageDlg(s,mtConfirmation,[mbYes,mbNo],0) = mrNo then
        exit;
      end;
    cdsQsoLog.DisableControls;
    if not cdsQsoLog.Locate('Num', pNum, []) then
      exit;
    cdsQsoLog.EnableControls;
    SetQsoState(lgSetting);
    ChangeDirAndDist('', '', 0);
    GetQsoFromQsoLog();
    SetQsoState(lgBrowse);

    cdsQsoCALLSIGNValidate_Sub(cdsQsoCountry.AsString, cdsQsoCallsign.AsString);
//    ChangeJarlMember(false, false);
//    ChangeLicence(false);
    result := true;
  except
    MessageDlg('LocateQso　----ERROR ',mtInformation	, [mbYes],0);
  end;
end;

//  前後レコードに位置ずける（Brows時のみ）
function TEngine.MoveQsoLog(Direction: TDirection): Boolean;
begin
  result  := false;
  if cdsQsoLog.RecordCount <= 0 then
    exit;
  try
    cdsQsoLog.DisableControls;
    if Direction = drNext then
      if cdsQsoLog.Eof then
        cdsQsoLog.First
      else
        cdsQsoLog.Next
    else
      if cdsQsoLog.Bof then
        cdsQsoLog.Last
      else
        cdsQsoLog.Prior;
    cdsQsoLog.EnableControls;
    SetQsoState(lgSetting);
    ChangeDirAndDist('', '', 0);
    GetQsoFromQsoLog();
    SetQsoState(lgBrowse);
    ChangeJarlMember(false, false);
    ChangeLicence(false);
    result := true;
  except
    MessageDlg('MoveQsoLog　----ERROR ',mtInformation	, [mbYes],0);
  end;
end;

//  新規レコードを挿入する
function TEngine.InsertQsoLog(var ControlName: string): Boolean;
begin
  result := false;
  try
    //  ControlNameは必須項目が入力されていない時、それを返す
    if not CheckQso(ControlName) then
      exit;
    cdsQsoNum.Value := GetNewNumOfQsoLog;
    with cdsQsoLog do
      begin
      if not trnLogBase.InTransaction then
        trnLogBase.StartTransaction;
      cdsQsoLog.Append;
      SetQsoToQsoLog();
      cdsQsoLog.Post;
      cdsQsoLog.ApplyUpdates(1);  // パラメータはMaxError
      trnLogBase.Commit;
      cdsQsoLog.Last;
      end;
//    TrcvClear; //
    with  PrevQso do  //  次のレコードのために、現在値を保存する
      begin
      Num         :=  cdsQsoNum.Value;
      CQ          :=  cdsQsoCq.Value;
      OnDateTime  :=  cdsQsoOnDateTime.Value;
      if (TRCV <> nil) and (Trcv.Active) then
        begin
        Freq        :=  0;
        RecvFreq    :=  0;
        end
      else
        begin
        Freq        :=  cdsQsoFreq.Value;
        RecvFreq    :=  cdsQsoRecvFreq.Value;
        end;
      Route       :=  cdsQsoRoute.Value;
      Repeater    :=  cdsQsoRepeater.Value;
      HisReport   :=  cdsQsoHisReport.Value;
      MyReport    :=  cdsQsoMyReport.Value;
      Mode        :=  cdsQsoMode.Value;
      end;
    DoCleareQso(True);

    result  := true;
    if FProcessing = prRealTime then  // RealTime/Batch切り替え判断
      begin
      if isQsoDateOver then
        begin
        Inc(iDateOverCnt);
        if iDateOverCnt = 2 then
          begin
          Processing := prBatch;
          end;
        end
      else
        begin
        iDateOverCnt := 0;
        end;
      end;
  except
    begin
    MessageDlg('InsertQso　----ERROR ' ,mtInformation	, [mbYes],0);
//    MessageDlg('InsertQso　----ERROR ' + IntTostr(ErrLine),mtInformation	, [mbYes],0);
    end;
  end;
end;

//  現在レコードを置き換える
function TEngine.UpdateQsoLog(var ControlName: string): Boolean;
begin
  result := false;
  try
    if not CheckQso(ControlName) then
      exit;
    cdsQsoLog.DisableControls;
    if cdsQsoLog.FieldByName('Num').AsInteger <> cdsQsoNum.Value then
      cdsQsoLog.Locate('Num', cdsQsoNum.Value, []);
    if cdsQsoLog.FieldByName('Num').AsInteger = cdsQsoNum.Value then
      begin
      if not trnLogBase.InTransaction then  // 同一レコードを続けて2度Editしようとすると、2度目はトランザクションがStartしていない
        trnLogBase.StartTransaction;
      cdsQsoLog.Edit;
      SetQsoToQsoLog();
      cdsQsoLog.Post;
      cdsQsoLog.ApplyUpdates(1);  // パラメータはMaxError
      trnLogBase.Commit;
      end
    else
      MessageDlg('更新対象のQSOが見つからない ', mtInformation	, [mbYes],0);
    cdsQsoLog.EnableControls;
    DoCleareQso(True);
    result  := true;
  except
    MessageDlg('UpdateQso　----',mtInformation	, [mbYes],0);
  end;
end;

function TEngine.UpdatNetLogRecv(pNum:Integer; pMk:boolean): Boolean;
begin
  Result := false;
  try
    with cdsQsoLog do
      if Locate('Num', pNum, []) then
        begin
        Edit;
        if pMk then
          begin
          cdsQsoQslRecv.Value           := FQslRecvDefault;
          if FQslRecvDate <> LowDate then
            cdsQsoQslRecvDate.AsDateTime  := FQslRecvDate;
          end
        else
          begin
          cdsQsoQslRecv.Value           := '';
          cdsQsoQslRecvDate.Clear;
          end;
          SetQsoToQsoLog();
          Post;
          ApplyUpdates(1);  // パラメータはMaxError
        SetQsoState(lgBrowse);
        Result := True;
        end;
  except
    MessageDlg('UpdateQsoSendMk　----ERROR ',mtInformation	, [mbYes],0);
  end;
end;

// MMQSLのsenndoマーク設定
function TEngine.UpdateQslSend(pNum:Integer; pMk:string): Boolean;
begin
  Result := false;
  try
    with cdsQsoLog do
      if Locate('Num', pNum, []) then
        begin
        Edit;
        cdsQsoLogQslSend.asString         := pMk;
        if FQslSendDate <> LowDate then
          cdsQsoLogQslSendDate.AsDateTime   := FQslSendDate;
        Post;
        ApplyUpdates(1);  // パラメータはMaxError
        Result := True;
        end;
  except
    MessageDlg('UpdateQslSend　----ERROR ',mtInformation	, [mbYes],0);
  end;
end;

function TEngine.UpdateQslSendBySQL(Nums: string; pMk:string): Boolean;
var
  sSQl: string;
begin
  result := true;
  try
    if (FQsoState <> lgClear) and (FQsoState <> lgBrowse) then
      begin
      result := false;
      exit;
      end;

    Screen.Cursor := crHourGlass;

    if FQslSendDate <> LowDate then
      sSql  :=  'UPDATE QSOLOG Set QSLSEND = :QSLSEND, QSLSENDDATE = :QSLSENDDATE '
          +   'WHERE NUM IN ( ' + NUMS + ')'        // パラメータを使用すると["]で囲われる
    else
      sSql  :=  'UPDATE QSOLOG Set QSLSEND = :QSLSEND '
          +   'WHERE NUM IN ( ' + NUMS + ')';        // パラメータを使用すると["]で囲われる
    qryQsoLog.Close;
    qryQsoLog.SQL.Clear;
    qryQsoLog.SQL.Add(sSql);
    qryQsoLog.ParamByName('QSLSEND').AsString   :=  pMk;
    if FQslSendDate <> LowDate then
      qryQsoLog.ParamByName('QSLSENDDATE').AsDate := FQslSendDate;
    qryQsoLog.ExecSQL;
    cdsQsoLog.Refresh;
    cdsQsoLogSel.Refresh;

    Screen.Cursor := crDefault;
  except
    result  :=  false;
    Screen.Cursor := crDefault;
  end;
end;

// 最終Numを得るため
function TEngine.GetNewNumOfQsoLog(): Integer;
begin
  with qryQsoLog do
    begin
    Close;
    Sql.Clear;
    Sql.Add('SELECT MAX(NUM) AS MaxNum FROM QSOLOG;');
    Open;
    if RecordCount = 0 then
      Result := 1
    else
      begin
      Result := Fields[0].AsInteger + 1;
      end;
    Close;
    end;
end;

procedure  TEngine.DeleteAllQsoLog;
var
  s: string;
begin
  s := 'QSoLogの全データを削除します。'#13
     + 'このまま続けますか？';
  if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0,mbNo) = mrNo then
    exit;
  DoDeleteAllQsoLog;
end;

function TEngine.DoDeleteAllQsoLog(): boolean;
begin
//  QsoLogのデータをクリア
  result := true;
  qryQsoLog.Close;
  qryQsoLog.SQL.Clear;      //  EmptyDataSetだけでは実データが削除されない為
  qryQsoLog.SQL.Add('DELETE FROM QSOLOG');
  qryQsoLog.ExecSQL;
  qryQsoLog.Close;
  cdsQsoLog.EmptyDataSet;
  cdsQsoLog.ApplyUpdates(-1);
  cdsQsoLog.Refresh;
end;

//  以下の3つのprocedureは、QsoListの移動の高速化のため
procedure TEngine.ModifycdsQsoLog;
begin
  cdsQsolog.BeforeDelete  := cdsQsoLogBeforeDelete;
  cdsQsoLog.OnCalcFields  := cdsQsoLogCalcFields;
  cdsQsoLog.BeforePost    := cdsQsoLogBeforePost;
  cdsQsoLog.Fields.Add(cdsQsoLogQslG);
  cdsQsoLog.Fields.Add(cdsQsoLogRegionName);
  cdsQsoLog.Fields.Add(cdsQsoLogEntityName);
end;

procedure TEngine.SimplifycdsQsoLog;
begin
  cdsQsoLog.BeforeDelete  := nil;
  cdsQsoLog.OnCalcFields  := nil;
  cdsQsoLog.BeforePost    := nil;
  cdsQsoLog.Fields.Remove(cdsQsoLogQslG);
  cdsQsoLog.Fields.Remove(cdsQsoLogRegionName);
  cdsQsoLog.Fields.Remove(cdsQsoLogEntityName);
end;

/////////////////////////////////////////////////////////////////////////////
//
//  QsoLogSelに関する処理
//
/////////////////////////////////////////////////////////////////////////////
procedure TEngine.RefreshQsoLogSel();
begin                                  // 使われていない？
  cdsQsoLogSel.Close;
  cdsQsoLogSel.Open;
end;

procedure TEngine.LocateQsoLogSel(pNum: integer);
var
  aDataSet: tDataSet;
begin
//  SimplifycdsQsoLogSel;
  aDataSet  :=  dsQsoLogSel.DataSet;
  if pNum = 0 then
    begin
    aDataSet.First;
    exit;
    end;
  if pNum = -1 then
    begin
    aDataSet.Last;
    exit;
    end;
  if not aDataSet.Locate('Num', pNum, []) then
    begin
//    MessageDlg('Cannot List Locate ', mtInformation, [mbYes],0);
    end;
//  ModifycdsQsoLogSel;
end;


// 以下どこで使っているか？
function TEngine.MoveQsoLogSel(Direction: TDirection): boolean;
var
  num: integer;
  aDataSet: tDataSet;
begin
  result  := false;
  aDataSet  :=  dsQsoLogSel.DataSet;
  if aDataSet.RecordCount <= 0 then
    exit;
  try
    aDataSet.DisableControls;
    if Direction = drNext then
      if aDataSet.Eof then
        aDataSet.First
      else
        aDataSet.Next
    else
      if aDataSet.Bof then
        aDataSet.Last
      else
        aDataSet.Prior;
    aDataSet.EnableControls;
    num := aDataSet.FieldByName('Num').AsInteger;
    LocateQsoLog(Num);
    LocateQsoLogSel(Num);
    result := true;
  except
    MessageDlg('MoveQsoLog　----ERROR ',mtInformation	, [mbYes],0);
  end;
end;

procedure TEngine.ModifycdsQsoLogSel();
var
  aDataSet: tDataSet;
begin
  aDataSet  :=  dsQsoLogSel.DataSet;
  aDataSet.OnCalcFields  := cdsQsoLogCalcFields;
  aDataSet.Fields.Add(cdsQsoLogSelQslG);
  aDataSet.Fields.Add(cdsQsoLogSelRegionName);
  aDataSet.Fields.Add(cdsQsoLogSelEntityName);
end;

procedure TEngine.SimplifycdsQsoLogSel();
var
  aDataSet: tDataSet;
begin
  aDataSet  :=  dsQsoLogSel.DataSet;
  aDataSet.OnCalcFields  := nil;
  aDataSet.Fields.Remove(cdsQsoLogSelQslG);
  aDataSet.Fields.Remove(cdsQsoLogSelRegionName);
  aDataSet.Fields.Remove(cdsQsoLogSelEntityName);
end;

///////////////////////////////////////////////////////////////////////////////
//
//  cdsQsoの各項目のEVEN処理
//
///////////////////////////////////////////////////////////////////////////////
procedure TEngine.SetcdsQsoDateTimeField(FieldName: string; Value: TDateTime);
var
  fd: TField;
begin
  fd := cdsQso.FieldByName(FieldName);
  Inc(bAutoInput[fd.Index]);
  if not bManualInput[fd.Index] then
    fd.Value  := value;
  Dec(bAutoInput[fd.Index]);
end;

procedure TEngine.SetcdsQsoInt64Field(FieldName: string; Value: Int64);
var
  fd: TField;
begin
  fd := cdsQso.FieldByName(FieldName);
  Inc(bAutoInput[fd.Index]);
  if not bManualInput[fd.Index] then
    fd.Value  := value;
  Dec(bAutoInput[fd.Index]);
end;

procedure TEngine.SetcdsQsoStringField(FieldName, Value: string);
var
  fd: TField;
begin
  fd := cdsQso.FieldByName(FieldName);
  Inc(bAutoInput[fd.Index]);
  if not bManualInput[fd.Index] then
    fd.Value  := value;
  Dec(bAutoInput[fd.Index]);
end;

//procedure TEngine.swl(Sender: TField);
//var
//  Value: string;
//begin
//  if bAutoInput[cdsQsoCallsign.Index] = -1 then
//    exit;
//  TField(Sender).OnChange := nil;
//  try
//    Value := trim(Sender.Value);
//    if Value <> Sender.Value then
//      Sender.Value  :=  Value;
//    if  bAutoInput[cdsQsoCallsign.Index] = 0 then
//      bManualInput[cdsQsoCallsign.Index] := True;
//  finally
//    TField(Sender).OnChange := cdsQsoCallsignChange;
//  end;
//end;

procedure TEngine.cdsQsoCALLSIGNChange(Sender: TField);
var
  Value: string;
begin
  if bAutoInput[cdsQsoCallsign.Index] = -1 then
    exit;
  TField(Sender).OnChange := nil;
  try
    Value := trim(Sender.Value);
    if Value <> Sender.Value then
      Sender.Value  :=  Value;

////////////////////////////////////////////////////////////////////////
//      dStartTime := cdsQsoOnDateTime.AsDateTime;
//      dStartTime := now();
//      if Assigned(JarlThread)  then
//        begin
//        if cdsQsoCountry.AsString = 'JPN' then
//          jarlThread.Callsign := cdsQsoOrgCallsign.Value
//        else
//          jarlThread.Callsign := cdsQsoCallsign.Value;
//        jarlThread.Execute;
//        end;
//        dEndTime := now;
//
//      if (cdsQsoCountry.Value = 'JPN') and (cdsQsoOrgCallsign.Value <> '') then
//        if Assigned(LicenceThread) then
//          begin
//          LicenceThread.Callsign := cdsQsoOrgCallsign.Value;
//          LicenceThread.Execute;
//          end;

    if  bAutoInput[cdsQsoCallsign.Index] = 0 then
      bManualInput[cdsQsoCallsign.Index] := True;
  finally
    TField(Sender).OnChange := cdsQsoCallsignChange;
  end;
end;

procedure TEngine.cdsQsoCALLSIGNValidate(Sender: TField);
begin
  if bAutoInput[cdsQsoCallsign.Index] = -1 then
    exit;
  case FQsoState of
  lgClear:
    begin
    if not cdsQsoCallsignValidate_Insert(sender) then
      abort;
    SetQsoState(lgTramp);
    end;
  lgSetting:
    begin
    if not cdsQsoCallsignValidate_Setting(sender) then
      Abort;
    end;
  lgBrowse, lgEdit:
    begin
    if not cdsQsoCallsignValidate_Edit(sender) then
      abort;
    SetQsoState(lgEdit);
    end;
  lgTramp:
    begin
    DoCleareQso(False);
    if not cdsQsoCallsignValidate_Insert(sender) then
      abort;
    SetQsoState(lgTramp);
    end;
  lgInsert:
    begin
    if not cdsQsoCallsignValidate_Insert(sender) then
      Abort;
    end
  end;
end;

procedure TEngine.cdsQsoCALLSIGNValidate_Sub(Country, Callsign: string);
begin
//      dStartTime := cdsQsoOnDateTime.AsDateTime;
  dStartTime := now();
  if Callsign <> '' then
    if Assigned(JarlThread)  then
      begin
      jarlThread.Callsign := Callsign;
      jarlThread.Execute;
      end;
  dEndTime := now;

  if (Country = 'JPN') and (Callsign <> '') then
    if Assigned(LicenceThread) then
      begin
      LicenceThread.Callsign := Callsign;
      LicenceThread.Execute;
      end;
end;

function TEngine.cdsQsoCallsignValidate_Edit(Sender: TField): boolean;
var
  Value: string;
  wCallsignRec:  TCallsignRec;
begin
  result := true;

  Value := trim(Sender.Value);
  if Value = '' then
    exit;

  if (FQsoState = lgBrowse) or (FQsoState = lgEdit)
  or  (FQsoState = lgSetting) then
    CheckCallsign(Value, wCallsignRec);    // CallsignからOrgCallsign,Prefix,
    if wCallsignRec.result then
//      if Pos(Value, cdsQsoOrgCallsign.Value) = 0 then
        begin
        SetTblQsoStringField('OrgCallsign', wCallsignRec.OrgCallsign);
        SetTblQsoStringField('Prefix', wCallsignRec.Prefix);
        SetTblQsoStringField('Suffix', wCallsignRec.Suffix);
        end;
//      else
//        if Pos(wCallsignRec.Prefix, cdsQsoPrefix.Value) = 0 then
//          begin
  //  用検討　Prefixをマニュアルで変更されたときの検出方法
  //        Inc(bAutoInput[cdsQsoPrefix.Index]);
  //        cdsQsoPrefix.Value          := wCallsign.Prefix;
  //        Dec(bAutoInput[cdsQsoPrefix.Index]);
  //        FQso.Area := wCallsign.Area;
//          end;

  GetCallbook(cdsQsoOrgCallsign.Value);
  FSupportQso.Comment                    := PCallbook.Comment;

//        if cdsQsoCountry.AsString = 'JPN' then
//          cdsQsoCALLSIGNValidate_Sub(cdsQsoCountry.AsString, cdsQsoOrgCallsign.Value)
//        else
//          cdsQsoCALLSIGNValidate_Sub(cdsQsoCountry.AsString, cdsQsoCallsign.Value);
//

  cdsQsoCALLSIGNValidate_Sub(cdsQsoCountry.AsString, cdsQsoCallsign.AsString);

  if Assigned(QsoList) then
    begin
    QsoList.FilterByCallsign(cdsQsoOrgCallsign.Value);
    end;
end;

function TEngine.cdsQsoCallsignValidate_Insert(Sender: TField): boolean;
var
  Value: string;
  dt: TDateTime;
  wCallsignRec:  TCallsignRec;
  wEntityList: TStringList;
begin
  result := true;
  wEntityList := TStringList.Create;
  try
    try
      Value := trim(Sender.Value);
      if Value = '' then
        exit;
      if cdsQsoSwl.Value = kTrue then         // SWLの時は判断しない
        SetTblQsoStringField('OrgCallsign', value)   //
      else
        begin
        CheckCallsign(Value, wCallsignRec);    // CallsignからOrgCallsign,Prefix,等を生成
        if wCallsignRec.result then
          begin
          SetTblQsoStringField('OrgCallsign', wCallsignRec.OrgCallsign);
          SetTblQsoStringField('Prefix', wCallsignRec.Prefix);
          SetTblQsoStringField('Suffix', wCallsignRec.Suffix);
          FSupportQso.Area := wCallsignRec.Area;
          end
        end;

      GetCallbook(wCallsignRec.OrgCallsign);
      FSupportQso.Comment                    := PCallbook.Comment;
      if Assigned(QsoList) then
        begin
        QsoList.FilterByCallsign(wCallsignRec.OrgCallsign);
        end;

//  日付・時刻自動設定
      if (FProcessing = prRealTime) and (cdsQsoSwl.AsInteger = kFalse) then
        begin
        SetTblQsoDateTimeField('OnDateTime', Now);
        end
      else
        begin
        SetTblQsoDateTimeField('OnDateTime', PrevQso.OnDateTime);
        end;

//  周波数・モード等自動設定
      if (Trcv <> nil) and (Trcv.Active) then
        TrcvGetInfo
      else
        begin
        SetTblQsoInt64Field('Freq', PrevQso.Freq);
        SetTblQsoInt64Field('RecvFreq', PrevQso.RecvFreq);
        if PrevQso.Mode <> ''  then
          begin
          SetTblQsoStringField('Mode', PrevQso.Mode);
//          SetTblQsoStringField('HisReport', PrevQso.HisReport);     // 20151104 Ver1.1.3
//          SetTblQsoStringField('MyReport', PrevQso.MyReport);       // 20151104 Ver1.1.3
          SetTblQsoStringField('HisReport', cModeRec.DefaultReport);  // 20151104 Ver1.1.3
          SetTblQsoStringField('MyReport', cModeRec.DefaultReport);   // 20151104 Ver1.1.3
          SetTblQsoStringField('Route', PrevQso.Route);
          SetTblQsoStringField('Repeater', PrevQso.Repeater);
          end;
        end;

//  過去QSO,Callbookなどの参照
      if not SetFromPastQso(Value, cdsQsoOrgCallsign.Value)  then
        if not SetFromCallbookEx(Value, cdsQsoOnDateTime.Value)  then
          begin
          SetFromCallbook(Value);
          if cdsQsoName.AsString = '' then
            SetFromOrgCallbook(cdsQsoOrgCallsign.AsString);
          end;

//  ここまででEntityが設定されていないとEntity自動設定
      if cdsQsoEntity.Value = '' then
        begin
        dt := cdsQsoOnDateTime.Value;
        GetEntityList(cdsQsoPrefix.Value, cdsQsoSuffix.Value, dt, wEntityList);
        if wEntityList.Count <> 0 then
          begin
          if cdsQsoEntity.Value = '' then                                     // V1.0.0.6 Insert
            SetTblQsoStringField('Entity', wEntityList.Names[0]);
          end;
        end;

//      dStartTime := now;
//      if Assigned(JarlThread)  then
        begin
        if cdsQsoCountry.AsString = 'JPN' then
          cdsQsoCALLSIGNValidate_Sub(cdsQsoCountry.AsString, cdsQsoOrgCallsign.Value)
        else
          cdsQsoCALLSIGNValidate_Sub(cdsQsoCountry.AsString, cdsQsoCallsign.Value)
//          jarlThread.Callsign := cdsQsoCallsign.Value;
//        jarlThread.Execute;
        end;
//        dEndTime := now;

//      if (cdsQsoCountry.Value = 'JPN') and (cdsQsoOrgCallsign.Value <> '') then
//        if Assigned(LicenceThread) then
//          begin
//          LicenceThread.Callsign := cdsQsoOrgCallsign.Value;
//          LicenceThread.Execute;
//          end;


//  JARL局のとき強制的にQSLを１Wayにする
      if cdsQsoQSL.Value = '' then
        begin
        if RegIsmatch('^(8[JMN])|(JA[0-9]RL)',Value) then
          SetcdsQsoStringField('Qsl', '1')
        else
          SetcdsQsoStringField('Qsl', QslDefault);
        end;
    except
//      s := 'Callsignが不正です。' + Inttostr(err) + #13 + '"' + Value + '"';
//      MessageDlg(s, mtError, [mbOK],0);
      result := false;
    end;
  finally
    FreeAndNil(wEntityList);
  end;
end;

function TEngine.cdsQsoCallsignValidate_Setting(Sender: TField): boolean;
var
  Value: string;
  wCallsignRec:  TCallsignRec;
begin
  result := true;
  Value := trim(Sender.Value);
  if Value = '' then
    exit;

  CheckCallsign(Value, wCallsignRec);    // CallsignからAreaを生成する為,
  FSupportQso.Area := wCallsignRec.Area;
  GetCallbook(wCallsignRec.OrgCallsign);
//  GetCallbook(cdsQsoOrgCallsign.Value);
  FSupportQso.Comment                    := PCallbook.Comment;

//          if cdsQsoCountry.AsString = 'JPN' then
//          cdsQsoCALLSIGNValidate_Sub(cdsQsoCountry.AsString, wCallsignRec.OrgCallsign)
//        else
//          cdsQsoCALLSIGNValidate_Sub(cdsQsoCountry.AsString, wCallsignRec.Callsign);


//  if Assigned(QsoList) then
//    begin
//    QsoList.FilterByCallsign(Value);
////    QsoList.FilterByCallsign(cdsQsoOrgCallsign.Value);
//    end;
end;

procedure TEngine.cdsQsoCONTINENTChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoCONTINENTValidate(Sender: TField);
var
  Value:  string;
  s: string;
  wContinentList: TStringList;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  wContinentList  :=  TStringList.Create;
  try
    try
      Value := Trim(Sender.Value);
      if Value = '' then
        exit;
      if (FQsoState = lgSetting) then
        exit;

      GetContinentList(cdsQsoEntity.Value, wContinentList);
      if wContinentList.Count < 1 then
        exit;
      if wContinentList.IndexOf(Value) = -1 then
        begin
        s := format('Continentが不正です。'#13'"%s"', [Value]);
        MessageDlg(s, mtError, [mbOK],0);
        raise EValueFatalError.Create('');
        end;
    except
      on EValueFatalError do
        raise;
      else
        MessageDlg('cdsQsoContinentValidate --- Error',mtError, [mbOK],0);
      raise;
    end;
  finally
    wContinentList.Free;
  end;
end;

procedure TEngine.cdsQsoCOUNTRYChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
  if Assigned(QsoStatus) then
    QsoStatus.ExecByRegion(Sender.Value, cdsQsoRegion.Value);
end;

procedure TEngine.cdsQsoCOUNTRYValidate(Sender: TField);
var
  Value:  string;
  s: string;
  wCountryRec: TCountryRec;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      Value         := trim(Sender.Value);
      FSupportQso.CountryName  := '';
      if Value = '' then
        exit;
      CheckCountry(Value, wCountryRec);
      FSupportQso.CountryName := wCountryRec.Name;
      if (FQsoState = lgSetting) then
        exit;

      if not wCountryRec.Result then
        begin
        s := format('入力したCountryが登録されていません。'#13
             + 'このまま続けますか？'#13'"%s"', [Value]);
        MessageDlg(s, mtError, [mbOK],0);
        if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
          raise EValueFatalError.Create('');
        end;
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoContinentValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoCQChange(Sender: TField);
begin
//  if QsoState = lgBrowse then
  cdsQsoSmallIntFieldChange(Sender);
end;

procedure TEngine.cdsQsoCQZONEChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoCQZONEValidate(Sender: TField);
var
  Value:  string;
  s: string;
  wCQZoneList: TStringList;
begin
//  if bAutoInput[TField(Sender).Index] <> 0 then
//    exit;
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;

  wCQZoneList  := TStringList.Create;
  try
    try
      Value := Sender.Value;
      if Value = '' then
        exit;
      if (FQsoState = lgSetting) then
        exit;

      GetCqZonelist(cdsQsoEntity.Value, wCQZoneList);
      if (wCQZoneList.Count < 1) then
        if not RegIsMatch('^0[1-9]|[1-3][0-9]|40$', Value) then
          begin
          s := format('入力したCqZoneは、範囲以外です。'#13'"%s"', [value]);
          MessageDlg(s, mtConfirmation,[mbYes],0);
          raise EValueFatalError.Create('');
          end
        else
          begin
          end
      else
        if (wCQZoneList.IndexOf(value) = -1) then
          begin
          s := format('入力したCqZoneは、登録されていません。'#13
             + 'このまま続けますか？'#13'"%s"', []);
          if MessageDlg(s, mtConfirmation,[mbYes,mbNo],0) = mrNo then
            raise EValueFatalError.Create('');
          end;
    except
      on EValueFatalError do
        abort;
      else
        begin
        MessageDlg('cdsQsoCQZoneValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
    wCQZoneList.Free;
  end;
end;

procedure TEngine.cdsQsoENTITYChange(Sender: TField);
var
  wEntityRec:  TEntityRec;
begin
  CheckEntity(Sender.Value, wEntityRec);
  FSupportQso.EntityName := wEntityRec.Name;
  ChangeDirAndDist(wEntityRec.Longitude, wEntityRec.Latitude, 1);

  cdsStringFieldChange(Sender);
  if Assigned(QsoStatus) then
    QsoStatus.ExecByEntity(Sender.Value);
end;

procedure TEngine.cdsQsoENTITYValidate(Sender: TField);
var
  Value:  string;
  s: string;
  wEntityRec:  TEntityRec;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      Value         := Trim(Sender.Value);
      FSupportQso.EntityName := '';
      if Value = '' then
        exit;

      CheckEntity(Value, wEntityRec);
      FSupportQso.EntityName := wEntityRec.Name;
      if (FQsoState = lgSetting) then
        exit;
      if not wEntityRec.result then
        begin
        s := format('入力したEntityが登録されていません。'#13
           + 'このまま続けますか？'#13'"%s"', [value]);
        if MessageDlg(s, mtConfirmation,[mbYes,mbNo],0) = mrNo then
          raise EValueFatalError.Create('');
        end;
      if Assigned(QsoStatus) then
        QsoStatus.ExecByEntity(Value);
      if (wEntityRec.Continent <> cdsQsoContinent.asString)
      or (wEntityRec.Country <> cdsQsoCountry.asString) then      // V1.0.0.6 Insert
        begin
        SetcdsQsoStringField('Region', '');   //  Countryの設定前に行う必要あり
        SetcdsQsoStringField('Country', wEntityRec.Country);
        SetcdsQsoStringField('Continent', wEntityRec.Continent);
        SetcdsQsoStringField('ItuZone', wEntityRec.ItuZone);
        SetcdsQsoStringField('CqZone', wEntityRec.CqZone);
        end;
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoEntityValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoETC1Change(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoETC1Validate(Sender: TField);
var
  i: integer;
  s: string;
  n: string;
  Value:  string;
begin
  n := Copy(Tfield(Sender).Name, Length(Tfield(Sender).Name), 1);  // Etcの区別
  i := StrToInt(n);
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  FSupportQso.ETCName[i] := '';
  Value  := trim(Sender.Value);
  if Value = '' then
    exit;
  CheckEtc('Etc' + n, Value, cEtcRec[i]);
  FSupportQso.ETCName[i] := cEtcRec[i].Name;
  if (FQsoState = lgSetting) then
    exit;

  try
    if not CheckEtc('Etc' + n, Value, cEtcRec[i]) then
      begin
      s := format('入力したETC' + n + 'は登録されていません。'#13
             + 'このまま続けますか？'#13'"%s"', [value]);
      if MessageDlg(s, mtConfirmation,[mbYes,mbNo],0) = mrNo then
        raise EValueFatalError.Create('');
      end
    else
      FSupportQso.ETCName[i] := cEtcRec[i].Name;
  except
    on EValueFatalError do
      raise;
    else
      MessageDlg('cdsQsoETC1Validate(' + TField(Sender).Name + ') --- Error',mtError, [mbOK],0);
      raise;
  end;
end;

procedure TEngine.cdsQsoETC2Change(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoETC2Validate(Sender: TField);
begin
  cdsQsoETC1Validate(Sender);
end;

procedure TEngine.cdsQsoETC3Change(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoETC3Validate(Sender: TField);
begin
  cdsQsoETC1Validate(Sender);
end;

procedure TEngine.cdsQsoETC4Change(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoETC4Validate(Sender: TField);
begin
  cdsQsoETC1Validate(Sender);
end;

procedure TEngine.cdsQsoETC5Change(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoETC5Validate(Sender: TField);
begin
  cdsQsoETC1Validate(Sender);
end;

procedure TEngine.cdsQsoFREQChange(Sender: TField);
begin
  cdsQsoLargeIntFieldChange(Sender);
end;

procedure TEngine.cdsQsoFREQValidate(Sender: TField);
var
  v: Int64;
  s: string;
  wFreqRec: TFreqRec;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      v := TLargeIntField(Sender).AsLargeInt;
      if V = 0 then
        Exit;
      if (FQsoState = lgSetting) then
        exit;
//      if Trcv.Active then        // Trcvからの設定時にエラーにしない為
//        exit;

      if not CheckFreq(v, wFreqRec) then
        if FQsoState <> lgSetting then
          begin
          s := 'FreqがBand範囲をはずれている。'#13'"' + FloatToStr(V/kMhz) + '"';
          MessageDlg(s, mtError, [mbOK],0);
          raise EValueFatalError.Create('');
          end;
      SetcdsQsoInt64Field('Band', wFreqRec.Band);

      if (FQsoState <> lgBrowse) then
        if bManualInput[cdsQsoMode.Index] or bManualInput[cdsQsoHisReport.Index]
        or bManualInput[cdsQsoMyReport.Index] then
          begin
          end
        else
          begin
          if cdsQsoMode.AsString = '' then
            SetcdsQsoStringField('Mode', wFreqRec.DefaultMode);
          end;
    except
      on EValueFatalError do
          raise;
      else
        begin
        MessageDlg('cdsQsoFreqValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoGRIDLOCChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
  if Assigned(QsoStatus) then
    QsoStatus.ExecByGridLoc(Sender.Value);
end;

procedure TEngine.cdsQsoGRIDLOCValidate(Sender: TField);
var
  Value:  string;
  s: string;
  Lon,Lat: Double;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      Value := Trim(Sender.Value);
      if Value = '' then
        exit;
      if (FQsoState = lgSetting) then
        exit;

      if not CheckGridLoc(value) then
        begin
        s := format('GridLocが不正です。'#13'"%s"', [value]);
        MessageDlg(s, mtError, [mbOK],0);
        raise EValueFatalError.Create('');
        end;
      GLToDeg(Value, Lon, Lat);
      ChangeDirAndDist(DegToStr(Lon, drLongitude), DegToStr(Lat, drLatitude), 2);
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoGridLocValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoHISREPORTChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoHISREPORTValidate(Sender: TField);
var
  Value:  string;
  s:  string;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      value   := trim(Sender.Value);
      if value = '' then
        exit;
      if cdsQsoMode.value = '' then
        exit;
      if (FQsoState = lgSetting) then
        exit;

      if not CheckReport(cdsQsoMode.Value, Value) then
        begin
        s := format('HisReportが不正です。'#13'"%s"', [value]);
        MessageDlg(s, mtError, [mbOK],0);
        raise EValueFatalError.Create('');
        end;
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoHisReportValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoIOTAChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
  if Assigned(QsoStatus) then
    QsoStatus.ExecByIota(Sender.Value);
end;

procedure TEngine.cdsQsoIOTAValidate(Sender: TField);
var
  Value:  string;
  s: string;
  wIotaRec: TIotaRec;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      Value := trim(Sender.Value);
      FSupportQso.IotaName   := '';
      if Value = '' then
        exit;
      CheckIOTA(cdsQsoEntity.Text, Value, wIotaRec);
      FSupportQso.IotaName      := wIotaRec.Name;
      if (FQsoState = lgSetting) then
        exit;

      FSupportQso.IOTAName :=  '';
      if not RegIsMatch('^(AF|AN|AS|EU|NA|OC|SA)(\-)([0-9]{3})$', value) then
        if (FQsoState <> lgBrowse) then
          begin
          s := format('IOTAが不正です。'#13'"%s"', [value]);
          MessageDlg(s, mtError, [mbOK],0);
          raise EValueFatalError.Create('');
          end;
      if cdsQsoEntity.Text <> '' then
        if CheckIOTA(cdsQsoEntity.Text, Value, wIotaRec) then
          FSupportQso.IOTAName :=  wIotaRec.Name
        else
          if (FQsoState <> lgBrowse) then
            begin
            s := format('入力したIOTA Noが登録されていません。'#13
                + 'このまま続けますか？'#13'"%s"', [value]);
            if MessageDlg(s, mtConfirmation,[mbYes,mbNo],0) = mrNo then
              raise EValueFatalError.Create('');
            end;
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoIOTAValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoITUZONEChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoITUZONEValidate(Sender: TField);
var
  Value: string;
  s: string;
  wItuZoneList: TStringList;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  wItuZoneList  :=  TStringList.Create;
  try
    try
      Value := trim(Sender.Value);
      if Value = '' then
        exit;
      if (FQsoState = lgSetting) then
        exit;

      GetItuZoneList(cdsQsoEntity.Value, wItuZoneList);
      if wItuZoneList.Count < 1  then
        if not RegIsMatch('^(0[1-9])|([1-9][0-9])|(90)$', Value) then
          begin
          s := format('ITU Zoneは、範囲以外です。'#13'"%s"', [value]);
          MessageDlg(s, mtError, [mbOK],0);
          raise EValueFatalError.Create('');
          end
        else
          begin
          end
      else
        if (wItuZoneList.IndexOf(value) = -1) then
          begin
          s := format('入力したITU Zoneは登録されていません。'#13
             + 'このまま続けますか？'#13'"%s"', [value]);
          if MessageDlg(s, mtConfirmation,[mbYes,mbNo],0) = mrNo then
            raise EValueFatalError.Create('');
          end;
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoITUZoneValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
    FreeAndNil(wItuZoneList);
  end;
end;

procedure TEngine.cdsQsoLogAfterPost(DataSet: TDataSet);
begin
  FDbChanged:= true;
end;

procedure TEngine.cdsQsoLogBeforeDelete(DataSet: TDataSet);
begin
  FDbChanged  := true;
  OutputJournal('D', DataSet);
  UpdateLotw('D');
end;

procedure TEngine.cdsQsoLogBeforePost(DataSet: TDataSet);
var
  UpDate: string;
begin
  if DataSet.State = dsInsert then
    begin
    Update := 'I';
    end
  else if DataSet.State = dsEdit then
    begin
    Update := 'E';
    end
  else
    Update := 'X';
  OutputJournal(Update, DataSet);
//  UpdateLotw(Update);
end;

procedure TEngine.cdsQsoLogCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('QslG').AsString :=
           Copy(DataSet.FieldByName('Qsl').AsString     + ' ',1,1)
         + Copy(DataSet.FieldByName('QslSend').AsString + ' ',1,1)
         + Copy(DataSet.FieldByName('QslRecv').AsString + ' ',1,1);
end;

procedure TEngine.cdsQsoLogCQGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text  := '';
  if Sender.AsInteger = -1 then
    Text :=  'CQ'
end;

procedure TEngine.cdsQsoLogFREQGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
var
  fmt: string;
begin
  fmt := '';
  if Sender.DataSet.FieldByName('Mode').Value <> '' then
    fmt := pFreqFormatList.Values[cdsQsoLog.FieldByName('Mode').Value];
  if fmt = '' then
    fmt := '#0.0000;;#';
  Text  :=  FormatFloat(fmt, TLargeIntField(Sender).Value / kMhz);
end;

procedure TEngine.cdsQsoLogONDATETIMEGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
var
  LocalDateTime: TDateTime;
begin
  if TDateTimeField(Sender).IsNull then
    Text  := ''
  else
    begin
//  UTCをローカル時間に変換
    LocalDateTime := TDateTimeField(Sender).AsDateTime + FTimezoneBiasD;
    Text := FormatDateTime('YYYY/mm/dd hh:nn', LocalDateTime);
    end;
end;

procedure TEngine.cdsQsoMemoChange(Sender: TField);
var
  Value: string;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  TField(Sender).OnChange := nil;
  try
//  連続する全角/半角を半角空白1個に置き換える
    Value := CompactStr(Sender.Value);
    if Value  <>  Sender.Value then
      Sender.Value  := Value;
    if bAutoInput[TField(Sender).Index] = 0 then
      ForwardQsoState;
  finally
    TField(Sender).OnChange := cdsQsoMemoChange;
  end;
end;

procedure TEngine.cdsQsoMODEChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoMODEValidate(Sender: TField);
var
  Value: string;
  s: string;
  wModeRec: TModeRec;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      Value := trim(Sender.Value);
      FSupportQso.FreqFormat := '';
      if Value = '' then
        Exit;
      CheckMode(Value, wModeRec);
      FSupportQso.FreqFormat :=  wModeRec.FreqFormat;
      if (FQsoState = lgSetting) then
        exit;

      if not wModeRec.Result then
        begin
        s := format('Modeが不正です。Mode="%s"'#13
           + 'このまま続けますか？　', [Value]);
        if MessageDlg(s, mtConfirmation,[mbYes,mbNo],0) = mrNo then
          raise EValueFatalError.Create('');
        end;
      if (Length(wModeRec.DefaultReport) <> 0) then
        begin
        if (not bManualInput[cdsQsoHisreport.Index])
        or (Length(cdsQsoHisReport.Value) <> Length(wModeRec.DefaultReport)) then
          begin
          SetcdsQsoStringField('HisReport', wModeRec.DefaultReport);
          end;
        if (not bManualInput[cdsQsoMyReport.Index])
        or (Length(cdsQsoMyReport.Value) <> Length(wModeRec.DefaultReport)) then
          begin
          SetcdsQsoStringField('MyReport', wModeRec.DefaultReport);
          end;
        end;
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoModeValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoMYREPORTChange(Sender: TField);
begin
  if FQsoState = lgBrowse then
    ForwardQsoState;
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoMYREPORTValidate(Sender: TField);
var
  Value:  string;
  s:  string;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      value := trim(Sender.Value);
      if Value = '' then
        Exit;
      if cdsQsoMode.value = '' then
        exit;
      if (FQsoState = lgSetting) then
        exit;

      if not CheckReport(cdsQsoMode.Value, Value) then
        begin
        s := format('MyReportが不正です。'#13'"%s"', [value]);
        MessageDlg(s, mtError, [mbOK],0);
        raise EValueFatalError.Create('');
        end;
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoModeValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoNAMEChange(Sender: TField);
var
  Value:  string;
  i: Integer;
  s,t: string;
  Reg: TSkRegExp;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  TField(Sender).OnChange := nil;
  Reg := TSkRegExp.Create;
  try
    try
      if (FQsoState = lgSetting) then
        exit;
      Value := trim(Sender.Value);
      i := TField(Sender).Index;
      if bAutoInput[TField(Sender).Index] = 0 then
        begin
        ForwardQsoState;
        bManualInput[i] := True;
        end;
      if Value = ''  then
        exit;

//  連続する全角/半角を半角空白1個に置き換える
      Value := CompactStr(Sender.Value);

//  名前が英数字のみのとき、正規化
      if RegIsMatch('^([a-zA-Z0-9]+[.]?[ ]?)+$', Value) then
        begin
        s := '';
        Reg.Expression := '([a-zA-Z0-9]+[.]?[ ]?)';
        if Reg.Exec(LowerCase(Value)) then
          repeat
            for i :=1 to Reg.GroupCount do
              begin
              t := Trim(Reg.Match[i]);
              s := s + UpperCase(Copy(t,1,1))
                     + Copy(t,2,Length(t)-1) + ' ';
              end;
          until not Reg.ExecNext;
        Value := Trim(s);
        end;

// 前値と空白の個数が違うときは、置き換えているが変わらない？
// dbEditでもOnChangeが発生しない
      if  Value <> Sender.Value then
        Sender.Value  := Value;
      if bAutoInput[TField(Sender).Index] = 0 then
        ForwardQsoState;
    except
    end;
  finally
    FreeAndNil(Reg);
    TField(Sender).OnChange := cdsQsoNameChange;
  end;
end;

procedure TEngine.cdsQsoNETLOGRECVChange(Sender: TField);
begin
  cdsQsoDateFieldChange(Sender);
end;

procedure TEngine.cdsQsoNETLOGSENDChange(Sender: TField);
begin
  cdsQsoDateFieldChange(Sender);
end;

procedure TEngine.cdsQsoNewRecord(DataSet: TDataSet);
//var
//  i:  integer;
begin
//  新規レコードのとき、Fieldを初期設定する
//  ''等を設定してもNullになってしまう  →　設定してもしょうがない？
//  with DataSet do
//    begin
//    for i := 0 to FieldCount - 1 do
//      if Fields.Fields[i] is TWideStringField then
//        begin
//        Fields.Fields[i].AsString :=  ''
//        end
//      else if Fields.Fields[i] is TFloatField then
//        Fields.Fields[i].AsFloat :=  0
//      else if Fields.Fields[i] is TIntegerField then
//        Fields.Fields[i].AsFloat :=  0
//      else
//        Fields.Fields[i].AsString :=  '';
//    end;
end;

procedure TEngine.cdsQsoOFFDATETIMEChange(Sender: TField);
begin
  cdsQsoDateFieldChange(Sender);
end;

procedure TEngine.cdsQsoOFFDATETIMEValidate(Sender: TField);
var
  Value:  string;
  s: string;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      value := trim(Sender.Value);
      if Value = '' then
        Exit;
      if (FQsoState = lgSetting) then
        exit;

      if not CheckOnOffDateTime then
        begin
        s := format('交信終了日時が交信開始日時より小さいです。'#13
         + '交信開始日時 = %s'#13
         + '交信終了日時 = %s', [cdsQsoOnDateTime.AsString, cdsQsoOffDateTime.AsString]);
        MessageDlg(s, mtError, [mbOK],0);
        raise EValueFatalError.Create('');
        end;
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoOffDateTimeValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoONDATETIMEChange(Sender: TField);
var
  i: integer;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    i := TField(Sender).Index;
    if bAutoInput[i] = 0 then
      begin
      ForwardQsoState;
      bManualInput[i] := True;
      end;
  finally
  end;
end;

procedure TEngine.cdsQsoONDATETIMEValidate(Sender: TField);
var
  value: string;
  s: string;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    Value := Trim(Sender.Value);
    if Value = '' then
      exit;
    if (FQsoState = lgSetting) then
      exit;

    if not CheckOnOffDateTime then
      begin
      s := format('交信開始日時が交信終了日時より大きいです。'#13
       + '交信開始日時 = %s'#13'交信終了日時 = %s'
       ,[DateTimeToStr(cdsQsoOnDateTime.value), DateTimeToStr(cdsQsoOffDateTime.value)]);
      MessageDlg(s, mtError, [mbOK],0);
      raise EValueFatalError.Create('');
      end;
    isQsoDateOver := false;       // 日付が範囲を超えたしるしをリセット
//    if (FProcessing = prRealTime) and (not isQsoDateOver)
    if (FProcessing = prRealTime) and (cdsQsoSwl.AsInteger = kFalse)
    and ((FQsoState = lgInsert) or (FQsoState = lgTramp)) then
      begin
      if Abs(StrToDateTime(Value) - Now()) > 0.007 then  // リアルタイム入力の時、10分ルールを適用
        begin
        s := format('リアルタイム入力時の交信開始日が範囲を超えている。'#13
           + 'このまま続けますか？　'#13'交信開始日時 = %s', [Value]);
        if MessageDlg(s, mtConfirmation,[mbYes,mbNo],0) = mrNo then
          raise EValueFatalError.Create('');
        isQsoDateOver := true;       // 日付が範囲を超えたしるし
        end;
    end;
  except
    on EValueFatalError do
      raise;
    else
      begin
      MessageDlg('cdsQsoOnDateTimeValidate --- Error',mtError, [mbOK],0);
      raise;
      end;
  end;
end;

procedure TEngine.cdsQsoORGCALLSIGNChange(Sender: TField);
begin
  if Assigned(QsoList) then
  if (FQsoState = lgTramp) then  // 15/07/10  Ver1.1.1.0
      QsoList.FilterByCallsign(Sender.Value);
  if Assigned(QsoStatus) then
    QsoStatus.ExecByCallsign(Sender.Value);
end;

procedure TEngine.cdsQsoORGCALLSIGNValidate(Sender: TField);
var
  Value:  string;
  s: string;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      Value :=  trim(Sender.Value);
      if Value = '' then
        exit;
      if (FQsoState = lgSetting) then
        exit;

      if Pos(Value, cdsQsoCallsign.Value) = 0 then
        begin
        s := format('OrgCallsignが不正です。'#13'"%s"', [value]);
        MessageDlg(s, mtError, [mbOK],0);
        raise EValueFatalError.Create('');
        end;
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoOrgCallsignValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoPREFIXChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
  if Assigned(QsoStatus) then
    QsoStatus.ExecByPrefix(Sender.Value);
end;

procedure TEngine.cdsQsoPREFIXValidate(Sender: TField);
var
  Value:  string;
  s: string;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      Value := Trim(Sender.Value);
      if Value = '' then
        exit;
      if (FQsoState = lgSetting) then
        exit;
// 以下のTestおかいいのでは？
      if Pos(Value, cdsQsoPrefix.Value) = 0 then
        begin
        s := format('Prefixが不正です。'#13'このまま続けますか？　'#13'"%s"', [Value]);
        if MessageDlg(s, mtConfirmation,[mbYes,mbNo],0) = mrNo then
          raise EValueFatalError.Create('');
        end;
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoPrefixValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoQSLChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoQSLMANAGERChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoQSLRECVChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoQSLRECVDATEChange(Sender: TField);
begin
  cdsQsoDateFieldChange(Sender);
end;

procedure TEngine.cdsQsoQSLRECVValidate(Sender: TField);
var
  Value:  string;
  s: string;
  e: TFieldNotifyEvent;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      Value := Sender.Value;
      if (FQsoState = lgSetting) then
        exit;
      if Value = '' then
        begin
        e := cdsQsoQslRecvDate.OnValidate;
        cdsQsoQslRecvDate.OnValidate := nil;
        cdsQsoQslRecvDate.Clear;
        cdsQsoQslRecvDate.OnValidate  := e;
        exit;
        end;

      if pQslRecvList.Values[Value]  = '' then
        begin
        s := 'QslSRecvが不正です。' + #13 + '"' + Value + '"';
        MessageDlg(s, mtError, [mbOK],0);
        raise EValueFatalError.Create('');
        end;
        if FQslRecvDate <> LowDate then
          SetcdsQsoDateTimeField('QslRecvDate', FQslRecvDate);
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoQslRecvValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

// QsoQSLSENDDATE,QsoQSLRECVDDATE共通
procedure TEngine.cdsQsoQSLSENDChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoQSLSENDDATEChange(Sender: TField);
begin
  cdsQsoDateFieldChange(Sender);
end;

// QsoQSLSENDDATE,QsoQSLRECVDDATE共通
procedure TEngine.cdsQsoQSLSENDDATEValidate(Sender: TField);
var
  Value:  string;
  s: string;
  dt: TdateTime;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      if (FQsoState = lgSetting) then
        exit;
// 2017/11/27
//  なぜかAccess Viorationを起こす
//  OnDateTimeでは起きない。　
//　桁数の違いか？
//　とりあえずコメント化しておく



//      dt :=   cdsQsoQSLSENDDATE.AsDateTime;
////      value := trim(Sender.value);
////      dt := (TField(Sender).AsDateTime);
////      if Value = '' then
////        Exit;
//
//      if Sender.AsDateTime < Int(cdsQsoOnDateTime.AsDateTime) then
//        begin
//        if Sender.FieldName = 'QSLSENDDATE' then
//          s  := 'QSL送付日'
//        else
//          s  := 'QSL受領日';
//        s := format('%sが交信開始日より小さい。'#13'%s = %s'#13'交信開始日 = %s',
//         [s, s, Sender.AsString, Copy(cdsQsoOnDateTime.AsString,1,10)]);
//        MessageDlg(s, mtError, [mbOK],0);
//        raise EValueFatalError.Create('');
//        end;
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoQSLSENDDATEValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoQSLSENDValidate(Sender: TField);
var
  Value:  string;
  s: string;
  e: TFieldNotifyEvent;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      Value := Trim(Sender.Value);
      if (FQsoState = lgSetting) then
        exit;
      if Value = '' then
        begin
        e := cdsQsoQslSendDate.OnValidate;
        cdsQsoQslSendDate.OnValidate := nil;
        cdsQsoQslSendDate.Clear;
        cdsQsoQslSendDate.OnValidate  := e;
        exit;
        end;

      if pQslSendList.Values[Value]  = '' then
        begin
        s := 'QslSendが不正です。' + #13 + '"' + Value + '"';
        MessageDlg(s, mtError, [mbOK],0);
        raise EValueFatalError.Create('');
        end;
        if FQslSendDate <> LowDate then
          SetcdsQsoDateTimeField('QslSendDate', FQslSendDate);
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoQslSendValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoQSLValidate(Sender: TField);
var
  Value:  string;
  s: string;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      Value := trim(Sender.Value);
      if Value = '' then
        exit;
      if (FQsoState = lgSetting) then
        exit;

      if pQslList.Values[Value]  = '' then
        begin
        s := format('Qslが不正です。'#13'"%s"', [Value]);
        MessageDlg(s, mtError, [mbOK],0);
        raise EValueFatalError.Create('');
        end;
    except
      on EValueFatalError do
        abort;
      else
        begin
        MessageDlg('cdsQsoQslValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoRECVFREQChange(Sender: TField);
begin
  cdsQsoLargeIntFieldChange(Sender);
end;

procedure TEngine.cdsQsoRECVFREQValidate(Sender: TField);
var
  v: Int64;
  s: string;
  wFreqRec: TFreqRec;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;

  try
    v := TLargeIntField(Sender).AsLargeInt;
    if V = 0 then
      begin
      SetcdsQsoInt64Field('RecvBand', 0);   //  2016/06/14 追加
      Exit;
      end;
    if (FQsoState = lgSetting) then
      exit;
//    if Trcv.Active then        // Trcvからの設定時にエラーにしない為
//      exit;

    if not CheckFreq(v, wFreqRec) then
      if FQsoState <> lgSetting then
        begin
        s := format('RecvFreqがBand範囲をはずれている。'#13
          + 'このまま続けますか？ "%f" ', [V/kMhz]);
        if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
          raise EValueFatalError.Create('');
        end;
    SetcdsQsoInt64Field('RecvBand', wFreqRec.Band);
  except
    on EValueFatalError do
        raise;
    else
      begin
      MessageDlg('cdsQsoFreqValidate --- Error',mtError, [mbOK],0);
      raise;
      end;
  end;
end;

procedure TEngine.cdsQsoREGIONChange(Sender: TField);
var
  wRegionRec: TRegionRec;
begin
  CheckRegion(cdsQsoCountry.Value, Sender.Value, wRegionRec);
  FSupportQso.RegionPhonetic := wRegionRec.Phonetic;
  FSupportQso.RegionName := wRegionRec.Name;
  ChangeDirAndDist(wRegionRec.Longitude, wRegionRec.Latitude, 3);

  cdsStringFieldChange(Sender);
  if Assigned(QsoStatus) then
    QsoStatus.ExecByRegion(cdsQsoCountry.Value, Sender.Value);
end;

procedure TEngine.cdsQsoREGIONValidate(Sender: TField);
var
  Value:  string;
  s: string;
  wRegionRec: TRegionRec;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      Value :=  trim(Sender.Value);
      FSupportQso.RegionName := '';
      if Value = '' then
        Exit;
      if (FQsoState = lgSetting) then
        exit;

      CheckRegion(cdsQsoCountry.Value, Value, wRegionRec);
      if not wRegionRec.result then
        begin
        s := format('入力したRegionが登録されていません。'#13
          + 'このまま続けますか？'#13'Region="%s"', [Value]);
        if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
          raise EValueFatalError.Create('');
        end;
      if DateOf(cdsQsoOnDateTime.Value) > wRegionRec.ToDate then
        begin
        s := format('入力したRegionが有効日範囲に含まれません。'#13
          + 'このまま続けますか？'#13'Region="%s"　ToDate=#%s#',
           [Value, FormatDateTime('yyyy/mm/dd', wRegionRec.ToDate)]);
        if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
          raise EValueFatalError.Create('');
        FSupportQso.RegionName := wRegionRec.Name + '?'
        end
      else
        FSupportQso.RegionName := wRegionRec.Name;

    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoRegionValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoREPEATERChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoREPEATERValidate(Sender: TField);
var
  Value: string;
  s: string;
  wRepeaterRec: TRepeaterRec;
  wRouteRec: TRouteRec;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      Value := trim(Sender.Value);
      if Value = '' then
        Exit;
      if (FQsoState <> lgSetting) then
        exit;

      if (CheckRoute(cdsQsoRoute.Value, wRouteRec))
      and (wRouteRec.NeedRepeter) and (Value = '') then
        begin
        s := 'Repeaterの入力が必要です'#13'このまま続けますか？';
        if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
          raise EValueFatalError.Create('');
        end;
      if not CheckRepeater(cdsQsoRoute.Value, Value, wRepeaterRec) then
        begin
        s := format('入力したRepeaterが登録されていません。'#13
           + 'このまま続けますか？'#13'"%s"', [Value]);
        if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
          raise EValueFatalError.Create('');
        end;
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoRepeaterValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoROUTEChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
end;

procedure TEngine.cdsQsoROUTEValidate(Sender: TField);
var
  Value: string;
  s: string;
  wRouteRec: TRouteRec;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    try
      Value := trim(Sender.Value);
      if Value = '' then
        Exit;
      if (FQsoState <> lgSetting) then
        exit;

      if not CheckRoute(Value, wRouteRec) then
        begin
        s := format('入力したRouteが登録されていません。'#13
           + 'このまま続けますか？'#13'"%s"', [Value]);
        if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
          raise EValueFatalError.Create('');
        end;
    except
      on EValueFatalError do
        raise;
      else
        begin
        MessageDlg('cdsQsoRouteValidate --- Error',mtError, [mbOK],0);
        raise;
        end;
    end;
  finally
  end;
end;

procedure TEngine.cdsQsoSUFFIXChange(Sender: TField);
begin
  cdsStringFieldChange(Sender);
  if Assigned(QsoStatus) then
    QsoStatus.ExecBySuffix(Sender.Value);
end;

procedure TEngine.cdsQsoSUFFIXValidate(Sender: TField);
var
  Value:  string;
  s: string;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    Value := trim(Sender.Value);
    if Value = '' then
      exit;
    if (FQsoState = lgSetting) then
      exit;

    if Pos(Value, cdsQsoCallsign.Value) = 0 then
      begin
      s := format('Suffixが不正です。'#13'"%s"', [Value]);
      MessageDlg(s, mtError, [mbOK],0);
      raise EValueFatalError.Create('');
      end;
  except
    on EValueFatalError do
      raise;
    else
      begin
      MessageDlg('cdsQsoSuffixValidate --- Error',mtError, [mbOK],0);
      raise;
      end;
  end;
end;


procedure TEngine.cdsQsoSWLChange(Sender: TField);
begin
//  if QsoState = lgBrowse then
  cdsQsoSmallIntFieldChange(Sender);
end;

procedure TEngine.cdsQsoDateFieldChange(Sender: TField);
var
  i: integer;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    i := TField(Sender).Index;
    if bAutoInput[i] = 0 then
      begin
      ForwardQsoState;
      bManualInput[i] := True;
      end;
  finally
  end;
end;

procedure TEngine.cdsQsoLargeIntFieldChange(Sender: TField);
var
  i: Integer;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    i := TField(Sender).Index;
    if bAutoInput[i] = 0 then
      begin
      ForwardQsoState;
      bManualInput[i] := True;
      end;
  finally
  end;
end;

procedure TEngine.cdsQsoSmallIntFieldChange(Sender: TField);
var
  i: Integer;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  try
    i := TField(Sender).Index;
    if bAutoInput[i] = 0 then
      begin
      ForwardQsoState;
      bManualInput[i] := True;
      end;
  finally
  end;
end;

procedure TEngine.cdsStringFieldChange(Sender: TField);
var
  i: Integer;
  Value:  string;
  NE: TFieldNotifyEvent;
begin
  if bAutoInput[TField(Sender).Index] = -1 then
    exit;
  NE  := TField(Sender).OnChange;
  TField(Sender).OnChange := nil;
  try
    Value := Trim(Sender.Value);
    i := TField(Sender).Index;
    if Value <> Sender.Value  then
      Sender.Value := Value;
    if bAutoInput[TField(Sender).Index] = 0 then
      begin
      ForwardQsoState;
      bManualInput[i] := True;
      end;
  finally
    TField(Sender).OnChange := NE;
  end;
end;

/////////////////////////////////////////////////////////////////////////////
//
//  Internetに関わるThread処理
//
/////////////////////////////////////////////////////////////////////////////
procedure TEngine.JARLThreadGet(Sender: TObject; const isMember, isQslService: boolean; const QslManager: string);
begin
  if isMember then
    if (QslManager <> '') and (cdsQsoQslManager.value = '') then
      begin
      SetTblQsoStringField('QslManager', QslManager);
      end;
  ChangeJarlMember(isMember, isQslService);
end;

procedure TEngine.LicenceThreadGet(Sender: TObject; const isLicenced: boolean; const RegionName: string);
var
  region: string;
begin
  LicencedRegionName := '';
  if isLicenced then
    begin
    LicencedRegionName := RegionName;
    end;
//  MicValide := true;
  if cdsQsoRegion.Value = '' then
    if GetRegionFromName(LicencedRegionName, region) then
      begin
      SetTblQsoStringField('Country', 'JPN');
      SetTblQsoStringField('Region', Region);
      end;
  ChangeLicence(isLicenced);
end;

/////////////////////////////////////////////////////////////////////////////
//
//  Eventに関する処理
//
/////////////////////////////////////////////////////////////////////////////
procedure TEngine.ChangeJarlMember(isJarlMember, isQslService: boolean);
begin
  if Assigned(FOnChangeJarlMember) then
    FOnChangeJarlMember(self, isJarlMember, isQslService);
end;

procedure TEngine.ChangeLicence(isLicenced: boolean);
begin
  if Assigned(FOnChangeLicence) then
    FOnChangeLicence(self, isLicenced);
end;

//procedure TEngine.ChangeComment();
//var
//  wComment: string;
//begin
//  wComment := Trim(PCallbook.Comment);
//  if Assigned(FOnChangeComment) then
//    FOnChangeComment(self, wComment);
//end;

//procedure TEngine.ChangeMyCallsign;
//begin
//end;

procedure TEngine.ChangeQsoState(QsoState: TQsoState);
begin
  if Assigned(FOnChangeQsoState) then
    FOnChangeQsoState(self, FQsoState);
end;

procedure TEngine.ChangeDirAndDist(Longitude, Latitude: string; Level: integer);
var
  ToLati,ToLong: double;
begin
  if not Assigned(FOnChangeDirAndDist) then
    exit;

//  Level 0:ClearQSO   1:Entity   2:GridLoc   3:Region
  if Level = 0 then // ClearQSOの時
    begin
    FSupportQso.Latitude   := Latitude;
    FSupportQso.Longitude  := Longitude;
    FDirection  := 0;
    FDistance   := 0;
    end
  else
    if  (Latitude = '') or (Longitude = '')
    or  (Level < pLocationLevel) then
      exit
    else
      begin
      FSupportQso.Latitude   := Latitude;
      FSupportQso.Longitude  := Longitude;
      StrToDeg(FSupportQso.Latitude, drLatiTude, ToLati);
      StrToDeg(FSupportQso.Longitude, drLongitude, ToLong);
      FDistance   := geoDistance(FOptionsData.Latitude, FOptionsData.Longitude, ToLati, ToLong, 5);
      FDirection  := geoDirection(FOptionsData.Latitude, FOptionsData.Longitude, ToLati, ToLong);
      end;
  pLocationLevel := Level;
  FOnChangeDirAndDist(self, FDirection, FDistance);
end;

//  Realtime/Batchの切り替え
procedure TEngine.ChangeProcessing();
begin
  if Assigned(FOnChangeProcessing) then
    FOnChangeProcessing(self, FProcessing);
end;

/////////////////////////////////////////////////////////////
//
//    CallsignからOrgCallsign,Prefix,Suffix,Areaを作成する
//
////////////////////////////////////////////////////////////
function TEngine.CheckCallsign(vCallsign: string; var CallsignRec: TCallsignRec): boolean;
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
    if vCallsign =  cCallsignRec.Callsign then
      exit;

    cCallsignRec.Callsign    := vCallsign;
    cCallsignRec.OrgCallsign := '';
    cCallsignRec.Prefix      := '';
    cCallsignRec.Suffix      := '';
    cCallsignRec.Area        := '';
    cCallsignRec.result      := true;

    s   := cCallsignRec.Callsign;
//  /MM,/QRP,/P(英一文字)などを削除
    s := RegReplace('/([A-Z]|MM|QRP|QRPP|)$', s, '');
//  orgCallsignのみ  ex. 'JA7FKF'
    Brx.Expression := '^' + gCallsign + '$';
    if Brx.Exec(s) then
      begin
      cCallsignRec.OrgCallsign := s;
      cCallsignRec.Prefix      := Brx.Match[1] + Brx.Match[2];
      cCallsignRec.Suffix      := Brx.Match[3];
      cCallsignRec.Area        := copy(Brx.Match[2], 1, 1);
//'7K1AAA'などのAreaを設定
      Brx.Expression := '^(7[K-N][1-4][A-Z]{3})$';
      if Brx.Exec(s) then
        cCallsignRec.Area   := '1';
      exit;
      end;
// orgCallsign + Area   ex. 'JA7FKF/1' → Prifix=JA1
    Brx.Expression := '^'+gCallsign+'/'+gArea+'$';
    if Brx.Exec(s) then
      begin
      cCallsignRec.OrgCallsign := Brx.Match[1]+Brx.Match[2]+Brx.Match[3];
      cCallsignRec.Area        := Copy(Brx.Match[4],1,1);
      cCallsignRec.Prefix      := Brx.Match[1] + cCallsignRec.Area;
      cCallsignRec.Suffix      := Brx.Match[3];
      exit;
      end;
// PreCallsign+ orgCallsign  ex. 'KH0/JA7FKF'
    Brx.Expression := '^'+gPrefix+'/'+gCallsign+'$';
    if Brx.Exec(s) then
      begin
      cCallsignRec.OrgCallsign := Brx.Match[3]+Brx.Match[4]+Brx.Match[5];
      if Brx.Match[2] <> '' then
        cCallsignRec.Area   := Copy(Brx.Match[2],1,1)
      else
        cCallsignRec.Area   := Copy(Brx.Match[4],1,1);
      cCallsignRec.Prefix := Brx.Match[1] + cCallsignRec.Area;
      cCallsignRec.Suffix := Brx.Match[5];
      exit;
      end;
// orgCallsign + PreCallsign   ex. 'JA7FKF/JD1'
    Brx.Expression := '^'+gCallsign+'/'+gPrefix+'$';
    if Brx.Exec(s) then
      begin
      cCallsignRec.OrgCallsign := Brx.Match[1]+Brx.Match[2]+Brx.Match[3];
      if Brx.Match[5] <> '' then
        cCallsignRec.Area   := Copy(Brx.Match[5],1,1)
      else
        cCallsignRec.Area   := Copy(Brx.Match[2],1,1);
        cCallsignRec.Prefix := Brx.Match[4] + cCallsignRec.Area;
        cCallsignRec.Suffix := Brx.Match[3];
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
            cCallsignRec.OrgCallsign := s1;
            cCallsignRec.Area              := Copy(Brx.Match[5],1,1);
            cCallsignRec.Prefix            := Brx.Match[4] + cCallsignRec.Area;
            cCallsignRec.Suffix            := Brx.Match[3];
            exit;
            end
          else
            if (Length(s1) < Length(s2)) and (Length(s1) <= 4)  then
              begin
              cCallsignRec.OrgCallsign      := s2;
              cCallsignRec.Area             := Copy(Brx.Match[2],1,1);
              cCallsignRec.Prefix           := Brx.Match[1] + cCallsignRec.Area;
              cCallsignRec.Suffix           := Brx.Match[6];
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
              cCallsignRec.OrgCallsign       := s1;
              cCallsignRec.Area              := Copy(Brx.Match[2],1,1);
              cCallsignRec.Prefix            := Brx.Match[1] + cCallsignRec.Area;
              cCallsignRec.Suffix            := Brx.Match[3];
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
      cCallsignRec.OrgCallsign := s;
      cCallsignRec.Area        := Brx.Match[2];
      cCallsignRec.Prefix      := Brx.Match[1] + Brx.Match[2];
      cCallsignRec.Suffix      := '';
      exit;
      end;
    Brx.Expression := '^' + t + '/'+(gArea)+'$';
    if Brx.Exec(s) then
      begin
      cCallsignRec.OrgCallsign := Brx.Match[1] + Brx.Match[2] + Brx.Match[3];
      cCallsignRec.Area        := Brx.Match[4];
      cCallsignRec.Prefix      := Brx.Match[1] + Brx.Match[2];
      cCallsignRec.Suffix      := '';
      exit;
      end;
// 'P5RS7' '9M9/CCL' 'JY1' 'BW2000' などは判断できない
      cCallsignRec.OrgCallsign := cCallsignRec.Callsign;
      cCallsignRec.Area        := '';
      cCallsignRec.Prefix      := '';
      cCallsignRec.Suffix      := '';
      cCallsignRec.result      := false;
  finally
    FreeAndNil(Brx);
    CallsignRec := cCallsignRec;
    result      := cCallsignRec.result;
  end;
end;

function TEngine.CheckCountry(vCountry: string; var CountryRec: TCountryRec): boolean;
var
  qry: TIBQuery;
  sSql: string;
begin
  result     := true;
  dStartTime := now();
  qry := TIBQuery.Create(Self);
  try
    if vCountry = cCountryRec.Country then
      exit;
    with cCountryRec do
      begin
      Country          := vCountry;
      Name             := '';
      FmDate           := LowDate;
      Name_jp          := '';
      result           := False;
      end;
    with qry do
      begin
      DataBase := dbReference;
//      DataBase := dbLogBase;
      sSql  := 'SELECT COUNTRY, NAME, NAME_JP, FMDATE FROM COUNTRY '
            +  ' WHERE COUNTRY = ' + QuotedStr(vCountry) + ';';
      Sql.Add(sSql);
      Open;
      if NOT EOF then
        begin
        cCountryRec.Name             := FieldByName('Name').AsString;
        if not TryStrToDate(FieldByName('FmDate').AsString, cCountryRec.FmDate) then
          cCountryRec.FmDate         := LowDate;
        cCountryRec.Name_jp          := FieldByName('Name_jp').AsString;
        cCountryRec.Result           := True;
        end;
      close;
      end;
  finally
    FreeAndNil(qry);
    CountryRec := cCountryRec;
    result := cCountryRec.Result;
  end;
end;

function TEngine.CheckEntity(vEntity: string; var EntityRec: TEntityRec): boolean;
var
  sSql: string;
begin
  Result     := true;
  dStartTime := now();
  try
    if vEntity = cEntityRec.Entity then
      exit;
    with cEntityRec do
      begin
      Entity      := vEntity;
      Name        := '';
      Country     := '';
      Continent   := '';
      ITUZone     := '';
      CQZone      := '';
      Latitude    := '';
      Longitude   := '';
      Continents  := '';
      ITUZones    := '';
      CQZones     := '';
      HamLog      := '';
      Result      := false;
      end;
    sSql := format('SELECT ENTITY, NAME, COUNTRY, LATITUDE, LONGITUDE, CONTINENTS,'
         +  'ITUZONES, CQZONES, HAMLOGCODE '
         +  'FROM ENTITY '
         +  'WHERE ENTITY=''%s'';', [vEntity]);
    with qryCommon do
      begin
      Close;
      SQL.Clear;
      SQL.Add(sSql);
      Open;
      if RecordCount <> 0 then
        begin
        cEntityRec.result              := true;
        cEntityRec.Name                := FieldByName('Name').AsString;
        cEntityRec.Country             := FieldByName('Country').AsString;
        cEntityRec.Latitude            := FieldByName('Latitude').AsString;
        cEntityRec.Longitude           := FieldByName('Longitude').AsString;
        cEntityRec.Continents          := FieldByName('Continents').AsString;
        cEntityRec.ITUZones            := FieldByName('ITUZones').AsString;
        cEntityRec.CQZones             := FieldByName('CQZones').AsString;
        cEntityRec.HamLog              := FieldByName('HamlogCode').AsString;
        if Length(cEntityRec.Continents) = 2 then
          cEntityRec.Continent         := cEntityRec.Continents;
        if Length(cEntityRec.ITUZones) = 2 then
          cEntityRec.ItuZone           := cEntityRec.ItuZones;
        if Length(cEntityRec.CQZones) = 2 then
          cEntityRec.CQZone            := cEntityRec.CQZones;
        end;
      end;
  finally
    EntityRec  := cEntityRec;
    result := cEntityRec.result;
  end;
end;

// Etc1からEtc5に有効なデータがあるかどうか
procedure TEngine.CheckValidEtcRec(vTable: string);
var
  sSql: string;
  n: string;
begin
  n := Copy(vTable, Length(vTable), 1);
  isValidEtcRec[StrToInt(n)] := false;
  try
    sSql := format('SELECT * FROM %0:s WHERE EXISTS(Select * FROM %0:s)', [vTable]);
    with qryCommon do
      begin
      Close;
      SQL.Clear;
      SQL.Add(sSql);
      Open;
      if RecordCount <> 0 then
        isValidEtcRec[StrToInt(n)] := true;
      Close;
      end;
  finally
  end;
end;

function TEngine.CheckEtc(vTable, vCode: string; var EtcRec: TEtcRec): boolean;
var
//  i: integer;
  sSql: string;
begin
  Result  := true;
  try
    if not isValidEtcRec[StrToInt(Copy(vTable, Length(vTable), 1))] then
      begin
      EtcRec.Result := true;
      Exit;
      end;
    if (vTable =  EtcRec.Table) and (vCode = EtcRec.Code) then
      exit;
    with  EtcRec   do
      begin
      Result        := False;
      Table         := vTable;
      Code          := vCode;
      Name          :=  '';
      end;
    sSql := format('SELECT * FROM %0:s WHERE Code = ''%1:s'';', [vTable, vCode]);
    with qryCommon do
      begin
      Close;
      SQL.Clear;
      SQL.Add(sSql);
      Open;
      if RecordCount <> 0 then
        begin
        EtcRec.result          := true;
        EtcRec.Name            := FieldByName('Name').AsString;
        end;
      Close;
      end;
  finally
    result :=  EtcRec.result;
  end;
end;

function TEngine.CheckFreq(vFreq: Int64; var FreqRec: TFreqRec): boolean;
var
  sSql: string;
begin
  result  :=  true;
  try
    if VFreq =  cFreqRec.Freq then
      exit;
    with  cFreqRec   do
      begin
      Result        :=  False;
      Freq          :=  vFreq;
      Band          :=  0;
      DefaultMode   :=  '';
      end;
    sSql := 'SELECT * FROM BANDPLAN '  // 浮動小数点をParamsで処理するとErrorになる
      + ' WHERE (FMFREQ <= ' + IntToStr(vFreq) + ')'
      + ' AND   (TOFREQ >= ' + IntToStr(vFreq) + ');';
    with qryCommon do
      begin
      Close;
      SQL.Clear;
      SQL.Add(sSql);
      Open;
      if RecordCount <> 0 then
        begin
        cFreqRec.result          := true;
        cFreqRec.Band            := FieldByName('Band').AsLargeInt;
        cFreqRec.DefaultMode     := FieldByName('DefaultMode').AsString;
        end;
      Close;
      end;
  finally
    FreqRec :=  cFreqRec;
    result  :=  cFreqRec.result;
  end;
end;

function TEngine.CheckHamLog(vHamLog: string): boolean;
var
  sSql: string;
begin
  result  :=  true;
  try
    if vHamLog = cHamLog.Hamlog then
      exit;
    with cHamLog do
      begin
      HamLog      := vHamLog;
      Entity      := '';
      Result      := false;
      end;
    sSql  := format('SELECT ENTITY, HAMLOGCODE FROM ENTITY '
          +  ' WHERE HAMLOGCODE = ''%s'';', [vHamLog]);
    with qryCommon do
      begin
      SQL.Clear;
      SQL.Add(sSql);
      Open;
      First;
      if not EOF then
        begin
        cHamLog.result          := true;
        cHamLog.Entity          := FieldByName('Entity').AsString;
        end;
      Close;
      end;
  finally
    result  := cHamlog.result;
  end;
end;

function TEngine.CheckIOTA(vEntity, vIOTA:string; var IotaRec: TIotaRec):boolean;
var
  sSql: string;
begin
  result  :=  true;
  try
    if (vEntity = cIotaRec.Entity) and (vIota = cIotaRec.Iota) then
      exit;
    cIotaRec.Result       := False;
    cIotaRec.Entity       := vEntity;
    cIotaRec.Iota         := vIota;
    cIotaRec.Name         := '';
    sSql := format('SELECT a.IOTA, a.NAME '
          + ' FROM IOTA a INNER JOIN IOTA_ENTITY b USING(IOTA) '
          + ' WHERE (a.IOTA=''%s'') AND (b.ENTITY=''%s'') AND (a.DELETED=0)'
          , [vIOTA,vEntity]);
    with qryCommon do
      begin
      Close;
      SQL.Clear;
      SQL.Add(sSql);
      Open;
      if not eof  then
        begin
        cIotaRec.Result       := true;
        cIotaRec.Name         := FieldByName('Name').AsString;
        end;
      end;
  finally
    IotaRec :=  cIotaRec;
    result  :=  cIotaRec.result;
  end;
end;

function TEngine.CheckMode(vMode: string; var ModeRec: TModeRec): boolean;
var
  qry: TIBQuery;
  sSql: string;
begin
  dStartTime := now();
  qry := TIBQuery.Create(Self);
  try
    if vMode  = cModeRec.Mode  then
      begin
      result  :=  cModeRec.Result;
      exit;
      end;

    with cModeRec do
      begin
      Result          := False;
      Mode            := vMode;
      ReportRegEx     := '';
      DefaultReport   := '';
      FreqFormat      := '';
      end;

    with qry do
      begin
      Database := dbReference;
      sSql  := 'SELECT * FROM MODE WHERE MODE = ' + QuotedStr(vMode) + ';';
      Sql.Add(sSQL);
      Open;
      if NOT EOF then
        begin
        cModeRec.ReportRegEx      := FieldByName('ReportRegEx').asString;
        cModeRec.DefaultReport    := FieldByName('DefaultReport').asString;
        cModeRec.FreqFormat       := FieldByName('FreqFormat').asString;
        cModeRec.Result := True;
        end;
      Close;
      end;
  finally
    FreeAndNil(qry);
    ModeRec  :=  cModeRec;
    result := cModeRec.Result;
  end;
end;

//function TEngine.CheckNewJCA(Suffix: string; DateTime: TDateTime): boolean;
//var
//  s: string;
//begin
//  result := false;
//  if DateTime <  StrToDateTime('1997/7/15') then
//    exit;
//  s := 'SELECT SUFFIX, QSLRECV, ONDATETIME FROM QSOLOG '
//    +  'WHERE (SUFFIX = ''' + Suffix + ''') AND (QSLRECV = ''R'') AND (ONDATETIME >= ''1997/7/15'');';
//  with qryQsoLog do
//    begin
//    Close;
//    Sql.Clear;
//    Sql.Add(s);
//    Open;
//    if RecordCount = 0 then
//      Result := true;
//    Close;
//    end;
//end;

//  OnDateTomeとOffDateTimeの関係チェック *************************************
function TEngine.CheckOnOffDateTime():boolean;
begin
  Result := True;
  try
    if cdsQsoOnDateTime.Value <= LowDate  then
      Exit;
    if cdsQsoOffDateTime.Value <= LowDate  then
      Exit;

    if cdsQsoOnDateTime.Value > cdsQsoOffDateTime.Value then
      begin
      result := False;
      exit;
      end;
    exit;
  finally
  end;
end;

function TEngine.CheckRepeater(vRoute, vRepeater: string; var RepeaterRec: TRepeaterRec): boolean;
var
  sSql: string;
begin
  result  :=  true;
  try
    if (vRoute = cRepeaterRec.Route) and (vRepeater = cRepeaterRec.Repeater) then
      exit;

    cRepeaterRec.Result      := False;
    cRepeaterRec.Route       := vRoute;
    cRepeaterRec.Repeater    := vRepeater;
    sSql := format('SELECT ROUTE, REPEATER, UPLINKFREQ, DOWNLINKFREQ '
          + ' FROM REPEATER '
          + ' WHERE (ROUTE=''%s'') and (REPEATER=''%s'')', [vRoute, vRepeater]);
    with qryCommon do
      begin
      Close;
      SQL.Clear;
      SQL.Add(sSql);
      Open;
      if not eof  then
        begin
        cRepeaterRec.Result       := true;
        cRepeaterRec.UplinkFreq   := FieldByName('UplinkFreq').AsLargeInt;
        cRepeaterRec.DownlinkFreq := FieldByName('DownlinkFreq').AsLargeInt;
        end;
      end;
  finally
    RepeaterRec  :=  cRepeaterRec;
    result := cRepeaterRec.result;
  end;
end;

function TEngine.CheckReport(vMode, vReport: string):Boolean;
var
  wModeRec: TModeRec;
begin
  result  := false;
  if CheckMode(vMode, wModeRec) then
    if wModeRec.ReportRegEx = '' then
      result := true
    else
      result := RegIsMatch(wModeRec.ReportRegEx, vReport);
end;

function TEngine.CheckRoute(vRoute: string; var RouteRec: TRouteRec): boolean;
var
  sSql: string;
begin
  result  :=  true;
  try
    if (vRoute = cRouteRec.Route) then
      exit;

    cRouteRec.Result      := False;
    cRouteRec.Route       := vRoute;
    cRouteRec.NeedRepeter := false;
    sSql := format('SELECT ROUTE, NEEDREPEATER FROM ROUTE '
          + ' WHERE ROUTE =''%s'' ', [vRoute]);
    with qryCommon do
      begin
      Close;
      SQL.Clear;
      SQL.Add(sSql);
      Open;
      if not eof  then
        begin
        cRouteRec.Result       := true;
        cRouteRec.NeedRepeter  := FieldByName('NeedRepeater').AsVariant;
        end;
      end;
  finally
    RouteRec  :=  cRouteRec;
    result    :=  cRouteRec.result;
  end;
end;

function TEngine.CheckRegion(vCountry,vRegion: string; var RegionRec: TRegionRec): boolean;
var
  s: string;
  Dt: TdateTime;
  sSql: string;
begin
  dStartTime  := now();
  result      :=  false;
  if (vCountry = '') or (vRegion = '') then
    exit;
  try
    if (vCountry = cRegionRec.Country) and (vRegion = cRegionRec.Region) then
      exit;
    with cRegionRec do
      begin
      Result    :=  false;
      Country   :=  vCountry;
      Region    :=  vRegion;
      Name      :=  '';
      Name1     :=  '';
      Name2     :=  '';
      Name3     :=  '';
      Phonetic  :=  '';
      Rank      :=  '';
      Latitude  :=  '';
      Longitude :=  '';
      FmDate    :=  LowDate;
      ToDate    :=  HighDate;
      result    :=  false;
      end;

    sSql := format('SELECT COUNTRY, REGION, NAME1, NAME2, NAME3, PHONETIC, RANK, '
         +  'LATITUDE, LONGITUDE, FMDATE, TODATE FROM REGION '
         +  'Where COUNTRY=''%s'' And REGION=''%s''; ', [vCountry, vRegion]);
    with qryCommon do
      begin
      Close;
      SQL.Clear;
      SQL.Add(sSql);
      Open;
      if RecordCount <> 0 then
        begin
        cRegionRec.result     := true;
        cRegionRec.Name1      := FieldByName('Name1').AsString;
        cRegionRec.Name2      := FieldByName('Name2').AsString;
        cRegionRec.Name3      := FieldByName('Name3').AsString;
        cRegionRec.Rank       := FieldByName('Rank').AsString;
        cRegionRec.Latitude   := FieldByName('Latitude').AsString;
        cRegionRec.Longitude  := FieldByName('Longitude').AsString;
        dt :=  FieldByName('FmDate').AsDateTime;
        if dt <= LowDate then
          cRegionRec.FmDate  := LowDate
        else
          cRegionRec.FmDate  := dt;
        dt :=  FieldByName('ToDate').AsDateTime;
        if dt <= LowDate then
          cRegionRec.ToDate  := HighDate
        else
          cRegionRec.ToDate  := dt;
        s :=  cRegionRec.Name1;
        if  vCountry  ='JPN' then
          begin
          s := s + cRegionRec.Name2 + cRegionRec.Name3;
          cRegionRec.Phonetic := FieldByName('Phonetic').AsString;
          end
        else
          if cRegionRec.Name2  <> '' then
            begin
            s := s + ',' + cRegionRec.Name2;
            if cRegionRec.Name3  <>  '' then
              s := s + ',' +  cRegionRec.Name3;
            end;
          end;
        cRegionRec.Name        := s;
      end;
  finally
    RegionRec := cRegionRec;
    result    := cRegionRec.result;
  end;
end;

function TEngine.CheckZipCode(vCountry,vZipCode: string; var ZipCodeRec: TZipCodeRec): boolean;
var
//  s: string;
//  Dt: TdateTime;
  sSql: string;
begin

  result      :=  false;
  try
    if (vCountry = cZipCodeRec.Country) and (vZipCode = cZipCodeRec.ZipCode) then
      exit;
    with cZipCodeRec do
      begin
      Result    :=  false;
      Country   :=  vCountry;
      ZipCode   :=  vZipCode;
      Region    :=  '';
      Name      :=  '';
      PrimaryCity := '';
      result    :=  false;
      end;

    sSql := format('SELECT a.COUNTRY, a.ZIPCODE, a.REGION, b.NAME, a.PRIMARYCITY'
        + ' FROM ZIPCODE a INNER JOIN REGION_V b ON (a.COUNTRY = b.COUNTRY) AND (a.REGION = b.REGION) '
        + ' WHERE (a.COUNTRY=''%s'') AND (a.ZIPCODE=''%s'');', [vCountry, vZipCode]);

    with qryCommon do
      begin
      Close;
      SQL.Clear;
      SQL.Add(sSql);
      Open;
      if RecordCount <> 0 then
        begin
        cZipCodeRec.result     := true;
        cZipCodeRec.Region     := FieldByName('REGION').AsString;
        cZipCodeRec.Name       := FieldByName('NAME').AsString;
        cZipCodeRec.PrimaryCity:= FieldByName('PRIMARYCITY').AsString;
        end;
      end;
  finally
    ZipCodeRec  := cZipCodeRec;
    result      := cZipCodeRec.result;
  end;
end;

procedure TEngine.ForwardQsoState();
begin
  if (FQsoState = lgTramp) then
    begin
    SetQsoState(lgInsert);
    end
  else if FQsoState = lgBrowse then
    begin
    SetQsoState(lgEdit);
    end;
end;

function TEngine.GetPastQSO(vCallsign, vOrgCallsign: string):boolean;
var
  sSql: string;
  qry: TIBQuery;
begin
  qry     :=  TIBQuery.Create(self);
  result  :=  false;
  try
    if vCallsign = '' then
      exit(false);
    if (vCallsign = PastQso.Callsign) and (vOrgCallsign = PastQso.OrgCallsign) then
      exit(PastQso.result);

    with PastQso do
      begin
      Callsign    := vCallsign;
      OrgCallsign := vOrgCallsign;
      Name        := '';
      Entity      := '';
      Country     := '';
      Region      := '';
      Continent   := '';
      ITUZone     := '';
      CQZone      := '';
      Iota        := '';
      Qsl         := '';
      QslManager  := '';
      Result      := false;
      end;

    sSql  := 'SELECT CALLSIGN, ORGCALLSIGN, ONDATETIME, NAME, ENTITY, COUNTRY, '
          +  'REGION, CONTINENT, ITUZONE, CQZONE, IOTA, QSL, '
          +  'QSLMANAGER FROM QSOLOG '
          + ' WHERE ORGCALLSIGN = ' + QuotedStr(vOrgCallsign)
          + ' ORDER BY NUM DESC;';
    with qry do
      begin
      qry.Database := dbLogBase;
      Sql.Clear;
      SQL.Add(sSql);
      Open;
      First;
      while not EOF do
        begin
        if (PastQso.Name = '') and (FieldByName('Name').AsString <> '') then
          begin
          PastQso.Name          := FieldByName('Name').AsString;
          PastQso.result        := true;
          end;
        if (vCallsign = FieldByName('CALLSIGN').AsString) then
          if (vCallsign = vOrgCallsign)      // 移動していないとき
          or ((vCallsign <> vOrgCallsign)    // 移動していて　且　10日以内のとき
            and (FieldByName('ONDATETIME').asDateTime >= Now() - 10)) then
            begin
            if PastQso.Entity     = '' then
              PastQso.Entity        := FieldByName('Entity').AsString;
            if PastQso.Country     = '' then
              PastQso.Country        := FieldByName('Country').AsString;
            if (Length(FieldByName('Region').AsString) > Length(PastQso.Region)) then
              begin
//              PastQso.Country       := FieldByName('Country').AsString;
              PastQso.Region        := FieldByName('Region').AsString;
              end;
            if PastQso.Continent  = '' then
              PastQso.Continent     := FieldByName('Continent').AsString;
            if PastQso.ItuZone    = '' then
              PastQso.ItuZone       := FieldByName('ItuZone').AsString;
            if PastQso.CqZone     = '' then
              PastQso.CqZone        := FieldByName('CqZone').AsString;
            if PastQso.Iota       = '' then
              PastQso.Iota         := FieldByName('Iota').AsString;
            if PastQso.Qsl        = '' then
              PastQso.Qsl           := FieldByName('Qsl').AsString;
            if PastQso.QslManager = '' then
              PastQso.QslManager    := FieldByName('QslManager').AsString;
            end;
        if  (PastQso.Name <> '') and (PastQso.Entity <> '')
        and (PastQso.Region <> '')   then
          begin
          Close;
          PastQso.result  := true;
          exit;       // while文を終了
          end;
        Next;
        end;
      if  (PastQso.Name <> '') or (PastQso.Entity <> '')
      or (PastQso.Region <> '')   then
        PastQso.result  := true;
      Close;
      end;
  finally
    FreeAndNil(qry);
    result  := PastQso.result;
  end;
end;

procedure TEngine.GetBandList(FromBand, ToBand: string; var BandList: TStringList);
var
  qry: TIBQuery;
//  s1, s2: string;
  s : string;
begin
  qry := TIBQuery.Create(Self);
  try
    BandList.Clear;
    if FromBand = ToBand then
      exit;
    s := format('Select %0:s, %1:s FROM Band ORDER BY %0:s;', [FromBand, ToBand]);
    with qry do
      begin
      qry.Database := dbReference;
      Sql.Clear;
      SQL.Add(s);
      Open;
      First;
      while not Eof do
        begin
        s := Fields[0].AsString + '=' + Fields[1].AsString;
        BandList.Add(s);
        Next;
        end;
      Close;
      end;
  finally
    FreeAndNil(qry);
  end;
end;

function TEngine.GetCallbook(vCallsign: string): Boolean;
var
  qry: TIBQuery;
  sSql: string;
begin
  qry :=  TIBQuery.Create(Self);
  try
    if (vCallsign = pCallbook.Callsign) then
      begin
      result  := pCallbook.result;
      exit;
      end;

    with PCallbook do
      begin
      Callsign  := vCallsign;
      Name      := '';
      Entity    := '';
      Country   := '';
      Region    := '';
      comment   := '';
      result    := false;
      end;

    with qry do
      begin
      Database :=  dbReference;
      sSql  := 'SELECT * FROM CALLBOOK '
            + ' WHERE CALLSIGN = ' + QuotedStr(vCallsign) ;
      Sql.Add(sSql);
      Open;
      First;
      if Not EOF then
        begin
        PCallbook.Name          := FieldByName('Name').AsString;
        PCallbook.Entity        := FieldByName('Entity').AsString;
        PCallbook.Country       := FieldByName('Country').AsString;
        PCallbook.Region        := FieldByName('Region').AsString;
        PCallbook.Comment       := FieldByName('Memo').AsString;
        PCallbook.result        := true;
        end;
      Close;
      end;
  finally
    FreeAndNil(qry);
    result  := pCallbook.result;
  end;
end;

function TEngine.GetCallBookEx(vCallsign: string; vOnDate: TDateTime):boolean;
var
  s: string;
  dt: TDate;
  qry: TIBQuery;
  sSql: string;
begin
  qry := TIBQuery.Create(Self);
  try
    DT  :=  DateOf(vOnDate);
    if (vCallsign = pCallbookEx.Callsign) and (Dt = pCallbookEx.OnDate) then
      begin
      Result  := pCallbookEx.result;
      exit;
      end;

    with PCallbookEx do
      begin
      Callsign   := vCallsign;
      OnDate     := Dt;
      Entity     := '';
      Continent  := '';
      ITUZone    := '';
      CQZone     := '';
      Longitude  := '';
      Latitude   := '';
      result     := false;
      end;

    with qry do
      begin
      Database :=  dbReference;
      s := FormatDateTime('yyyy/mm/dd', Dt);
      sSql  := 'SELECT * FROM CALLBOOKEX '
            + ' WHERE CALLSIGN = ' + QuotedStr(vCallsign)
            + ' AND  (FMDATE is Null or FMDATE <= ' + QuotedStr(s) + ')'
            + ' AND  (TODATE is Null or TODATE >= ' + QuotedStr(s) + ')';
      Sql.Add(sSql);
      Open;
      First;
      if Not EOF then
        begin
        PCallbookEx.Entity      := FieldByName('Entity').AsString;
        PCallbookEx.GridLoc     := FieldByName('GridLoc').AsString;
        PCallbookEx.Continent   := FieldByName('Continent').AsString;
        PCallbookEx.ITUZone     := FieldByName('ITUZone').AsString;
        PCallbookEx.CQZone      := FieldByName('CQZone').AsString;
        PCallbookEx.Latitude    := FieldByName('Latitude').AsString;
        PCallbookEx.Longitude   := FieldByName('Latitude').AsString;
        PCallbookEx.result      := true;
        end;
      Close;
      end;
  finally
    FreeAndNil(qry);
    Result  := pCallbookEx.result;
  end;
end;

procedure TEngine.GetContinentList(Entity: string; var ContinentList: TStringList);
var
  wEntityRec: tEntityRec;
begin
  if CheckEntity(Entity, wEntityRec) then
    ContinentList.CommaText  := wEntityRec.Continents
  else
    ContinentList.Clear  ;
end;

procedure TEngine.GetCqZoneList(Entity: string; var CqZoneList: TStringList);
var
  wEntityRec: tEntityRec;
begin
  if CheckEntity(Entity, wEntityRec) then
    CqZoneList.CommaText  := wEntityRec.CqZones
  else
    CqZoneList.Clear;
end;

function TEngine.GetEntityByEntityCode(EntityCode: string; var EntityRec: TentityRec): boolean;
var
  WEntityCode: string;
begin
  wEntityCode :=  '000' + EntityCode;
  wEntityCode := Copy(wEntityCode, Length(wEntityCode)-2, 3);
  EntityRec.result := false;
  qryCommon.Close;
  qryCommon.SQL.Clear;
  qryCommon.SQL.Add('SELECT * FROM ENTITY WHERE ENTITYCODE = ' + QuotedStr(EntityCode) + ';');
  qryCommon.Open;
  if not qryCommon.Eof then
    begin
    EntityRec.EntityCode := EntityCode;
    EntityRec.Entity  := qryCommon.FieldByName('ENTITY').AsString;
    EntityRec.Country := qryCommon.FieldByName('Country').AsString;
    EntityRec.result  := True;
    end;
  qryCommon.Close;
  result := EntityRec.result;
end;

procedure TEngine.GetEntityList(Prefix, Suffix: string; OnDate: TDateTime; var EntityList: TStringList);
var
  sPrefix: string;
  i: integer;
  L: Integer;
begin
  try
    try
      sPrefix  := Prefix + Copy(Suffix,1,1);
      if  (pEntityListKey1 <> '')
      and (pEntityListKey1 = Copy(sPrefix, 1, Length(pEntityListKey1)))
      and (pEntityListKey2 = DateOf(OnDate)) then
        exit;

      pEntityListKey1     := sPrefix;
      pEntityListKey2     := DateOf(OnDate);
      with qryCommon do
        begin
        Close;
        qryCommon.SQL.Clear;
        qryCommon.SQL.Add('SELECT  a.FMPREFIX, a.TOPREFIX, a.NUM, a.ENTITY, ');
        qryCommon.SQL.Add('b.NAME, b.FMDATE, b.TODATE ');
        qryCommon.SQL.Add('FROM PREFIX a LEFT JOIN ENTITY b ON a.ENTITY = b.ENTITY ');
        qryCommon.SQL.Add('WHERE (a.FMPREFIX<=:PREFIX) AND (a.TOPREFIX>=:PREFIX) ');
        qryCommon.SQL.Add('AND ((a.FmDate IS NULL) OR  (a.FmDate<=:ONDATE)) ');
        qryCommon.SQL.Add('AND ((a.ToDate IS NULL) OR  (a.ToDate>=:ONDATE)) ');
        qryCommon.SQL.Add('ORDER BY a.FMPREFIX, a.TOPREFIX, Num;');
        qryCommon.Prepared := true;
        end;

      FEntityList.Clear;
      for i := Length(pEntityListKey1) downto 1 do
        begin
        with qryCommon do
          begin
          sPrefix                   := Copy(pEntityListKey1, 1, I);
          Params.ParamByName('PREFIX').AsString   := sPrefix;
          Params.ParamByName('ONDATE').AsDate     := pEntityListKey2;
          L := Length(sPrefix);
          Open;
          While not Eof do
            begin
            if Length(qryCommon.Fields[0].asString) = L then
              FEntityList.ADD(FieldByName('ENTITY').AsString + '=' + FieldByName('NAME').AsString);
            Next;
            end;
          Close;
        end;
        if FEntityList.Count <> 0 then
          break;
        end;
      except
        MessageDlg('MakeEntityList --- Error ',mtError, [mbOK],0);
      end;
  finally;
    if FEntityList.Count = 0 then
      pEntityListKey1     := '';
    EntityList.Text := FEntityList.Text;
  end;
end;

function TEngine.GetEntityName(vEntity: string): string;
var
  wEntityRec:  TEntityRec;
begin
  if CheckEntity(vEntity, wEntityRec) then
    result  :=  wEntityRec.Name
  else
    result  := '';
end;

procedure TEngine.GetEtcList(Table, Country, Region: string; var List: TStringList);
var
  sSql: string;
begin
  try
    List.Clear;
    if (Country = 'JPN') and (Length(Region) = 2) then
      begin
      sSql := 'SELECT a.CODE, a.NAME '  +
              ' FROM ' + Table + ' a LEFT JOIN ' + Table + '_REGION b ' +
              ' ON a.Code = b.Code ' +
      ' WHERE (a.COUNTRY=' + QuotedStr(Country) + ' And a.REGION Like ' + QuotedStr(Region + '%') + ')' +
         ' or (b.COUNTRY=' + QuotedStr(Country) + ' And b.REGION Like ' + QuotedStr(Region + '%') + ')' +
      ' GROUP BY a.CODE, a.NAME;';
      end
    else
      begin
      sSql := 'SELECT a.CODE, a.NAME ' +
              ' FROM ' + Table + ' a LEFT JOIN ' + Table + '_REGION b ' +
              ' ON a.Code = b.Code ' +
      ' WHERE (a.COUNTRY=' + QuotedStr(Country) + ' And a.REGION=' + QuotedStr(Region) + ')' +
         ' or (b.COUNTRY=' + QuotedStr(Country) + ' And b.REGION=' + QuotedStr(Region) + ')' +
      ' GROUP BY a.CODE, a.NAME;';
      end;
    with qryCommon do
      begin
      Close;
      SQL.Clear;
      SQL.Add(sSql);
      Open;
      While not Eof do
        begin
        List.ADD(FieldByName('Code').AsString + '=' + FieldByName('Name').AsString);
        Next;
        end;
      Close;
      end;
  except
    MessageDlg('GetEtcList --- Error ',mtError, [mbOK],0);
  end;
end;

procedure TEngine.GetFreqFormatList(var FreqFormatList: TStringList);
var
  s: string;
  qry: TIBQuery;
begin
  qry := TIBQuery.Create(self);
  try
    FreqFormatList.Clear;
    with qry do
      begin
      Close;
      Database := dbReference;
      Sql.clear;
      Sql.Add('SELECT MODE, FREQFORMAT FROM MODE;');
      Open;
      while not EOF do
        begin
        s := Fields[0].asString + '=' + Fields[1].asString;
        FreqFormatList.Add(s);
        Next;
        end;
      Close;
      end;
  finally
    FreeAndNil(qry);
  end;
end;

procedure TEngine.GetIOTAListByEntity(Entity: string; var IotaList: TStringList);
var
  sSql: string;
begin
  IotaList.Clear;
  try
    sSql := format('SELECT A.IOTA, A.NAME '
          + ' FROM IOTA A INNER JOIN IOTA_ENTITY B ON A.IOTA = B.IOTA '
          + ' WHERE (B.ENTITY=''%s'' AND A.DELETED=0) '
          + ' ORDER BY A.IOTA', [Entity]);
    with qryCommon do
      begin
      Close;
      SQL.Clear;
      SQL.Add(sSql);
      Open;
      While not Eof do
        begin
        IOTAList.ADD(FieldByName('IOTA').AsString + '=' + FieldByName('Name').AsString);
        Next;
        end;
      Close;
      end;
  except
    MessageDlg('GetIOTAListByEntity --- Error ',mtError, [mbOK],0);
  end;
end;

procedure TEngine.GetIotaListByRegion(Country, Region: string; var IotaList: TStringList);
var
  sSql: string;
begin
  IOTAList.Clear;
  try
    sSql := format('SELECT a.IOTA, a.NAME  '
          + ' FROM IOTA a INNER JOIN IOTA_REGION b ON A.IOTA = B.IOTA  '
          + ' WHERE (b.COUNTRY=''%0:s'') AND (a.DELETED=0) '
          + ' AND (b.FMREGION<=''%1:s'') AND ((b.TOREGION||''ZZZZZZZZ'')>=''%1:s'')'
          + ' ORDER BY a.IOTA', [Country, Region]);
    with qryCommon do
      begin
      Close;
      SQL.Clear;
      SQL.Add(sSql);
      Open;
      While not Eof do
        begin
        IOTAList.ADD(FieldByName('IOTA').AsString + '=' + FieldByName('Name').AsString);
        Next;
        end;
      Close;
      end;
  except
    MessageDlg('GetIOTAListByRegion --- Error ',mtError, [mbOK],0);
  end;
end;

procedure TEngine.GetItuZoneList(Entity: string; var ItuZoneList: TStringList);
var
  wEntityRec:  TEntityRec;
begin
  if CheckEntity(Entity, wEntityRec) then
    ItuZoneList.CommaText  := wEntityRec.ItuZones
  else
    ItuZoneList.Clear  ;
end;

procedure TEngine.GetQslList(var QslList: TStringList);
begin
//  GetQslCommonList('Q', QslList, FQslDefault);
  GetQslCommonList('Q', QslList);
end;

procedure TEngine.GetQslRecvList(var QslRecvList: TStringList);
begin
//  GetQslCommonList('R', QslRecvList, FQslRecvDefault);
  GetQslCommonList('R', QslRecvList);
end;

procedure TEngine.GetQslSendList(var QslSendList: TStringList);
begin
//  GetQslCommonList('S', QslSendList, FQslSendDefault);
  GetQslCommonList('S', QslSendList);
end;

procedure TEngine.GetModeList(var ModeList: TStringList);
var
  qry: TIBQuery;
begin
  qry := TIBQuery.Create(self);
  try
    ModeList.Clear;
    with qry do
      begin
      Close;
      Database := dbReference;
      Sql.clear;
      Sql.Add('SELECT MODE FROM MODE WHERE USE = -1 ');
      Sql.Add('ORDER By MODE; ');
      Open;
      while not EOF do
        begin
        ModeList.Add(Fields[0].asString);
        Next;
        end;
      Close;
      end;
  finally
    FreeAndNil(qry);
  end;
end;

procedure TEngine.GetOptionsData;  // uLogBaseAppからよばれるのみ
var
  s:  string;
  r:double;
  XmlIni: TXmlIniFile;
begin
  XmlIni := TXmlIniFile.Create(FXmlIniFileName);
  try
    with FOptionsData    do
      begin
      XmlIni.OpenNode('/Profile', true);
      Callsign  := XmlIni.ReadString('Callsign', '');
      Entity    := XmlIni.ReadString('Entity', '');
      Country   := XmlIni.ReadString('Country', '');
      Region    := XmlIni.ReadString('Region', '');
      s :=  XmlIni.ReadString('Latitude', 'N0,0,0');
      StrToDeg(s, drLatitude, r);
      Latitude := r;
      s :=  XmlIni.ReadString('Longitude', 'E0,0,0');
      StrToDeg(s, drLongitude, r);
      Longitude := r;

// for QSL
      XmlIni.OpenNode('/Qsl', true);
      FQslDefault     := XmlIni.ReadString('QslDefault', 'J');
      FQslSendDefault := XmlIni.ReadString('QslSendDefault', 'S');
      FQslRecvDefault := XmlIni.ReadString('QslRecvDefault', 'R');
      pQslSendAction  := UpperCase(XmlIni.ReadString('QslSendAction', 'Today'));
      if pQslSendAction = 'TODAY' then
        FQslSendDate  := now()
      else if Uppercase(pQslSendAction) = 'VALUE' then
        FQslSendDate  := XmlIni.ReadDate('QslSendDate', LowDate)
      else
        FQslSendDate  := LowDate;
      pQslRecvAction    := UpperCase(XmlIni.ReadString('QslRecvAction', 'Today'));
      if UpperCase(pQslRecvAction) = 'TODAY' then
        FQslRecvDate  := now()
      else if pQslRecvAction = 'VALUE' then
        FQslRecvDate  := XmlIni.ReadDate('QslRecvDate', LowDate)
      else
        FQslRecvDate  := LowDate;

      XmlIni.OpenNode('/Internet', true);
      Internet      := XmlIni.ReadBool('Internet', false);
      Jarl          := XmlIni.ReadBool('JARL', false);
      JarlUrl       := XmlIni.ReadString('JARL_URL', '');
      Mic           := XmlIni.ReadBool('MIC', false);
      MicUrl        := XmlIni.ReadString('MIC_URL', '');
      LoTw          := XmlIni.ReadBool('LoTW', false);
      LotwLocation  := XmlIni.ReadString('LoTW_Location', '');
      LotwIntervalMin  := XmlIni.ReadInteger('LoTW_Interval_Min', 0);
      end;
  if Assigned(JarlThread) then
    FreeAndNil(JarlThread);
  if Assigned(LicenceThread) then
      FreeAndNil(LicenceThread);
  if FOptionsData.Internet then
    begin
    if FOptionsData.jarl and (FOptionsData.JarlUrl <> '') then
      begin
      JarlThread := TJarl.Create(FOptionsData.JarlUrl);
      jarlThread.OnGet  := JARLThreadGet;
      end;
    if FOptionsData.Mic and (FOptionsData.MicUrl <> '') then
      begin
      LicenceThread := TLicence.Create((FOptionsData.MicUrl));
      LicenceThread.OnGet  := LicenceThreadGet;
      end;
    end;
  finally
    FreeAndNil(XmlIni);
  end;
end;

procedure TEngine.GetMyDataRec;  // uLogBaseAppからよばれるのみ
var
  wMyDataRec: TMyDataRec;
  XmlIni: TXmlIniFile;
begin
  XmlIni := TXmlIniFile.Create(FXmlIniFileName);
  try
    if XmlIni.OpenNode('/MyData', false) then
        begin
        with wMyDataRec do
          begin
          MyCallsign  := XmlIni.ReadString('Callsign', '');
          MyEntity    := XmlIni.ReadString('Entity', '');
          MyCountry   := XmlIni.ReadString('Country', '');
          MyRegion    := XmlIni.ReadString('Region', '');
          MyGridLoc   := XmlIni.ReadString('GridLoc', '');
          MyRig       := XmlIni.ReadString('Rig', '');
          MyAnt       := XmlIni.ReadString('Ant', '');
          MyMemo      := XmlIni.ReadString('Memo', '');
          end;
        MyDataRec   :=  wMyDataRec;
        end;
  finally
    FreeAndNil(XmlIni);
  end;
end;

procedure TEngine.GetQsoLog(Num: Integer; var QsoList: TStringList);
var
  qry: TIBQuery;
  i: integer;
  fld: string;
  val: variant;
begin
  qry := TIBQuery.Create(self);
  try
    QsoList.Clear;
    with qry do
      begin
      Database := dbLogBase;
      Sql.Add('SELECT * FROM QsoLog WHERE Num = ' + IntToStr(Num) + ';');
      Open;
      if not EOF then
        for i := 0 to Fields.Count - 1 do
          begin
          fld := Fields[i].FieldName;
          val := '';
          case Fields[i].DataType of
            ftString, ftWideString:
              val := Fields[i].Value;
            ftBoolean:
              val := Variant(Fields[i].Value);
            ftInteger, ftSmallint, ftLargeInt:
              val := IntToStr(Fields[i].Value);
            ftDateTime:
              if Fields[i].Value > FLowDate then
                val := formatDateTime('yyyy/mm/dd hh:nn', Fields[i].Value);
            ftDate:
              if Fields[i].Value > FLowDate then
                val := formatDateTime('yyyy/mm/dd', Fields[i].Value);
            ftFloat:
              val := FloatToStr(Fields[i].Value);
            end;
          val := trim(Val);
          if Val <> '' then
            QsoList.Add(fld + '=' + val);
          end;
      Close;
      end;
  finally
    FreeAndNil(qry);
  end;
end;

function TEngine.GetRegionFromName(RegionName: string; var Region: string): boolean;
var
  Brx: TSkRegExp;
  RegionName1: string;
  RegionName2: string;
  RegionName3: string;
  s,r: string;
  function QueryRegion(Name1, Name2, Name3: string; var Region: string): boolean;
  var
    Qry: TIBQuery;
    sSql: string;
  begin
    result := false;
    r := '';
    qry := TIBQuery.Create(self);
    try
      with qry do
        begin
        Database := dbReference;
        sSql := 'SELECT COUNTRY, REGION, NAME1, NAME2, NAME2, TODATE FROM REGION '
             +  'WHERE (COUNTRY=''JPN'') AND ((TODATE Is Null) Or TODATE>CURRENT_DATE) '
             +   ' AND (NAME1=' + QuotedStr(Name1) + ') ';
        if Name2 <> '' then
          sSql := sSQl + ' AND (NAME2=' + QuotedStr(Name2) + ') '
        else  ;
          if Name1 = '東京都' then
            sSql := sSQl + ' AND (NAME2 is Null) ';
        if Name3 <> '' then
          sSql := sSQl + ' AND (NAME3=' + QuotedStr(Name3) + ') ';
        Sql.Add(sSql);
        Open;
        while not EOF do
          begin
          r := FieldByName('Region').asString;
          result := true;
          Next;
          end;
        Close;
        end;
    finally
      Region := r;
      FreeAndNil(qry);
    end;
  end;
begin
  result := true;
  Region := '';
  if RegionName = '' then
    exit;

//  この2つの島名だけが入いている。島名を空白にする
  RegionName := RegReplace('(三宅島|八丈島)', RegionName, '');
  Brx := TSkRegExp.Create;
  try
//  都道府県・市郡区・町村に分割する。市郡区名に漢字[市][郡][区]があるケース想定
    Brx.Expression := '^(.+[都道府県])(.*?[市郡区])?(.*?[市郡区])?(.*)';
    if Brx.Exec(RegionName) then
      begin
      RegionName1 := Brx.Match[1];
      RegionName2 := Brx.Match[2];
      if (RegionName1 = '東京都') and (Brx.Match[2] = '')  //  東京都の島
      and (Brx.Match[3] = '') and (Brx.Match[4]<>'') then
        begin
        s := Brx.Match[4];
        if not QueryRegion(RegionName1, '', s, r) then
          result := false;
        exit;
        end;
      if QueryRegion(RegionName1, RegionName2, '', r) then
        if Copy(RegionName2, Length(RegionName2), 1) = '区' then  //  東京都の区
          exit
        else
          s := Brx.Match[3] + Brx.Match[4]
      else                              //　市郡名の中に市・郡の文字がある
        begin
        RegionName2 := Brx.Match[2] + Brx.Match[3];
        s := Brx.Match[4];
        if not QueryRegion(RegionName1, RegionName2, '', r) then
          result := false;
        end;
      RegionName3 := s;
      if s <> '' then                   //  町村区
        if not QueryRegion(RegionName1, RegionName2, RegionName3, r) then
          if (RegionName1 =  '北海道')   //  北海道の2つ支庁にまたがる郡
          and (Copy(RegionName2, Length(RegionName2), 1) = '郡') then
            if not QueryRegion(RegionName1, '', RegionName3, r) then
              result := false
            else
              begin
              end
          else
            result := false;
    end;
  finally
    Region := r;
    FreeAndNil(Brx);
  end;
end;

procedure TEngine.GetRegionList(Country, Region: string; OnDate: TDateTime; var RegionList: TStringList);
var
  s:  string;
  wRegionRec: TRegionRec;
begin
  try
    if (Country = pRegionListKey1) and (Region = pRegionListKey2)
    and (DateOf(OnDate) = pRegionListKey3) then
      exit;

    pRegionListKey1     := Country;
    pRegionListKey2     := Region;
    pRegionListKey3     := DateOf(OnDate);
    FRegionList.Clear;

    if CheckRegion(pRegionListKey1, pRegionListKey2, wRegionRec) then
      begin
      s := pRegionListKey2 + '=' + wRegionRec.Name;
      FRegionList.ADD(s);
//    if pRegionListKey1 = 'JPN' then
      GetRegionList_JA()
//    else
//      GetRegionList_Else();
      end;
  finally
    RegionList.Text := FRegionList.Text;
  end;
end;

procedure TEngine.GetRegionList_JA();
var
  sSql: string;
  s: string;
  d: string;
begin
  try
    d    := FormatDateTime('YYYY/MM/DD', pRegionListKey3);
    sSql := format('SELECT REGION, NAME, RANK, FMDATE, TODATE '
           + 'FROM REGION_V '
           + 'WHERE (COUNTRY=''%0:s'') AND (PARENTREGION=''%1:s'') '
           +  'ORDER BY RANK, REGION', [pRegionListKey1,pRegionListKey2]);
    with QryCommon do
      begin
      Close;
      Sql.Clear;
      SQL.ADD(sSql);
      Open;
      While not Eof do
        begin
        if  ((FieldByName('FmDate').AsString = '') or (FieldByName('FmDate').AsDateTime <= pRegionListKey3))
        and ((FieldByName('ToDate').asString = '') or (FieldByName('ToDate').AsDateTime >= pRegionListKey3)) then
          begin
          s := FieldByName('Region').AsString + '=' + FieldByName('Name').AsString;
          if FieldByName('FmDate').AsString > d then
            s := s  + '(' + FieldByName('FmDate').AsString + ')';
          FRegionList.ADD(s);
          end;
        Next;
        end;
      Close;
      end;
  except
    MessageDlg('MakeRegionList_JA --- Error ',mtError, [mbOK],0);
  end;
end;

//procedure TEngine.GetQslCommonList(Qsl: string; var List: TStringList; var Default: string);
procedure TEngine.GetQslCommonList(Qsl: string; var List: TStringList);
var
  s: string;
begin
  try
    List.Clear;
//    Default := '';
    with QryCommon do
      begin
      Close;
      s := 'SELECT * FROM QSL WHERE (QSL = ' + QuotedStr(Qsl) + ') AND (USE = -1) ORDER BY KEY;';
      SQL.Clear;
      SQL.Add(s);
      Open;
      while not EOF do
        begin
        s := FieldByName('Key').asString + '=' + FieldByName('Name').AsString;
        List.Add(s);
//        if FieldByName('DefaultKey').AsInteger = -1 then
//          Default := FieldByName('Key').asString;
        Next;
        end;
      Close;
      end;
  except
    MessageDlg('MakNetQsoList Error ',mtError, [mbOK],0);
  end;
end;

procedure TEngine.GetRepeaterList(Route: string; var RepeaterList: TStringList);
var
  sSql: string;
begin
  try
    RepeaterList.Clear;
    sSql := format('SELECT REPEATER, UPLINKFREQ, DOWNLINKFREQ '
           +  'FROM REPEATER '
           +  'WHERE (ROUTE = ''%s'') AND (USE = -1) '
           +  'ORDER BY REPEATER;', [Route]);
    with QryCommon do
      begin
      Close;
      Sql.Clear;
      SQL.ADD(sSql);
      Open;
      While not Eof do
        begin
        RepeaterList.ADD(FieldByName('Repeater').AsString);
        Next;
        end;
      Close;
      end;
  except
    MessageDlg('GetRepeaterList --- Error ',mtError, [mbOK],0);
  end;
end;

procedure TEngine.GetRouteList(var RouteList: TStringList);
begin
  RouteList.Clear;
  try
    with QryCommon do
      begin
      Close;
      Sql.Clear;
      SQL.ADD('SELECT ROUTE, NEEDREPEATER FROM ROUTE ');
      SQL.ADD(' WHERE USE = -1 ');
      SQL.ADD(' ORDER BY ROUTE;');
      Open;
      While not Eof do
        begin
        RouteList.Add(FieldByName('Route').asString);
        Next;
        end;
      Close;
      end;
  except
    MessageDlg('GetRouteList --- Error ',mtError, [mbOK],0);
  end;
end;

function TEngine.SetFromPastQso(vCallsign, vOrgCallsign: string): boolean;
var
  wRegionRec: TRegionRec;
begin
  result := false;
  if GetPastQSO(vCallsign, vOrgCallsign) then
    begin
    if cdsQsoName.asString = '' then
      SetTblQsoStringField('Name', PastQso.Name);
    if cdsQsoEntity.AsString = '' then
      SetTblQsoStringField('Entity', PastQso.Entity);
    if cdsQsoCountry.AsString = '' then
      SetTblQsoStringField('Country', PastQso.Country);
    if cdsQsoRegion.AsString <> 'JPN' then
      begin
      CheckRegion(cdsQsoCountry.Value, PastQso.Region, wRegionRec);
      if DateOf(cdsQsoOnDateTime.Value) <= wRegionRec.ToDate then
        SetTblQsoStringField('Region', PastQso.Region);
      end;
    if cdsQsoContinent.AsString = '' then
      SetTblQsoStringField('Continent', PastQso.Continent);
    if cdsQsoCqZone.AsString = '' then
      SetTblQsoStringField('CqZone', PastQso.CqZone);
    if cdsQsoItuZone.AsString = '' then
      SetTblQsoStringField('ItuZone', PastQso.ITUZone);
    if PastQso.Country <> 'JPN' then
      if cdsQsoQsl.AsString = '' then
        SetTblQsoStringField('Qsl', PastQso.Qsl);
    if cdsQsoQslManager.AsString = '' then
      SetTblQsoStringField('QslManager', PastQso.QslManager);
    result := true;
    end;
end;

function TEngine.SetFromCallbookEx(vCallsign: string; vDT: TDateTime): boolean;
begin
  result := false;
  if GetCallbookEx(vCallsign, vDt) then
    begin
    if cdsQsoEntity.AsString = '' then
      SetTblQsoStringField('Entity', PCallbookEx.Entity);
    if cdsQsoCountry.AsString = '' then
      SetTblQsoStringField('Country', PCallbookEx.Country);
    if cdsQsoRegion.AsString <> 'JPN' then
      SetTblQsoStringField('Region', PCallbookEx.Region);
    if cdsQsoContinent.AsString = '' then
      SetTblQsoStringField('Continent', PCallbookEx.Continent);
    if cdsQsoCqZone.AsString = '' then
      SetTblQsoStringField('CqZone', PCallbookEx.CqZone);
    if cdsQsoItuZone.AsString = '' then
      SetTblQsoStringField('ITUZone', PCallbookEx.ITUZone);
    result := true;
    end;
end;

// Callsignで値を設定
function TEngine.SetFromCallbook(vCallsign: string): boolean;
begin
    result := false;
    if GetCallbook(vCallsign) then
      begin
      SetTblQsoStringField('Name', PCallbook.Name);
      SetTblQsoStringField('Entity', PCallbook.Entity);
      SetTblQsoStringField('Country', PCallbook.Country);
      SetTblQsoStringField('Region', PCallbook.Region);
      result := true;
     end
end;

// OrgCallsignで値を設定
function TEngine.SetFromOrgCallbook(vCallsign: string): boolean;
begin
    result := false;
    if GetCallbook(vCallsign) then
      begin
      SetTblQsoStringField('Name', PCallbook.Name);
//      SetTblQsoStringField('Country', PCallbook.Country);
//      SetTblQsoStringField('Region', PCallbook.Region);
//      SetTblQsoStringField('Entity', PCallbook.Entity);
      result := true;
     end
end;

procedure TEngine.SetGLfmBeforeQSO();
var
  sSql: string;
begin
  sSql := format('SELECT GRIDLOC, ORGCALLSIGN, COUNTRY, REGION, OnDateTime'
       +   ' FROM QSOLOG '
       +   ' WHERE (ORGCALLSIGN=''%s'') AND (COUNTRY=''%s'') '
       +   ' AND (REGION=''%s'') AND GRIDLOC<>'''' '
       +   ' ORDER BY ONDATETIME DESC;',
        [cdsQsoCallsign.AsString, cdsQsoCountry.AsString, cdsQsoRegion.AsString]);
  with qryQsoLog do
    begin
    Close;
    SQL.Clear;
    SQL.Add(sSql);
    Open;
    First;
    if not Eof then
      begin
      Inc(bAutoInput[cdsQsoGridLoc.Index]);
      cdsQsoGridLoc.AsString := FieldByName('GridLoc').asString;
      Dec(bAutoInput[cdsQsoGridLoc.Index]);
      end;
    end;
end;

procedure TEngine.SetIotafmBeforeQSO();
var
  sSql: string;
begin
  sSql := format('SELECT IOTA, ORGCALLSIGN, COUNTRY, REGION, OnDateTime'
       +   ' FROM QSOLOG '
       +   ' WHERE (ORGCALLSIGN=''%s'') AND (COUNTRY=''%s'') '
       +   ' AND (REGION=''%s'') AND IOTA<>'''' '
       +   ' ORDER BY ONDATETIME DESC;',
        [cdsQsoCallsign.AsString, cdsQsoCountry.AsString, cdsQsoRegion.AsString]);
  with qryQsoLog do
    begin
    Close;
    SQL.Clear;
    SQL.Add(sSql);
    Open;
    First;
    if not Eof then
      begin
      Inc(bAutoInput[cdsQsoIota.Index]);
      cdsQsoIota.AsString := FieldByName('Iota').asString;
      Dec(bAutoInput[cdsQsoIota.Index]);
      end;
    end;
end;

procedure TEngine.SetMyAnt(const Value: string);
begin
  if cdsQsoMyAnt.Value  <>  Value then
    begin
    cdsQsoMyAnt.Value  :=  Value;
    if FQsoState = lgBrowse then
      ForwardQsoState;
    end;
end;

procedure TEngine.SetMyCallsign(const Value: string);
begin
  if cdsQsoMyCallsign.Value  <>  Value then
    begin
    cdsQsoMyCallsign.Value  :=  Value;
    if FQsoState = lgBrowse then
      ForwardQsoState;
    end;
end;

procedure TEngine.SetMyCountry(const Value: string);
begin
  if cdsQsoMyCountry.Value  <>  Value then
    begin
    cdsQsoMyCountry.Value  :=  Value;
    if FQsoState = lgBrowse then
      ForwardQsoState;
    end;
end;

procedure TEngine.SetMyDataRec(const Value: TMyDataRec);
var
  wEntityRec: TEntityRec;
  wRegionRec: TRegionRec;
begin
  FMyDataRec := Value;
  if CheckEntity(FMyDataRec.MyEntity, wEntityRec) then
    FMyDataRec.MyEntityName := wEntityRec.Name;
  if CheckRegion(FMyDataRec.MyCountry, FMyDataRec.MyRegion, wRegionRec) then
    FMyDataRec.MyRegionName := wRegionRec.Name;
end;

procedure TEngine.SetMyEntity(const Value: string);
begin
  if cdsQsoMyEntity.Value  <>  Value then
    begin
    cdsQsoMyEntity.Value  :=  Value;
    if FQsoState = lgBrowse then
      ForwardQsoState;
    end;
end;

procedure TEngine.SetMyGridLoc(const Value: string);
begin
  if cdsQsoMyGridLoc.Value  <>  Value then
    begin
    cdsQsoMyGridLoc.Value  :=  Value;
    if FQsoState = lgBrowse then
      ForwardQsoState;
    end;
end;

procedure TEngine.SetMyMemo(const Value: string);
begin
  if cdsQsoMyMemo.Value  <>  Value then
    begin
    cdsQsoMyMemo.Value  :=  Value;
    if FQsoState = lgBrowse then
      ForwardQsoState;
    end;
end;

procedure TEngine.SetMyRegion(const Value: string);
begin
  if cdsQsoMyRegion.Value  <>  Value then
    begin
    cdsQsoMyRegion.Value  :=  Value;
    if FQsoState = lgBrowse then
      ForwardQsoState;
    end;
end;

procedure TEngine.SetMyRig(const Value: string);
begin
  if cdsQsoMyRig.Value  <>  Value then
    begin
    cdsQsoMyRig.Value  :=  Value;
    if FQsoState = lgBrowse then
      ForwardQsoState;
    end;
end;

procedure TEngine.SetOptionsData(const Value: TOptionsData);
begin
end;

procedure TEngine.SetProcessing(const Value: TProcessing);
begin
  FProcessing := Value;
  ChangeProcessing;
end;

function TEngine.CloseFindRegion: boolean;
begin
  if qryFindRegion.Active then
    begin
    cdsFindRegion.Close;
    qryFindRegion.Close;
    end;
  result := true;
end;

{
procedure TEngine.SetCallbook();
begin
  if GetCallbook(Qso.Callsign) then
    begin
    Qso.Name        := Callbook.Name;
    Qso.Comment     := Callbook.Comment;
    if Qso.Callsign = Qso.OrgCallsign then
      begin
      Qso.Entity  := Callbook.Entity;
      Qso.Country := Callbook.Country;
      Qso.Region  := Callbook.Region;
      end;
    end;
end;
}

//function TEngine.UpdateCallbook():boolean;
//begin
//  Result := false;
//  if Trim(PCallbook.Callsign) = '' then
//    Exit;
//  if (PCallbook.Name = '') and (PCallbook.Entity = '')
//  and (PCallbook.Region = '') and (PCallbook.Comment = '') then
//    Exit;
//
//  if GetCallbook(PCallbook.Callsign) then
//    begin
//    if PCallbook.Name <> '' then
////      FCallbook.Name      := Callbook.Name;
////    if Callbook.Entity <> '' then
////      FCallbook.Entity    := Callbook.Entity;
////    if Callbook.Region <> '' then
//      begin
////      FCallbook.Country   := Callbook.Country;
////      FCallbook.Region    := Callbook.Region;
//      end;
////    if Callbook.Comment <> '' then
////      if FCallbook.Comment = '' then
////        FCallbook.Comment := Callbook.Comment
////      else
////        FCallbook.Comment := Callbook.Comment + ' ' + Callbook.Comment;
//    end
//  else
//    begin
////    Callbook.Name      := Callbook.Name;
////    Callbook.Entity    := Callbook.Entity;
////    Callbook.Country   := Callbook.Country;
////    Callbook.Region    := Callbook.Region;
////    Callbook.Comment   := Callbook.Comment
//    end;
//  PutCallbook();
//  Result := true;
//end;

//procedure TEngine.PutCallbook();
//begin
//{
//  try
//    with tblCallbook do
//      begin
////      if Locate('Callsign', Callbook.Callsign, []) then
//        begin
//        Edit;
////        FieldByName('Name').AsString     := Callbook.Name;
////        FieldByName('Entity').AsString   := Callbook.Entity;
////        FieldByName('Country').AsString  := Callbook.Country;
////        FieldByName('Region').AsString   := Callbook.Region;
////        FieldByName('Comment').AsString  := Callbook.Comment;
////        Post;
//        end
////      else
////        begin
////        Insert;
////        FieldByName('Callsign').AsString := Callbook.Callsign;
////        FieldByName('Name').AsString     := Callbook.Name;
//        FieldByName('Entity').AsString   := Callbook.Entity;
//        FieldByName('Country').AsString  := Callbook.Country;
//        FieldByName('Region').AsString   := Callbook.Region;
//        FieldByName('Comment').AsString  := Callbook.Comment;
//        Post;
//        end;
//      end;
//  except
//    MessageDlg('PutCallbook ERROR ',mtInformation	, [mbYes],0);
//  end;
//}
//end;

function TEngine.OpenFindRegion(aCountry: string): boolean;
var
  sSql: string;
//  fCountry: string;
begin
  result  :=  false;
  if aCountry = '' then
    exit;
  try
    if aCountry <> pFindRegionCountry then
      begin
      if qryFindRegion.Active then
        begin
        cdsFindRegion.Close;
        qryFindRegion.Close;
        end;
      sSql := 'SELECT a.COUNTRY, a.REGION, a.NAME,' +
                     'a.AREA as AREA, a.RANK as RANK, ' +
                     'a.PHONETIC, a.LATITUDE, a.LONGITUDE, ' +
                     'a.FMDATE, a.TODATE ' +
              'FROM REGION_v a ' +
              'WHERE a.COUNTRY=''' + aCountry + ''' ' +
              'ORDER BY a.RANK, a.REGION';
      qryFindRegion.SQL.Clear;
      qryFindRegion.SQL.Add(sSql);
      qryFindRegion.Open;
      cdsFindRegion.Open;
//      cdsFindRegion.Filtered   :=  false;
//      cdsFindRegion.Filter     :=  '';
      pFindRegionCountry  := aCountry;
      end;
    cdsFindRegion.Last;
    if cdsFindRegion.RecordCount <> 0 then
      result := true;
  except
  end;
end;

procedure TEngine.SettblQsoDateTimeField(FieldName: string; Value: TDateTime);
var
  fd: TField;
  AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
begin
  fd := cdsQso.FieldByName(FieldName);
  Inc(bAutoInput[fd.Index]);
  if not bManualInput[fd.Index] then
    begin
    DecodeDateTime(Value, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
    fd.Value  := EncodeDateTime(AYear, AMonth, ADay, AHour, AMinute, 0, 0);
    end;
  Dec(bAutoInput[fd.Index]);
end;

procedure TEngine.SettblQsoInt64Field(FieldName: string; Value: Int64);
var
  fd: TField;
begin
  fd := cdsQso.FieldByName(FieldName);
  Inc(bAutoInput[fd.Index]);
  if fd.AsInteger = 0 then
    bManualInput[fd.Index] := false;
  if not bManualInput[fd.Index] then
    fd.Value  := value;
  Dec(bAutoInput[fd.Index]);
end;

//procedure TEngine.SettblQsoSmallIntField(FieldName: string; Value: smallInt);
//var
//  fd: TField;
//begin
//  fd := cdsQso.FieldByName(FieldName);
//  Inc(bAutoInput[fd.Index]);
//  if not bManualInput[fd.Index] then
//    fd.Value  := value;
//  Dec(bAutoInput[fd.Index]);
//end;

procedure TEngine.SettblQsoStringField(FieldName, Value: string);
var
  fd: TField;
begin
  fd := cdsQso.FieldByName(FieldName);
  Inc(bAutoInput[fd.Index]);
  if fd.AsString = '' then
    bManualInput[fd.Index] := false;
  if not bManualInput[fd.Index] then
    fd.Value  := value;
  Dec(bAutoInput[fd.Index]);
end;

///////////////////////////////////////////////////////////////////////////////
///
///    Transceiver関係
///
///////////////////////////////////////////////////////////////////////////////
function TEngine.TrcvOpen(TrcvNo: string): boolean;
var
  XmlIni: TXmlIniFile;
begin
  result := true;
  XmlIni  := TXmlIniFile.Create(FXmlIniFileName);
  if Trcv = nil then
    Trcv := TTransceiver.Create(self);
  try
    if Trcv.Active then
      Trcv.Close;
    if not XmlIni.OpenNode('/Transceiver/Transceiver' + TrcvNo, false) then
      exit;
    Trcv.OnGetInfo    :=  TrcvRecvInfo;
    Trcv.Command  := XmlIni.ReadString('Command', '');
    Trcv.Port     := XmlIni.ReadString('Port', 'COM1');
    Trcv.BaudRate := XmlIni.ReadString('BaudRate', '4800');
    Trcv.Databit  := XmlIni.ReadString('DataBit', '8');
    Trcv.StopBit  := XmlIni.ReadString('StopBit', '2');
    Trcv.Parity   := XmlIni.ReadString('Parity', 'None');
    Trcv.FlowControl  := XmlIni.ReadString('FlowControl', 'Disable');
    Trcv.Delimite := XmlIni.ReadString('Delimiter', '');
    Trcv.RigNo    :=  StrToInt('0' + TrcvNo);
    Trcv.Open;
    FTrcvActive := True;
  finally
    freeAndNil(XmlIni);
  end;
end;

procedure TEngine.TrcvClose();
begin
  if Trcv <> nil then
    if Trcv.Active then
      begin
      Trcv.Close;
      FTrcvActive := false;
      end;
end;

//procedure TEngine.TrcvClear();
//begin
//  if Trcv.Active then
//    Trcv.ClearBuffer;
//end;

procedure TEngine.TrcvGetInfo();
begin
  try
    if Trcv.Active then
      Trcv.GetFreqMode;
  except
// CportのLine=1805でエラーになることがある
// PortのOpenのタイミングか？　2015/4/1
    ShowMessage('Trcvからデータを読み取れない。対処方法検討中');
  end;
end;

procedure TEngine.TrcvSetPtt(Ptt: TTrcvPtt);
begin
  if Trcv.Active then
    Trcv.Tranmit(Ptt);
end;

procedure TEngine.TrcvRecvInfo(Sender: TObject; Information: TInformation);
var
  fmt: string;
  freq: Int64;
begin
  if Information.isValid then
    begin
    if (FQsoState = lgTramp) or (FQsoState = lgInsert) or (FQsoState = lgClear) then
      begin
      fmt := SupportQso.FreqFormat;
      if fmt = '' then
        fmt := SupportQso.DefaultFreqFormat;
      Freq  :=  Trunc(StrToFloat('0' + FormatFloat(fmt, Information.SendFreq / kMhz)) * kMhz);
      SetTblQsoInt64Field('Freq', Freq);
      Freq  :=  Trunc(StrToFloat('0' + FormatFloat(fmt, Information.RecvFreq / kMhz)) * kMhz);
//      Freq  :=  StrToFloat('0' + FormatFloat(fmt, Information.RecvFreq)) / kMhz * kMhz;
//      Freq  :=  Trunc(Freq);
      SetTblQsoInt64Field('RecvFreq', Freq);
      SetTblQsoStringField('Mode', Information.Mode);
      end
    end
  else
    Trcv.Close;
end;

function TEngine.Prepare: boolean;
//var
//  wMyData: TMyDataRec;
begin
//  wMyData.MyCallsign  := '';
//  SetMyDataRec(wMyData);
  SetQsoState(lgClear);
  result := true;
end;

///////////////////////////////////////////////////////////////////////////////
///
///    Journal関係
///
///////////////////////////////////////////////////////////////////////////////

function TEngine.PrepareJournal(DataSet: TDataSet):boolean;
var
  i: integer;
  sl: TStringList;
begin
  result := true;
  sl := TStringList.Create;
  try
    try
      AssignFile(Journal, FJournalName, 65001);    // UTF-8
      if not SysUtils.DirectoryExists(FJournalPath, true) then
        MkDir(FJournalPath);
      if Not FileExists(FJournalName) then
        begin
        Rewrite(Journal);
        Append(Journal);
        with DataSet do
          begin
          sl.Add('Command');
          for i := 0 to FieldCount - 1 do
            if Fields.Fields[i].FieldKind = fkData then
              sl.Add(Fields.Fields[i].FieldName);
          writeln(Journal, sl.CommaText);
          end;
        CloseFile(Journal);
        end;
    except
      MessageDlg('Journal Prepare---- ERROR ',mtInformation	, [mbYes],0);
    end;
  finally
    FreeAndNil(sl);
  end;
end;

procedure TEngine.OutputJournal(UpDate: string; DataSet: TDataSet);
var
  i: integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    try
      sl.Clear;
      AssignFile(Journal, FJournalName, 65001);    // UTF-8
      Append(Journal);
      with DataSet do
        begin
        sl.Add(Update);
        for i := 0 to FieldCount - 1 do
          if Fields.Fields[i].FieldKind = fkData then
            sl.Add(Fields.Fields[i].Value);
        writeln(Journal, sl.CommaText);
        end;
      CloseFile(Journal);
    except
      MessageDlg('Journal output Error ',mtError, [mbOK],0);
    end;
  finally
    FreeAndNil(sl);
  end;
end;

function TEngine.SettleJournal():boolean;      // Settleは後始末
var
  i,j: integer;
  s: string;
  Generation: integer;
  DirectryList: TstringList;
  RegStr: string;
  ErrCd : integer;
  SearchRec : TSearchRec;
  XmlIni: TXmlIniFile;
  Brx:          TSkRegExp;
begin
  result := true;
  DirectryList  := TStringlist.Create();
  XmlIni        := TXmlIniFile.Create(FXmlIniFileName);
  Brx           := TSkRegExp.Create;
  try
    try
      XmlIni.OpenNode('/System', true);
      Generation := XmlIni.ReadInteger('JournalGeneration', 3);
      RegStr := '(([2-9][0-9][0-9]{2})(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01]).TXT)$';
      Brx.Expression := RegStr;
// ファイルの検索,
      ErrCd := FindFirst(FJournalpath + '*.*', 0, SearchRec);  // 指定された一連の属性を持つ最初のファイルを、指定されたディレクトリ内で探します
      while ErrCd = 0 do  // ファイルがある間
        begin
        if Brx.Exec(SearchRec.Name) then  // ファイル名が一致しているかどうか？
          if Searchrec.Size = 0 then      // ファイルsize=0なら削除
            DeleteFile(FJournalpath + SearchRec.Name)
          else
            DirectryList.Add(FJournalpath + SearchRec.Name);
        ErrCd := FindNext(SearchRec);
        end;
      FindClose(SearchRec);  // FindFirsで確保したMemoryを開放する
// 世代数を越えるファイルの削除
      DirectryList.Sort;
      j := DirectryList.Count - Generation - 1;
      if j >= 0  then
        for i := j downto 0 do
          begin
          s := DirectryList[i]  ;
          DeleteFile(s);
          end;
    except
      s := 'Journalの整理が失敗しました。' + #13#10
         + '原因を取り除いてください' ;
      MessageDlg(s, mtInformation, [mbOk], 0);
      result := false;
    end;
  finally
    FreeAndNil(DirectryList);
    FreeAndNil(XmlIni);
    FreeAndNil(Brx);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
///
///    DBのBackup/Restoreをする
///
///////////////////////////////////////////////////////////////////////////////
function TEngine.RestoreDB():boolean;
const
  SELDIRHELP = 1000;
var
  s: string;
  XmlIni: TXmlIniFile;
  RestorePath: string;
  RestoreDbName: string;
  RenameDbName: string;
  DbTimeStamp1, DbTimeStamp2: TdateTime;
begin
  result  := false;
  XmlIni := TXmlIniFile.Create(FXmlIniFileName);
  try
    try
      XmlIni.OpenNode('/System', true);
      RestorePath    := XmlIni.ReadString('RestorePath', '');
      if GetOpenFileName(self, 'RestoreのFileを選択', RestorePath, 'LogBase Backup files (*.FDB)|*.FDB', RestoreDbName) then
        begin
        XmlIni.WriteString('RestorePath', ExtractFileDir(RestoreDbName));
        XmlIni.CloseNode;
        XmlIni.UpdateFile;

        DbTimeStamp1 :=  StrToDateTime('2900/1/1 12:00');
        FileAge(FDataBaseName, DbTimeStamp1, true);    // 失敗時に戻す時の判断のために保存
        RenameDbName  := ChangeFileExt(FDataBaseName, '.$$$');
        if FileExists(RenameDbName) then
          DeleteFile(RenameDbName);
        ReNameFile(FDataBaseName, RenameDbName);
        result := CopyDB(RestoreDbName, FDatabaseName);  // DBをCopyする
        DeleteFile(RenameDbName);
        if not result then
          raise EValueWarningError.Create('');
        end;
    except
      DbTimeStamp2 :=  StrToDateTime('1900/1/1 12:00');
      FileAge(FDataBaseName, DbTimeStamp2, true);
      if FileExists(FDataBaseName) and (DbTimeStamp1 = DbTimeStamp2) then // なにも変化がない
        begin
        end
      else
        begin
        FileAge(RenameDbName, DbTimeStamp2, true);
        if FileExists(RenameDbName) and (DbTimeStamp1 = DbTimeStamp2) then
          begin
          if FileExists(FDataBaseName) then
            DeleteFile(FDataBaseName);
          ReNameFile(RenameDbName, FDataBaseName);
          end
        end;
      s := 'Logのリストアが失敗しました。' + #13#10
         + '原因を取り除いてください' ;
      MessageDlg(s, mtInformation, [mbOk], 0);
    end;
  finally
    FreeAndNil(XmlIni);
  end;
end;

function TEngine.BackupDB():boolean;
const
  SELDIRHELP = 1000;
var
  s: string;
  XmlIni: TXmlIniFile;
  BackupPath: string;
  BakupDbName: string;
begin
  Engine.DataBaseClose;
  result  := false;
  XmlIni := TXmlIniFile.Create(FXmlIniFileName);
  try
    XmlIni.OpenNode('/System', true);
    BackupPath    := XmlIni.ReadString('BackupPath', '');
    if GetOpenFileName(self, 'BackUpのFileを選択', BackupPath, 'LogBase Backup files (*.FDB)|*.FDB', BakupDbName) then
//    if GetDirectryName(self, 'BackupのDirectryを選択', BackupPath) then
      begin
//      BakupDbName := BackupPath + '\' + FDataBase;
      XmlIni.WriteString('BackupPath', BackupPath);
      XmlIni.CloseNode;
      XmlIni.UpdateFile;
      result := CopyDB(FDatabaseName, BakupDbName);
      if not result then
        begin
        s := 'Logのバックアップが失敗しました。' + #13#10
           + '原因を取り除いてください' ;
        MessageDlg(s, mtInformation, [mbOk], 0);
        end;
      end;
  finally
    Engine.DataBaseOpen;
    FreeAndNil(XmlIni);
  end;
end;

function TEngine.AutoBackupDB():boolean;
var
  b: boolean;
  BackupPath: string;
  DbTimeStamp: TDatetime;
  IniTimeStamp: TDateTime;
  XmlIni: TXmlIniFile;
begin
  result  :=  true;
  if not FDbChanged then     //  DataBeseの変更が無い場合はBackupしない
    exit;
  result  :=  true;
  XmlIni :=  TXmlIniFile.Create(FXmlIniFileName);
  try
    XmlIni.OpenNode('/System', true);
    if not XmlIni.ReadBool('AutoBackup', false) then  //  AutoBackupの判断
      exit;
//  FileStampが同じなら終了する
//  OpenするたびにTimeStampが変わるので実行されない
    if FileExists(FDataBaseName) then
      begin
      b := FileAge(FDataBaseName, DbTimeStamp, true);
      IniTimeStamp := XmlIni.ReadDateTime('DBTimeStamp', 0);
      if b And (DateTimeToStr(DbTimeStamp) = DateTimeToStr(IniTimeStamp)) then   // 実際にはきいていない
        exit;
      end;
//  Baukup1処理 Directryが存在しない場合、Directryを作成する
    BackupPath    := XmlIni.ReadString('AutoBackupPath1', '');
    if BackupPath = '' then
      begin
      BackupPath := FMyDocPath + 'LogBase';
      if not SysUtils.DirectoryExists(BackupPath, true) then
        begin
        MkDir(BackupPath);
        XmlIni.WriteString('AutoBackupPath1', BackupPath);
        end;
      end;
    result :=  BackupDirExist(BackupPath);
    if result then
      result := AutoBackupDB1(BackupPath);    // Backupする
    if not result then
      exit;
    XmlIni.WriteDateTime('DBTimeStamp', DbTimeStamp);   //  Baukup1が成功したら、FileStampを保存
//  Baukup2処理  Directryが存在しない場合、BackUpしない
    BackupPath    := XmlIni.ReadString('AutoBackupPath2', '');
    if BackupPath = '' then
      exit;
    result :=  BackupDirExist(BackupPath);
    if result  then
      result := AutoBackupDB1(BackupPath);
  finally
    FDbChanged      := False;   // Createでもリセットする
    XmlIni.CloseNode;
    XmlIni.UpdateFile;
    FreeAndNil(XmlIni);
  end;
end;

function TEngine.BackupDirExist(BackupPath: string):boolean;
var
  s:  string;
begin
  result  :=  true;
  if not SysUtils.DirectoryExists(BackupPath, true) then
    begin
    s := '自動バックアップ先のディレクトリが見つかりません。' + #13#10
       + 'Directry="' + BackupPath + '"' + #13#10
       + '原因を取り除いてください' ;
    ShowMessage(s);
    result  :=  false;
    end;
end;

function TEngine.AutoBackupDB1(BackupPath: string):boolean;
var
  i,j: integer;
  s: string;
  BackupGen: integer;
  BakupDbName: string;
  RenameDbName: string;
  FileList: TstringList;
  RegStr: string;
  XmlIni: TXmlIniFile;
  ErrCd: integer;
  SearchRec : TSearchRec;
begin
  FileList := TStringlist.Create();
  XmlIni   := TXmlIniFile.Create(FXmlIniFileName);
  try
    s := FormatDateTime('yyyymmdd',Date);
    BakupDbName   := BackupPath + '\' + s + '_' + ExtractFileName(FDataBaseName);
    RenameDbName  := ChangeFileExt(BakupDbName, '.$$$');
// Bakup先のFileがあるときは、一時的に名前変更をし
    if FileExists(RenameDbName, true) then
      DeleteFile(RenameDbName);
    if FileExists(BakupDbName) then
      ReNameFile(BakupDbName, RenameDbName);
// Bakupする
    result := CopyDB(FDatabaseName, BakupDbName);
    if not result then
      begin
      s := 'Logのバックアップが失敗しました。' + #13#10
         + '原因を取り除いてください' ;
      MessageDlg(s, mtInformation, [mbOk], 0);
      end;

// 一次的Fileを削除
    if FileExists(RenameDbName) then
      DeleteFile(RenameDbName);

// 保存世代以前のFileを削除する
    XmlIni.OpenNode('/System', true);
    BackupGen := XmlIni.ReadInteger('BackupGeneration', 6);
    if Copy(BackupPath,length(BackupPath),1) <> '\' then   // 左端が\でないとき、\を追加
      BackupPath := BackupPath + '\';

    RegStr := '(([2-9][0-9][0-9]{2})(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01]))'
            + '_' + FDataBase + '$';
    RegStr := StringReplace(RegStr, '.', '\.', [RFrEPLACEaLL]);
            //  ファイルの検索,size=0なら削除
    ErrCd := FindFirst(BackupPath + '*.*', 0, SearchRec);
    while ErrCd = 0 do
      begin
      s :=  SearchRec.Name;
      if RegIsMatch(RegStr, S) then
        if Searchrec.Size = 0 then
          DeleteFile(BackupPath + SearchRec.Name)
        else
          FileList.Add(BackupPath + SearchRec.Name);
        ErrCd := FindNext(SearchRec);
      end;
    FindClose(SearchRec);
//  世代数を越えるファイルの削除
    FIleList.Sort;
    j := FileList.Count - BackupGen - 1;
    if j >= 0  then
      for i := j downto 0 do
        begin
        s := FileList[i]  ;
        DeleteFile(s);
        end;
  finally
    FreeAndNil(FileList);
    FreeAndNil(XmlIni);
  end;
end;

function TEngine.CopyDB(Source, Destination: string):boolean;
var
  hDesktop: HWND;
  NFrom: string;
  NTo: string;
begin
  hDeskTop  := FindWindow('Progman', 'Program Manager');

//  hDeskTop  := LogBaseApp.Panel1.Handle;
//  hDeskTop  := Application.Handle;
  NFrom     := Source;
  NTo       := Destination;
  result := SHCopyFile(hDesktop, NFrom, NTo);
end;

//function TEngine.CopyFile(Source, Destination: string):boolean;
//var
//  hDesktop: HWND;
//  NFrom: string;
//  NTo: string;
//begin
//  hDeskTop  := FindWindow('Progman', 'Program Manager');
//  NFrom     := Source;
//  NTo       := Destination;
//  result    := SHCopyFile(hDesktop, NFrom, NTo);
//end;
////////////////////////////////////////////////////////////////////////////////
//
//     LogをOnDateTime,Num順に並べ替える
//
////////////////////////////////////////////////////////////////////////////////
procedure TEngine.SortQsoLog();
var
  s: string;
  i,j: integer;
  wNum: Integer;
//  FN:   string;             // FieldName;
//  cdsTemp: TClientDataSet;
//  dspTemp: TDataSetProvider;
  ProgDlg: TProgressDlg;
  wRec: TStringList;
  wFile: TStringList;
  CmdLine: string;
//  ProcHandle: THandle;
begin
  wRec  :=  TStringList.Create;
  wFile :=  TStringlist.Create;
  ProgDlg := TProgressDlg.Create(self);
  try
    s := '並べ替えの前に、ログデータのバックアップしてください。'#13
       + 'このまま続けますか？';
    if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
      exit;
    Screen.Cursor := crHourGlass;

    SimplifycdsQsoLog;
    cdsQsoLog.ApplyUpdates(-1);
//    trnLogBase.Commit;
//    trnLogBase.StartTransaction;
    cdsQsoLog.DisableControls;      // 処理速度を上げるため
    SimplifycdsQsoLogSel;
    cdsQsoLogSel.DisableControls;   // 処理速度を上げるため
    cdsQsoLog.IndexFieldNames := 'OnDateTime;Num';  //  日付・Num順に並べる

    with ProgDlg do
      begin
      Title    := 'ログデータの並べ替え中です';
      Caption1 := 'データの読み込み中です。';
      Max := cdsQsoLog.RecordCount;
      Show;
      end;

    cdsQsoLog.First;                // これがないと、第1レコードからコピーされない
    try
      wNum    := 0;
      wFile.Clear;
      cdsQsoLog.First;
      While not cdsQsoLog.Eof do
        begin
        wRec.Clear;
        Inc(wNum);
        wRec.Add(IntToStr(wNum));
        for i := 1 to cdsQsoLog.FieldCount - 1 do
          begin
          wRec.Add(cdsQsoLog.Fields[i].Value);
          end;
        wFile.Add(wRec.CommaText);
        cdsQsoLog.Next;
        ProgDlg.StepIt;
        end;

      ProgDlg.Caption1 := 'データの書き込み中です。';
      ProgDlg.Clear;
//      tblQsoLog.EmptyTable;
//      tblQsoLog.;
      for i := 0 to wFile.Count - 1 do
        begin
        wRec.CommaText  :=  WFile.Strings[i];
        tblQsoLog.Append;
        for j := 0 to wRec.Count - 1 do
          begin
          if wRec.Strings[j] <> ''  then
             tblQsoLog.Fields[j].Value := wRec.Strings[j];
          end;
        tblQsoLog.Post;
        ProgDlg.StepIt;
        end;
      ProgDlg.Caption1 := 'ガベージコレクッション中です。';
      trnLogBase.Commit;
      ModifycdsQsoLog;
      cdsQsoLog.EnableControls;      // 処理速度を上げるため
      ModifycdsQsoLogSel;
      cdsQsoLogSel.EnableControls;   // 処理速度を上げるため
      Application.ProcessMessages;
      Screen.Cursor := crDefault;

      DataBaseClose;

      // ガベージコレクッション
      CmdLine := format('gbak -b -user sysdba -password masterkey "%s" LogBase.bak', [FDataBaseName]);
      WinExecAndWait32(CmdLine,   SW_HIDE);
        begin
        DeleteFile(FDataBaseName);
          begin
          CmdLine := format('gbak -r -user sysdba -password masterkey LogBase.bak "%s"', [FDataBaseName]);
          WinExecAndWait32(CmdLine, SW_HIDE) ;
          end;
        end;

      DataBaseOpen;
      ProgDlg.Close;
      s := format('ログデータの並べ替えが完了しました。'#13'レコード件数=%d', [wNum]);
      MessageDlg(s, mtInformation, [mbOk], 0);
    except
      trnLogBase.RollbackRetaining;
      s := 'ログデータの並べ替えが失敗しました。';
      MessageDlg(s, mtInformation, [mbOk], 0);
    end;
  finally
    cdsQsoLog.IndexFieldNames := 'Num';  //  Num順に戻す
    FreeAndNil(wRec);
    FreeAndNil(wFile);
    FreeAndNil(ProgDlg);
    RenewList;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//     Lotw用データ出力
//
////////////////////////////////////////////////////////////////////////////////
function TEngine.UpdateLotw(Update: string): boolean;
var
  s: string;
  wBand_M, wRecvBand_M: string;
  Loc: string;
  sl: TStringList;
begin
// 移動してネットがないときは？
  result := true;
  sl  := TstringList.Create;
  try
    if not FOptionsData.LoTw then
      exit;

    if (not tmrLotw.Enabled) and (FOptionsData.LotwIntervalMin > 0) then
      begin
      tmrLotw.Interval  :=  FOptionsData.LotwIntervalMin * 60 * 1000;  // Interval=0は、OnTimer イベントを呼び出しません
      tmrLotw.Enabled   :=  true;
      end;

    if (UpDate = 'U') or (Update = 'D') then
      begin
      qryLoTW.Close;
      qryLoTW.SQL.Clear;
      s := 'SELECT NUM FROM LOTW WHERE NUM = ' + IntToStr(cdsQsoNum.AsInteger) + ';';
      qryLotw.SQL.Add(s);
      qryLotw.Open;
      if QryLotw.Eof then
        exit;
      qryLoTW.Close;
      qryLoTW.SQL.Clear;
      s := 'DELETE FROM LOTW WHERE NUM = ' + IntToStr(cdsQsoNum.AsInteger) + ';';
      qryLotw.SQL.Add(s);
      qryLotw.ExecSQL;
      end;

    if (UpDate = 'I') or (Update = 'U') then
      begin
      sl.NameValueSeparator := ':';  // Locationの抽出
      sl.Text := cdsQsoMyMemo.AsString;
      Loc := sl.Values['Loc'];

      wBand_M     := pBandList_BM.Values[IntToStr(cdsQsoBand.AsInteger)];
      wRecvBand_M := pBandList_BM.Values[IntToStr(cdsQsoRecvBand.AsInteger)];

      qryLoTW.Close;
      qryLoTW.SQL.Clear;
      qryLotw.SQL.Add('INSERT INTO LOTW(Num,Callsign,onDateTime,Freq,Band,Band_M, ');
      qryLotw.SQL.Add('RecvFreq,RecvBand,RecvBand_M,Mode,Route,Repeater, ');
      qryLotw.SQL.Add('HisReport,MyReport,Memo,MyCallsign,MyLocation) ');
      qryLotw.SQL.Add('VALUES( ');
      s := '%d,''%s'',''%s'', ';
      s := format(s, [cdsQsoNum.AsInteger, cdsQsoCallsign.AsString, formatDateTime('yyyy/mm/dd hh:nn', cdsQsoOnDateTime.AsDateTime)]);
      qryLotw.SQL.Add(s);

      s := '%d,%d,''%s'',%d,%d,''%s'', ';
      s := format(s, [cdsQsoFreq.AsInteger, cdsQsoBand.AsInteger, wBand_M,
           cdsQsoRecvFreq.AsInteger, cdsQsoRecvBand.AsInteger, wRecvBand_M]);
      qryLotw.SQL.Add(s);

      s := '''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',''%s'');';
      s := format(s, [cdsQsoMode.AsString, cdsQsoRoute.AsString, cdsQsoRepeater.AsString,
           cdsQsoHisReport.AsString, cdsQsoMyReport.AsString, cdsQsoMemo.AsString,
           cdsQsoMyCallsign.AsString, Loc]);
      qryLotw.SQL.Add(s);
      qryLotw.ExecSQL;
      end;
  finally
    FreeAndNil(sl);
  end;
end;

function Tengine.GetTimeZoneBias(var Bias: Double): boolean;
var
  TimeZoneDlg: TTimeZoneDlg;
begin
  result  := false;
  Bias    := 0;
  TimeZoneDlg := TTimeZoneDlg.Create(Application);
  try
    TimeZoneDlg.LocalTimeZoneName  := FTimeZoneName;
    TimeZoneDlg.LocalTimeZoneBias  := FTimeZoneBiasH;
    if not (TimeZoneDlg.ShowModal = mrOk) then
      exit;
    Bias := TimeZoneDlg.Bias / 24;
    result := true;
  finally
    FreeAndNil(TimeZoneDlg);
  end;
end;

// EMEに対応せず
////////////////////////////////////////////////////////////////////////////////
//
//     ADIFファイルをアペンドする
//
////////////////////////////////////////////////////////////////////////////////
procedure TEngine.AppendADIF;
var
  s: string;
  Num: integer;
  InpRecCnt: integer;
  OutRecCnt: integer;
  InpExName: string;
  ErrExName: string;

  ErrMsg: string;
  ErrFile: TStringList;
  ProgDlg: TProgressDlg;
  XmlIni: TXmlIniFile;
  Adx: TAdx;
  BandList: TstringList;

  Title: string;
  FileName: string;
  DefaltFolder: string;
  Filter: string;
  Event: TDataSetNotifyEvent ;
begin
  ProgDlg     := TProgressDlg.Create(self);
  XmlIni      := TXmlIniFile.Create(FXmlIniFileName);
  Adx         := TAdx.Create;
  ErrFile      := TstringList.Create;
  BandList    := TstringList.Create;
  try
    s := 'ADIF/ADXのAppend前に、ログデータのバックアップしてください。'#13
       + 'このまま続けますか？';
    if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
      exit;

    XmlIni.OpenNode('File', true);
    FileName      := XmlIni.ReadString('ADIF', '');
    Title         := 'Append ADIF/ADF';
    DefaltFolder  := FMyDocPath;
    Filter        := 'ADIF/ADX files (*.adi)(*.adx)|*.adi;*adx';
    if GetOpenFileName(self, Title, DefaltFolder, Filter, FileName)  then
      begin
      XmlIni.WriteString('ADIF', FileName);
      XmlIni.CloseNode;
      XmlIni.UpdateFile;
      InpExName := FileName;
      if UpperCase(ExtractFileExt(InpExName)) = '.ADX' then
        Adx.LoadAdx(InpExName)
      else
        begin
        Adx.LoadAdif(InpExName);
        end;
      end;

    GetBandList('Band_M', 'Band', BandList);  // メータ表示Bandを周波数に変換するため
    Num := GetNewNumOfQsoLog;               //  最初のNumを得る
    InpRecCnt := 0;
//    OutRecCnt := 0;
    cdsQsoLog.DisableControls;
    Event  := cdsQsoLog.OnCalcFields;
    cdsQsoLog.OnCalcFields  := Nil;
    oUTrECcNT := 0;

    with ProgDlg do
      begin
      Title    := 'ADIF/ADXからインポート';
      Caption1 := '少しお待ちください。';
      Max := Adx.AdxRecords.Count;
      Show;
      end;

    if Adx.First(aeRecords) then
      Repeat
      ProgDlg.StepIt;
      cdsQsoLog.Append;
      Inc(InpRecCnt);
      if AppendADIF_Sub(Num, Adx, ErrMsg, BandList) then
        begin
        cdsQsoLog.POST;
        inc(OutRecCnt);
        Inc(Num);
        end
      else
        begin
        cdsQsoLog.Cancel;
        ErrFile.Add(format('Rec=%d %s', [InpRecCnt, ErrMsg]));
        end;
      Until not Adx.Next(aeRecords);
    cdsQsoLog.ApplyUpdates(1);
    trnLogBase.Commit;
    Application.ProcessMessages;
    ProgDlg.Close;
    DataBaseClose;
    DataBaseOpen;
    cdsQsoLog.Last;
    cdsQsoLog.OnCalcFields  := Event;

    s := format('ADIF/ADX Fileの%sが完了しました。' + #13#10
       + 'レコード件数=%d',  ['Append', OutRecCnt]);
    MessageDlg(s, mtInformation, [mbOk], 0);
    if ErrFile.Count <> 0 then
      begin
      ErrExName :=  ExtractFilePath(InpExName) + 'AppendErr.txt';
      ErrFile.SaveToFile(ErrExName);
      s := format('ADIF/ADX　FileのAppendにエラーがあります。' + #13#10
         + 'ファイル名=%s' + #13#10
         + 'レコード件数=%d', [ErrExName, ErrFile.Count]);
      MessageDlg(s, mtInformation, [mbOk], 0);
      end;
  finally
    cdsQsoLog.EnableControls;
    Screen.Cursor := crDefault;
    FreeAndNil(ProgDlg);
    FreeAndNil(XmlIni);
    FreeAndNil(Adx);
    FreeAndNil(ErrFile);
    FreeAndNil(BandList);
  end;
end;

function TEngine.AppendADIF_Sub(Num: Integer; Adx: TAdx; var ErrMsg: string; BandList: TstringList): boolean;
var
  f:double;
  s1,s2: string;
  aText: string;
  isErr: boolean;
  wEntityList: TstringList;
  wCallsignRec: TCallsignRec;
  wFreqRec: TFreqRec;
  wEntityRec: TEntityRec;
  wFreq: Integer;
  wNetLogRecv: string;
  wNetLogSend: string;
  Dt: TDateTime;
  function MakeNetLog(NetLog, Mark: string): string;
  begin
    if Mark <> '' then
      if NetLog = '' then
        NetLog := Mark
      else
        NetLog := NetLog + ',' + Mark;
    result := NetLog;
  end;
  procedure PutErrRec(Value: string);
  begin
    if ErrMsg = '' then
      ErrMsg := Value
    else
    result  := false;
  end;
begin
  result := true;
  wEntityList  :=  TstringList.Create;
  try
//  必須項目の設定
    isErr := false;
    cdsQsoLogNUM.AsInteger  := Num;
    if ADX.Find(aeRecord, 'CALL', aText) then
      begin
      cdsQsoLogCallsign.AsString  := aText;
      if CheckCallsign(aText, wCallsignRec) then
        begin
        cdsQsoLogOrgCallsign.AsString  := wCallsignRec.OrgCallsign;
        cdsQsoLogPREFIX.AsString    := wCallsignRec.Prefix;
        cdsQsoLogSUFFIX.AsString    := wCallsignRec.Suffix;
        end;
      end
    else
      PutErrRec('Callがみつからない');

    if  (ADX.Find(aeRecord, 'QSO_DATE', s1))
    and (ADX.Find(aeRecord, 'TIME_ON', s2)) then
      begin
      s1 := Copy(s1, 1, 4) + '/' + Copy(s1, 5, 2) + '/' + Copy(s1, 7, 2);
      s2 := Copy(s2, 1, 2) + ':' + Copy(s2, 3, 2);
      if TryStrToDateTime(s1 + ' ' + s2, Dt) then   // DTは後でも使う
        cdsQsoLogOnDateTime.AsDateTime  := DT
      else
        PutErrRec('QSO_DATEまたはTIME_ONが日付形式でない');
      end
    else
      PutErrRec('QSO_DATEまたはTIME_ONがみつからない');

    if ADX.Find(aeRecord, 'FREQ', aText) then     // MHzでは設定されて　　　いる
      begin
      f := StrToFloat(aText) * kMHz;
      cdsQsoLogFreq.AsInteger  := Trunc(f);
      if CheckFreq(cdsQsoLogFreq.AsInteger, wFreqRec) then
        cdsQsoLogBand.AsInteger := wFreqRec.Band
      else
        PutErrRec('Freqが範囲外である');
      end
    else
      if ADX.Find(aeRecord, 'BAND', aText) then      // メータ表示BandからHzに変換する
        begin
        wFreq := StrToInt(BandList.Values[aText]);
        cdsQsoLogFreq.AsInteger := wFreq;
        cdsQsoLogBand.AsInteger := wFreq;
        end
      else
        PutErrRec('Freq及びBandがみつからない');

    if ADX.Find(aeRecord, 'MODE', aText) then
      cdsQsoLogMode.AsString  := aText
    else
      PutErrRec('Modeがみつからない');

    if ADX.Find(aeRecord, 'RST_SENT', aText) then
      cdsQsoLogHisReport.AsString  := aText
    else
      PutErrRec('HisReportがみつからない');
    if ADX.Find(aeRecord, 'RST_RCVD', aText) then
      cdsQsoLogMyReport.AsString  := aText
    else
      PutErrRec('MyReportがみつからない');
    if IsErr then
      exit;

  //  任意項目の設定
    if ADX.Find(aeRecord, 'DXCC', aText) then
      if GetEntityByEntityCode(aText, wEntityRec) then
        begin
        cdsQsoLogEntity.AsString    := wEntityRec.Entity;
        cdsQsoLogCountry.AsString   := wEntityRec.Country;
        cdsQsoLogContinent.AsString := wEntityRec.Continent;
        cdsQsoLogITUZone.AsString   := wEntityRec.ITUZone;
        cdsQsoLogCQZone.AsString    := wEntityRec.CQZone;
        end;
    if cdsQsoLogEntity.AsString = '' then
      begin
      GetEntityList(wCallsignRec.Prefix, Copy(wCallsignRec.Suffix, 1, 1), dt, wEntityList);
      if wEntityList.Count >= 1 then
        begin
        cdsQsoLogEntity.AsString    := wEntityList.Names[0];
        if CheckEntity(aText, wEntityRec) then
          begin
          cdsQsoLogCountry.AsString   := wEntityRec.Country;
          cdsQsoLogContinent.AsString := wEntityRec.Continent;
          cdsQsoLogITUZone.AsString   := wEntityRec.ITUZone;
          cdsQsoLogCQZone.AsString    := wEntityRec.CQZone;
          end
        end
      end;

    if ADX.Find(aeRecord, 'STATE', aText) then
      cdsQsoLogRegion.AsString  := aText;
    if ADX.Find(aeRecord, 'CNTY', aText) then
      if Length(cdsQsoLogRegion.AsString) < Length(aText) then
        cdsQsoLogRegion.AsString  := aText;

    if ADX.Find(aeRecord, 'FREQ_RX', aText) then
      begin
      f  := StrToFloat(aText) * kMHz;
      cdsQsoLogRecvFreq.AsInteger  := Trunc(f);
      if CheckFreq(tblQsoLog.FieldByName('RecvFreq').AsInteger, wFreqRec) then
        cdsQsoLogRecvBand.AsInteger := wFreqRec.Band;
      end
    else
      if ADX.Find(aeRecord, 'Band_RX', aText) then
        begin
        wFreq := StrToInt(BandList.Values[aText]);
        cdsQsoLogRecvFreq.AsInteger := wFreq;
        cdsQsoLogRecvBand.AsInteger := wFreq;
        end;
    if ADX.Find(aeRecord, 'COMMENT', s1) or ADX.Find(aeRecord, 'NOTES', s2) then
      cdsQsoLogMemo.AsString  := Trim(s1 + ' ' + s2);
    if ADX.Find(aeRecord, 'CONT', aText) then
      cdsQsoLogCONTINENT.AsString  := aText;
    if ADX.Find(aeRecord, 'CQZ', aText) then
      cdsQsoLogCqZone.AsString  := aText;
    if ADX.Find(aeRecord, 'ITUZ', aText) then
      cdsQsoLogItuZone.AsString  := aText;
    if ADX.Find(aeRecord, 'GridSquare', aText) then
      cdsQsoLogGridLoc.AsString  := aText;
    if ADX.Find(aeRecord, 'IOTA', aText) then
      cdsQsoLogIOTA.AsString  := aText;
    if ADX.Find(aeRecord, 'NAME', aText) then
      cdsQsoLogName.AsString  := aText;
    if ADX.Find(aeRecord, 'QSLRDATE', s1) then
      begin
      s1 := Copy(s1, 1, 4) + '/' + Copy(s1, 5, 2) + '/' + Copy(s1, 7, 2);
      if TryStrToDate(s1, Dt) then
        cdsQsoLogQslRecvDate.AsDateTime  := DT;
      end;
    if ADX.Find(aeRecord, 'QSLSDATE', s1) then
      begin
      s1 := Copy(s1, 1, 4) + '/' + Copy(s1, 5, 2) + '/' + Copy(s1, 7, 2);
      if TryStrToDate(s1, Dt) then
        cdsQsoLogQslSendDate.AsDateTime  := DT;
      end;

    if ADX.Find(aeRecord, 'QSL_RCVD', aText) then
      cdsQsoLOgQslRecv.AsString  := aText;
    if ADX.Find(aeRecord, 'QSL_SENT', aText) then
      cdsQsoLogQslSend.AsString  := aText;
    if tblQsoLog.FieldByName('QSLSend').AsString = 'Y'   then
      cdsQsoLogQSLSend.AsString := 'FQslSendDefault';
    if tblQsoLog.FieldByName('QSLRecv').AsString = 'Y'  then
      cdsQsoLogQSLRecv.AsString := 'FQslRecvDefault';
    if ADX.Find(aeRecord, 'QSL_RCVD_VIA', aText) then
      cdsQsoLogQslManager.AsString  := aText;

    wNetLogRecv := '';
    wNetLogSend := '';
    if ADX.Find(aeRecord, 'CLUBLOG_QSO_UPLOAD_STATUS', aText) then
      if (aText = 'M') or (aText = 'Y') then
        wNetLogSend := MakeNetLog(wNetLogSend, 'C');
    if ADX.Find(aeRecord, 'EQSL_QSL_RCVD', aText) then
      if (aText = 'M') or (aText = 'Y') then
        wNetLogRecv := MakeNetLog(wNetLogRecv, 'E');
    if ADX.Find(aeRecord, 'EQSL_QSL_SENT', aText) then
      if (aText = 'M') or (aText = 'Y') then
        wNetLogSend := MakeNetLog(wNetLogSend, 'E');
    if ADX.Find(aeRecord, 'HRDLOG_QSO_UPLOAD_STATUS', aText) then
      if (aText = 'M') or (aText = 'Y') then
        wNetLogSend := MakeNetLog(wNetLogSend, 'H');
    if ADX.Find(aeRecord, 'LOTW_QSL_RCVD', aText) then
      if (aText = 'M') or (aText = 'Y') then
        wNetLogRecv := MakeNetLog(wNetLogRecv, 'L');
    if ADX.Find(aeRecord, 'LOTW_QSL_SENT', aText) then
      if (aText = 'M') or (aText = 'Y') then
        wNetLogSend := MakeNetLog(wNetLogSend, 'L');
    if ADX.Find(aeRecord, 'QRZCOM_QSO_UPLOAD_STATUS', aText) then
      if (aText = 'M') or (aText = 'Y') then
        wNetLogSend := MakeNetLog(wNetLogSend, 'Q');
    cdsQsoLogNetLogRecv.AsString := wNetLogRecv;
    cdsQsoLogNetLogSend.AsString := wNetLogSend;

    if ADX.Find(aeRecord, 'SAT_NAME', aText) then
      if aText <> '' then
        begin
        cdsQsoLogREPEATER.AsString  := aText;
        cdsQsoLogRoute.AsString     := 'SATELLITE';
        end;

    if ADX.Find(aeRecord, 'SWL', aText) then
      if aText = 'Y' then
        begin
        cdsQsoLogSwl.AsInteger  := kTrue;
        end;

  finally
    FreeAndNil(wEntityList);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//     Cabrilloファイルをアペンドする
//
////////////////////////////////////////////////////////////////////////////////
procedure TEngine.AppendCabrillo();
var
  s: string;
  i: integer;
  InpExName: string;
  ErrExName: string;
  InpFile: TstringList;
  ErrFile: TStringList;
  InpRec: String;
  ErrMsg: string;
  InpRecCnt: integer;
  OutRecCnt: integer;
//  ErrRecCnt: integer;

  Num: Integer;
  Bias: double;

  ProgDlg: TProgressDlg;
  XmlIni: TXmlInifile;
  Title: string;
  DefaltFolder: string;
  Filter: string;
  Event:  TDatasetNotifyEvent;
begin
  InpFile   := TStringList.Create;
  ErrFile   := TStringList.Create;
  ProgDlg   := TProgressDlg.Create(self);
  XmlIni    := TXmlIniFile.Create(FXmlIniFileName);
  try
    s := 'CabrilloのAppend前に、ログデータのバックアップしてください。'#13
       + 'このまま続けますか？';
    if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
      exit;

    Title         := 'Append Cabrillo';
    XmlIni.OpenNode('File', true);
    InpExName     := XmlIni.ReadString('Cabrillo', '');
    DefaltFolder  :=  FMyDocPath;
    Filter        := 'Cabrillo files (*.log)|*.log|all files (*.*)|*.*';
    if GetOpenFileName(self, Title, DefaltFolder, Filter, InpExName)  then
      begin
      XmlIni.WriteString('Cabrillo', InpExName);
      XmlIni.CloseNode;
      XmlIni.UpdateFile;
      end
    else
      exit;

    InpFile.LoadFromFile(InpExName);
    with ProgDlg do
      begin
      Title    := 'Cabrillo Fileからインポート';
      Caption1 := '少しお待ちください。';
      Max := InpFile.Count;
      Show;
      end;

//  ここからAppeend処理
    Screen.Cursor := crHourGlass;
    Num  :=  GetNewNumOfQsoLog;
    InpRecCnt :=  0;
    OutRecCnt :=  0;
//    ErrRecCnt :=  0;
    cdsQsoLog.DisableControls;
    SimplifycdsQsoLog;
    Event :=  cdsQsoLog.OnCalcFields;
    cdsQsoLog.OnCalcFields  := nil;
    Bias  :=  0;

    for i := 1 to InpFile.Count - 1 do
      begin
      InpRec  :=  InpFile[i];
      if UpperCase(Copy(InpRec, 1, 4)) = 'QSO:' then
        begin
        cdsQsoLog.Append;
        Inc(InpRecCnt);
        if AppendCabrillo_Sub(Num, InpRec, ErrMsg, Bias, ExtractFileNameOnly(InpExName)) then
          begin
          cdsQsoLog.Post;
          Inc(Num);
          Inc(OutRecCnt);
          end
        else
          begin
          cdsQsoLog.Cancel;
          ErrFile.Add(format('Rec=%d %s', [InpRecCnt, ErrMsg]));
          end;
        end;
      ProgDlg.StepIt;
      end;

    ProgDlg.Caption1 := '更新を適用中です。少しお待ちください。';
    cdsQsoLog.ApplyUpdates(1);
    trnLogBase.Commit;
    cdsQsoLog.OnCalcFields  :=  Event;
    Application.ProcessMessages;
    ProgDlg.Close;
    ModifycdsQsoLog;
    cdsQsoLog.EnableControls;
    cdsQsoLog.Last;

    s := format('CabrilloのAppendが完了しました。' + #13#10
       + 'レコード件数=%d',  [OutRecCnt]);
    MessageDlg(s, mtInformation, [mbOk], 0);
    if ErrFile.Count <> 0 then
      begin
      ErrExName :=  ExtractFilePath(InpExName) + 'AppendErr.txt';
      ErrFile.SaveToFile(ErrExName);
      s := format('CabrilloのAppendエラーがあります。' + #13#10
         + 'ファイル名=%s' + #13#10
         + 'レコード件数=%d', [ErrExName, ErrFile.Count]);
      MessageDlg(s, mtInformation, [mbOk], 0);
      end;

  finally
    Screen.Cursor := crDefault;
    FreeAndNil(InpFile);
    FreeAndNil(ErrFile);
    FreeAndNil(ProgDlg);
    FreeAndNil(XmlIni);
  end;
end;
{
QSO: 14000 PH 2017-10-28 0000 T88CJ         59  25     JA2QQC        59  25     0
QSO: 14000 PH 2017-10-28 0000 T88CJ         59  25     JA2GHP        59  25     0
QSO: 14000 PH 2017-10-29 2309 T88CJ         59  27     JF1OJC        59  25     0
QSO: 14000 PH 2017-10-29 2312 T88CJ         59  27     JH1HGI        59  25     0
QSO: 14000 PH 2017-10-29 2313 T88CJ         59  27     JH3OXM        59  25     0
QSO: 14000 PH 2017-10-29 2314 T88CJ         59  27     JA7BEW        59  25     0
}
function TEngine.AppendCabrillo_sub(Num: Integer; InpRec: string; var ErrMsg: string; Bias: double; Comment: string): boolean;
var
  s,t: string;
  dt: TDateTime;
  InpS: TstringList;
  ModeList: TStringList;
  EntityList: TStringList;
  CallsignRec: TCallsignRec;
  FreqRec: TFreqRec;
  EntityRec:  TEntityRec;
  Freq: Integer;
const
  cMode: string = ('CW=CW,PH=SSB,RY=RTTY,PS=PSK31,FM=FM');
  procedure PutErrRec(Value: string);
  begin
    if ErrMsg = '' then
      ErrMsg := Value
    else
      ErrMsg := ErrMsg + ',' + Value;
    result := false;
  end;
begin
  result  := true;
  InpS        := TstringList.Create;
  InpS.Delimiter := ' ';   // Space区切りにする
  ModeList    := TstringList.Create;
  EntityList  := TstringList.Create;
  try
    ModeList.CommaText := Cmode;
    InpS.CommaText    := InpRec;
    if UpperCase(InpS.Strings[0]) <> 'QSO:' then
      begin
      exit;
      end;

    cdsQsoLogNum.AsInteger          := Num;
    cdsQsoLogCallsign.AsString      := InpS.Strings[8];         // Callsign
    CheckCallsign(cdsQsoLogCallsign.AsString, CallsignRec);
    cdsQsoLogOrgCallsign.AsString   := CallsignRec.OrgCallsign;
    cdsQsoLogPrefix.AsString        := CallsignRec.Prefix;
    cdsQsoLogSuffix.AsString        := CallsignRec.Suffix;

//  時刻はUTCで設定されている前提
    t := InpS[3] + ' ' + Copy(InpS[4],1,2) + ':' + Copy(InpS[4],3,2);  // OnDateTime
    t := StringReplace(t, '-', '/', [rfReplaceAll]);
    if TryStrToDateTime(t, dt) then
      cdsQsoLogOnDateTime.AsString  := FormatDateTime('yyyy/mm/dd hh:nn', dt)
    else
      begin
      s := Format('OnDateが日付="%s"でない',[t]);
      PutErrRec(s);
      end;

    if TryStrToInt(InpS[1], Freq) then   // Freq
      begin
      cdsQsoLogFreq.AsLargeInt      := Freq * 1000;
      if CheckFreq(cdsQsoLogFreq.AsLargeInt, FreqRec) then
        cdsQsoLogBand.AsInteger           := FreqRec.Band
      else
        cdsQsoLogBand.AsInteger           := cdsQsoLogFreq.AsInteger;
      end
    else
      begin
      s := Format('Freqが数値="%s"でない',[t]);
      PutErrRec(s);
      end;

    cdsQsoLogMode.AsString   := ModeList.Values[InpS[2]];    // Mode
    if cdsQsoLogMode.AsString = '' then
      cdsQsoLogMode.AsString :=  InpS[2];

    cdsQsoLogHisReport.AsString     := InpS[6];     // HisReport
    cdsQsoLogMyReport.AsString      := InpS[9];     // MyReport
    t := Comment + ' ' + InpS[7] + '/' + InpS[10];  // Memo
    cdsQsoLogMemo.AsString          := t;

    GetEntityList(CallsignRec.Prefix, CallsignRec.Suffix, dt, EntityList);
    if EntityList.Count >= 1 then
      begin
      cdsQsoLogEntity.AsString      := EntityList.Names[0];
      CheckEntity(cdsQsoLogEntity.AsString, EntityRec);
      if EntityRec.result then
        begin
        cdsQsoLogEntity.AsString    := EntityRec.Entity;
        cdsQsoLogCountry.AsString   := EntityRec.Country;
        cdsQsoLogContinent.asString := EntityRec.Continent;
        cdsQsoLogItuZone.asString   := EntityRec.ItuZone;
        cdsQsoLogCqZone.AsString    := EntityRec.CqZone;
        end;
      end;

//       JARLの国内コンテストはCabrilloを受け付けない 故にRegionの設定なし
  finally
    Screen.Cursor := crDefault;
    FreeAndNil(InpS);
    FreeAndNil(ModeList);
    FreeAndNil(EntityList);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//     CTestWinファイルをアペンドする
//
////////////////////////////////////////////////////////////////////////////////
procedure TEngine.AppendCTestWin();
var
  i: integer;
  s: string;
  ErrMsg: string;
  Num: Integer;

  InpExName: string;
  ErrExName: string;
  InpFile:    TStringList;
  ErrFile:    TStringList;
  InpRec: string;
  OutRecCnt: integer;

//  wFileName: string;
  Bias: double;

  ProgDlg:      TProgressDlg;
  XmlIni:       TXmlInifile;

  Title: string;
//  FileName: string;
  DefaltFolder: string;
  Filter: string;
  Event:  TDatasetNotifyEvent;
begin
  InpFile := TStringList.Create;
  ErrFile := TStringList.Create;
  ProgDlg     := TProgressDlg.Create(Application);
  XmlIni      := TXmlIniFile.Create(FXmlIniFileName);
  try
    s := 'CTestWinのAppend前に、ログデータのバックアップしてください。'#13
       + 'このまま続けますか？';
    if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
      exit;

    Title         := 'Append CTestWin';
    XmlIni.OpenNode('File', true);
    InpExName      := XmlIni.ReadString('CTestWin', '');
    DefaltFolder  :=  FMyDocPath;
    Filter        := 'CTestWin files (*.txt)|*.txt|all files (*.*)|*.*';
    if GetOpenFileName(self, Title, DefaltFolder, Filter, InpExName)  then
      begin
      XmlIni.WriteString('CTestWin', InpExName);
      XmlIni.CloseNode;
      XmlIni.UpdateFile;
      end
    else
      exit;

    if not GetTimeZoneBias(Bias) then
      exit;

    InpFile.LoadFromFile(InpExName);
    with ProgDlg do
      begin
      Title    := 'CTestWinからインポート';
      Caption1 := '少しお待ちください。';
      Max := InpFile.Count;
      Show;
      end;

//  ここからAppeend処理
    Screen.Cursor := crHourGlass;
    Num  :=  GetNewNumOfQsoLog;
    OutRecCnt :=  0;
    SimplifycdsQsoLog;                 // 必要か？‘
    cdsQsoLog.DisableControls;
    Event :=  cdsQsoLog.OnCalcFields;
    cdsQsoLog.OnCalcFields  := nil;

    for i := 0 to InpFile.Count - 1 do
      begin
      cdsQsoLog.Append;
      InpRec := InpFile[i];
      if AppendCTestWin_Sub(Num, InpRec, ErrMsg, Bias, ExtractFileNameOnly(InpExName)) then
        begin
        cdsQsoLog.Post;
        Inc(Num);
        Inc(OutRecCnt);
        end
      else
        begin
        cdsQsoLog.Cancel;
        ErrFile.Add(format('Rec=%d %s', [i, ErrMsg]));
        end;
      ProgDlg.StepIt;
      end;

    ProgDlg.Caption1 := '更新を適用中です。少しお待ちください。';
    cdsQsoLog.ApplyUpdates(1);
    trnLogBase.Commit;
    cdsQsoLog.OnCalcFields  :=  Event;
    Application.ProcessMessages;
    ProgDlg.Close;
    ModifycdsQsoLog;
    cdsQsoLog.EnableControls;
    cdsQsoLog.Last;

    s := format('CTestWin FileのAppendが完了しました。' + #13#10
       + 'レコード件数=%d',  [OutRecCnt]);
    MessageDlg(s, mtInformation, [mbOk], 0);
    if ErrFile.Count <> 0 then
      begin
      ErrExName :=  ExtractFilePath(InpExName) + 'AppendErr.txt';
      ErrFile.SaveToFile(ErrExName);
      s := format('CTestWin FileのAppendエラーがあります。' + #13#10
         + 'ファイル名=%s' + #13#10
         + 'レコード件数=%d', [ErrExName, ErrFile.Count]);
      MessageDlg(s, mtInformation, [mbOk], 0);
      end;
  finally
    Screen.Cursor := crDefault;
    FreeAndNil(InpFile);
    FreeAndNil(ErrFile);
    FreeAndNil(ProgDlg);
    FreeAndNil(XmlIni);
  end;
end;

{   CTestWin.txtのフォーマット (注意) 月・日の桁数によって、以降の項目位置が変わる
 2008/8/10 12:01 JI1AQY        21      SSB    5914M       5914H
 2008/12/3 12:03 JQ1WKO/1      21      SSB    5914M       5915M
 2008/8/3 02:49 JF1VVU        14      SSB    5914M       5914M
 2008/8/3 12:50 JA1FJF/1      50      CW     59914M      59914M                   移動 常陸太田市
}
function TEngine.AppendCTestWin_Sub(Num: Integer; InpRec: string; var ErrMsg: string; Bias: double; Comment: string): boolean;
var
//  isErr: boolean;
  Rec:          TstringList;
  wEntityList:  TStringList;
  wEntityRec:   TEntityRec;
  wCallsignRec: TCallsignRec;
  wFreqRec:     TFreqRec;

  s: string;
  j: integer;
  f1: double;
  dt: TDateTime;
  wMode: string;
  wSend,wRecv: string;
  wMemo: string;
  procedure PutErrRec(Value: string);
  begin
    if ErrMsg = '' then
      ErrMsg := Value
    else
      ErrMsg := ErrMsg + ',' + Value;
    result := false;
  end;
begin
  result :=  true;
  Rec       := TStringList.Create;
  Rec.Delimiter := ' ';   // Space区切りにする
  wEntityList :=  TstringList.Create;
  try
//    isErr  :=  false;
    Rec.CommaText               := Trim(InpRec);

    cdsQsoLogNum.AsInteger      := Num;
    cdsQsoLogCallsign.AsString  := trim(rec[2]);   // Callsign
    s := trim(rec[0]) + ' ' + trim(rec[1]);
    if TryStrToDateTime(s, dt) then
      cdsQsoLogOnDateTime.AsString  := FormatDateTime('yyyy/mm/dd hh:nn', dt - Bias)  // OnDateTime
    else
      begin
      s := Format('OnDateが日付="%s"でない',[s]);
      PutErrRec(s);
      end;
    wMode := Trim(rec[4]);
    wSend := Trim(rec[5]);
    wRecv := Trim(rec[6]);
    cdsQsoLogMode.AsString          := wMode;
    if TryStrToFloat(rec[3], f1) then
      begin
      f1 := f1 * kMHz;
      cdsQsoLogFreq.AsLargeInt      := Trunc(f1);
      end
    else
      begin
      s := Format('Freqが数値="%s"でない',[rec[3]]);
      PutErrRec(s);
      end;
    if wMode = 'CW' then
      begin
      cdsQsoLogHisReport.AsString := Trim(Copy(wSend,1,3));   // Send RST
      cdsQsoLogMyReport.AsString  := Trim(Copy(wRecv,1,3));   // Recv RST
      wMemo :=  Comment + ' ' + Trim(Copy(wRecv,4,8));        // Recv No
      end
    else
      begin
      cdsQsoLogHisReport.AsString := Trim(Copy(wSend,1,2));   // Send RST
      cdsQsoLogMyReport.AsString  := Trim(Copy(wRecv,1,2));   // Recv RST
      wMemo :=  Comment + ' ' + Trim(Copy(wRecv,3,8));        // Recv No
      end;
    for j := 7 to rec.Count -1 do
      wMemo := wMemo + ' ' + trim(rec[j]);
    cdsQsoLogMemo.AsString          := wMemo;

    CheckCallsign(cdsQsoLogCallsign.AsString, wCallsignRec);
    cdsQsoLogOrgCallsign.AsString   := wCallsignRec.OrgCallsign;
    cdsQsoLogPrefix.AsString        := wCallsignRec.Prefix;
    cdsQsoLogSuffix.AsString        := wCallsignRec.Suffix;
    if CheckFreq(cdsQsoLogFreq.AsLargeInt, wFreqRec) then
      cdsQsoLogBand.AsInteger       := wFreqRec.Band
    else
      cdsQsoLogBand.AsInteger       := cdsQsoLogFreq.AsInteger;
    GetEntityList(wCallsignRec.Prefix, wCallsignRec.Suffix, dt, wEntityList);
    if wEntityList.Count >= 1 then
      begin
      cdsQsoLogEntity.AsString      := wEntityList.Names[0];
      CheckEntity(cdsQsoLogEntity.AsString, wEntityRec);
      if wEntityRec.result then
        begin
        cdsQsoLogEntity.AsString    := wEntityRec.Entity;
        cdsQsoLogCountry.AsString   := wEntityRec.Country;
        cdsQsoLogContinent.asString := wEntityRec.Continent;
        cdsQsoLogItuZone.asString   := wEntityRec.ItuZone;
        cdsQsoLogCqZone.AsString    := wEntityRec.CqZone;
        end;
      end;

    cdsQsoLogCq.AsInteger           := 0;
    cdsQsoLogSwl.AsInteger          := 0;
  finally
    FreeAndNil(Rec);
    FreeAndNil(wEntityList);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//     HAMLOGファイルをアペンドする
//
////////////////////////////////////////////////////////////////////////////////
procedure TEngine.AppendHamlog;
var
  i: integer;
  s: string;
  Num: Integer;
  InpExName: string;
  ErrExName: string;

  InpFile: TstringList;
  ErrFile: TstringList;
  OutRecCnt: integer;
  ErrMsg: string;
  ProgDlg: TProgressDlg;
  XmlIni: TXmlIniFile;

  Title: string;
  DefaltFolder: string;
  Filter: string;
  Event: TDatasetNotifyEvent;
begin
  ProgDlg     := TProgressDlg.Create(self);
  XmlIni      := TXmlIniFile.Create(FXmlIniFileName);
  InpFile     := TstringList.Create;
  InpFile.StrictDelimiter := true;       //  空白を区切り文字としないため
  ErrFile     := TstringList.Create;
  try
    s := 'HAMLOGのAppend前に、ログデータのバックアップしてください。'#13
       + 'このまま続けますか？';
    if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
      exit;

    Title         := 'Append Hamlog';
    XmlIni.OpenNode('File', true);
    InpExName     := XmlIni.ReadString('HAMLOG', '');
    DefaltFolder  := FMyDocPath;
    Filter        := 'Hamlog files (*.csv)|*.csv';
    if GetOpenFileName(self, Title, DefaltFolder, Filter, InpExName)  then
      begin
      XmlIni.WriteString('HAMLOG', InpExName);
      XmlIni.CloseNode;
      XmlIni.UpdateFile;
      end
    else
      exit;

    InpFile.LoadFromFile(InpExName);
    with ProgDlg do
      begin
      Title    := 'HAMLOGからAppend';
      Caption1 := '少しお待ちください。';
      Max := InpFile.Count;
      Show;
      end;

    Screen.Cursor := crHourGlass;
    Num  :=  GetNewNumOfQsoLog;     //   開始Numを記録
    OutRecCnt := 0;
    cdsQsoLog.DisableConstraints;
    Event :=  cdsQsoLog.OnCalcFields;
    cdsQsoLog.OnCalcFields  :=  nil;

    for i := 0 to InpFile.Count - 1 do
      begin
      cdsQsoLog.Append;
      if AppendHamlog_Sub(Num, InpFile.Strings[i], ErrMsg) then
        begin
        cdsQsoLog.Post;
        Inc(Num);
        Inc(OutRecCnt);
        end
      else
        begin
        cdsQsoLog.Cancel;
        ErrFile.Add(format('Rec=%d %s', [i, ErrMsg]));
        end;
      ProgDlg.StepIt;
      end;

    ProgDlg.Caption1 := '更新を適用中です。少しお待ちください。';
    cdsQsoLog.ApplyUpdates(1);
    trnLogBase.Commit;
    Application.ProcessMessages;
    cdsQsoLog.OnCalcFields  :=  Event;
    cdsQsoLog.EnableControls;
    ProgDlg.Close;
    DataBaseClose;
    DataBaseOpen;
    CDSQsoLog.Last;

    s := FORMAT('HAMLOGのAppendが完了しました。' + #13#10
       + 'レコード件数=%d', [OutRecCnt]);
    MessageDlg(s, mtInformation, [mbOk], 0);
    if ErrFile.Count <> 0 then
      begin
      ErrExName :=  ExtractFilePath(InpExName) + 'AppendErr.txt';
      ErrFile.SaveToFile(ErrExName);
      s := format('HAMLOGのApplyエラーがあります。' + #13#10
         + 'ファイル名=%s' + #13#10
         + 'レコード件数=%d', [ErrExName, ErrFile.Count]);
      MessageDlg(s, mtInformation, [mbOk], 0);
      end;
  finally
    Screen.Cursor := crDefault;
    FreeAndNil(InpFile);
    FreeAndNil(ErrFile);
    FreeAndNil(ProgDlg);
    FreeAndNil(XmlIni);
  end;
end;

{
JP7LIV,17/09/10,21:27J,59,59,145.1,FM,0315,,J,きくち,岩手県奥州市,opja7lfi,"$C=JA7LFI$ $P=岩手県一関市$ $J=JCC:0304$",0
JH7JUO,17/09/10,21:32J,59,52,145.1,FM,0307,,J,さいとう,岩手県花巻市,,"$C=JA7LFI$ $P=岩手県一関市$ $J=JCC:0304$",0
JA1AAA,17/09/16,09:51J,59,59,7,SSB,1604,,J,こばやし,群馬県伊勢崎市,OPJA7LFIJCC#03009A西磐井郡平泉町移動↓,"$C=JA7LFI$ $P=岩手県西磐井郡平泉町$ $J=JCG:03009A$",0
}
function TEngine.AppendHamlog_Sub(Num: Integer; InpRec: string; var ErrMsg: string): boolean;
var
  Ver: integer;
  dt: TdateTime;
  wCallsignRec: TCallsignRec;
  wFreqRec: TFreqRec;
  wEntityRec: TEntityRec;
  InpS: TstringList;
  j: integer;
  s,s2: string;
  f: double;
  d: Int64;
  Qsl_HamLog: string;
  HamlogQslList: TStringList;
  RegIota: TSkRegExp;
  procedure PutErrRec(Value: string);
  begin
    if ErrMsg = '' then
      ErrMsg := Value
    else
      ErrMsg := ErrMsg + ',' + Value;
    result := false;
  end;
begin
  result := true;
  InpS  := TstringList.Create;
  RegIota := TSkRegExp.Create;
  HamlogQslList := TStringList.Create;
  Qsl_Hamlog := '';
  GetHamlogQslList(HamLogQslList);   // HAMLOGのQSLマークを置き換える為
  try
    InpS.CommaText  :=  InpRec;
    for j := InpS.Count to 14 do      // 文字化け等により正しく処理できないときの対処
      InpS.Add('');

//   HamlogのVer判断（日時の位置で判断する）
    if TryStrToDate(InpS[1], dt) and TryStrToTime(Copy(InpS[2], 1, 5), dt) then   //   Hamlog Ver5の時
      Ver := 0   //   Hamlog Ver5の時
    else if TryStrToDate(InpS[2], dt) and TryStrToTime(Copy(InpS[3], 1, 5), dt) then   //   Hamlog Ver4の時
      Ver := 1
    else
      begin
      s := 'レコードのフォオーマットがあっていない';
      PutErrRec(s);
      exit;
      end;

    cdsQsoLogNUM.AsInteger  := Num;
    s := TRIM(Inps[0]);     // Callsignの処理
    if Ver = 1 then
      begin
      s2 := TRIM(Inps[1]);
      if s2 <> '' then
        begin
        if Copy(s2, 1, 1) = '/'  then
          s := s + s2
        else if Copy(s2, Length(s2), 1) = '/'  then
          s := s2 + s
        else
          s := s + '/' + s2;
        end;
      end;
    cdsQsoLogCallsign.AsString := s;
    if CheckCallsign(cdsQsoLogCallsign.AsString, wCallsignRec) then
      begin
      cdsQsoLogOrgCallsign.AsString  := wCallsignRec.OrgCallsign;
      cdsQsoLogPREFIX.AsString    := wCallsignRec.Prefix;
      cdsQsoLogSUFFIX.AsString    := wCallsignRec.Suffix;
      end;

    s := InpS[1 + Ver] + ' ' + Copy(InpS[2 + Ver], 1, 5);    // 日付時刻の処理
    if TryStrToDateTime(s, dt) then
      begin
      s := Copy(Inps[2 + Ver], 6, 1);
      if (s <> 'U') and (s <> 'Z') then          // LocalTimeのとき
        dt :=  dt - FTimeZoneBiasD;
      cdsQsoLogONDATETIME.AsDateTime := dt;
      end
    else
      begin
      s := Format('OnDateTimeが日付="%s"でない',[s]);
      PutErrRec(s);
      end;

    cdsQsoLogHISREPORT.AsString :=  InpS[3 + Ver];    // HisReport
    cdsQsoLogMYREPORT.AsString  :=  InpS[4 + Ver];    // MyReport

    s := InpS[5 + Ver];
    if TryStrToFloat (s, f) then
      begin
      f := f * kMHz;
      d := Trunc(f);
      cdsQsoLogFREQ.AsInteger := d;    //  Freq
      if CheckFreq(d, wFreqRec) then
        cdsQsoLogBAND.AsInteger :=  wFreqRec.Band   // Band
      else
        cdsQsoLogBAND.AsInteger :=  d;
      end
    else
      begin
      s := Format('Freqが数値="%s"でない',[s]);
      PutErrRec(s);
      end;
    cdsQsoLogMode.AsString  :=  InpS[6 + Ver];    // Mode

    if InpS[7 + Ver] < '5000' then   // 高速化のため（効果不明）
      begin
      cdsQsoLogENTITY.AsString    :=  'JA';
      cdsQsoLogCOUNTRY.AsString   :=  'JPN';
      cdsQsoLogREGION.AsString    :=  InpS[7 + Ver];  // Region
      cdsQsoLogCONTINENT.AsString :=  'AS';           // Continent
      cdsQsoLogITUZONE.AsString   :=  '45';           // Itu Zone
      cdsQsoLogCQZONE.AsString    :=  '25';           // Cq Zone
      end
    else if InpS[7 + Ver] = '500A' then
      begin
      cdsQsoLogENTITY.AsString    :=  'JA';
      cdsQsoLogCOUNTRY.AsString   :=  'JPN';
      cdsQsoLogCONTINENT.AsString :=  'AS';           // Continent
      cdsQsoLogITUZONE.AsString   :=  '45';           // Itu Zone
      cdsQsoLogCQZONE.AsString    :=  '25';           // Cq Zone
      end
    else if InpS[7 + Ver] = '648A' then               // 南鳥島
      begin
      cdsQsoLogENTITY.AsString    :=  'JD1/M';
      cdsQsoLogCOUNTRY.AsString   :=  'JPN';
      cdsQsoLogREGION.AsString    :=  '10007A';       // 小笠原村
      cdsQsoLogCONTINENT.AsString :=  'OC';
      cdsQsoLogITUZONE.AsString   :=  '90';
      cdsQsoLogCQZONE.AsString    :=  '27';
      end
    else if InpS[7 + Ver] = '649A' then               // 小笠原諸島
      begin
      cdsQsoLogENTITY.AsString    :=  'JD1';
      cdsQsoLogCOUNTRY.AsString   :=  'JPN';
      cdsQsoLogREGION.AsString    :=  '10007A';       // 小笠原村
      cdsQsoLogCONTINENT.AsString :=  'AS';
      cdsQsoLogITUZONE.AsString   :=  '45';
      cdsQsoLogCQZONE.AsString    :=  '27';
      end
    else
      begin
      CheckHamLog(InpS[7 + Ver]);
      if cHamLog.result then
        if CheckEntity(cHamLog.Entity, wEntityRec) then
          begin
          cdsQSoLogENTITY.AsString    := wEntityRec.Entity;
          cdsQSoLogCOUNTRY.AsString   := wEntityRec.Country;
          cdsQSoLogCONTINENT.AsString := wEntityRec.Continent;
          cdsQSoLogITUZONE.AsString   := wEntityRec.ITUZone;
          cdsQSoLogCQZONE.AsString    := wEntityRec.CQZone;
          end;
      end;

    cdsQsoLogGRIDLOC.AsString   :=  UpperCase(InpS[8 + Ver]);
    cdsQsoLogQSL.AsString       :=  Copy(InpS[9 + Ver],1,1);
    cdsQsoLogQSLSEND.AsString   :=  Copy(InpS[9 + Ver],2,1);
    cdsQsoLogQSLRECV.AsString   :=  Copy(InpS[9 + Ver],3,1);
    if cdsQsoLogQSL.AsString = HamLogQslList.Names[0]   then
      cdsQsoLogQSL.AsString := HamLogQslList.ValueFromIndex[0];
    if cdsQsoLogQSLSend.AsString = HamLogQslList.Names[1]   then
      cdsQsoLogQSLSend.AsString := HamLogQslList.ValueFromIndex[1];
    if cdsQsoLogQSLRecv.AsString = HamLogQslList.Names[2]   then
      cdsQsoLogQSLRecv.AsString := HamLogQslList.ValueFromIndex[2];
    cdsQsoLogNAME.AsString      :=  InpS[10 + Ver];
    s :=  Trim(Trim(InpS[12 + Ver]) + ' ' + Trim(InpS[13 + Ver]));
    cdsQsoLogMEMO.AsString      :=  s;
    RegIota.Expression := '[\s%,]?((AF|AS|AN|EU|NA|OC|SA)-[0-9]{3})[\s%,]?';  //  IOTAを抽出する
    RegIota.IgnoreCase := false;
    if RegIota.Exec(s) then
      cdsQsoLogIota.AsString    := RegIota.Groups[0].Strings;
  finally
    FreeAndNil(InpS);
    FreeAndNil(RegIota);
    FreeAndNil(HamLogQslList);
  end;
end;

function TEngine.GetHamlogQslList(var QslList: TStringList): boolean;
  var
    sl: TstringList;
    XmlIni: TXmlIniFile;
  begin
    sl          := TstringList.Create;
    XmlIni      := TXmlIniFile.Create(FXmlIniFileName);
    try
      QslList.Clear;
      XmlIni.OpenNode('/HAMLOG', true);
      sl.CommaText  :=  XmlIni.ReadString('Qsl', '');
      if sl.Count = 2 then
        QslList.Add(sl[0] + '=' + sl[1])
      else
        QslList.Add('J=J');

      sl.CommaText  :=  XmlIni.ReadString('QslSend', '');
      if sl.Count = 2 then
        QslList.Add(sl[0] + '=' + sl[1])
      else
        QslList.Add('*=S');
      sl.CommaText  :=  XmlIni.ReadString('QslRecv', '');
      if sl.Count = 2 then
        QslList.Add(sl[0] + '=' + sl[1])
      else
        QslList.Add('*=R');
    finally
      result := true;
      FreeAndNil(sl);
      FreeAndNil(XmlIni);
    end;
  end;

////////////////////////////////////////////////////////////////////////////////
//
//     ZLogファイルをアペンドする
//
////////////////////////////////////////////////////////////////////////////////
procedure TEngine.AppendZlog();
var
  s,t: string;
  i: integer;
//  f: double;
//  dt: TDateTime;
  Bias: Double;

  Num: Integer;
  InpExName: string;
  ErrExName: string;
  InpFile: TstringList;
  ErrFile: TStringList;
  OutRecCnt: Integer;
//  ErrRecCnt: integer;
  InpRec: string;
  ErrMsg: string;

  ProgDlg: TProgressDlg;
  XmlIni: TXmlInifile;

  Title: string;
//  FileName: string;
  DefaltFolder: string;
  Filter: string;
  Event: TDatasetNotifyEvent;
begin
  InpFile   := TStringList.Create;
  ErrFile   := TStringList.Create;
  ProgDlg   := TProgressDlg.Create(self);
  XmlIni    := TXmlIniFile.Create(FXmlIniFileName);
  try
    s := 'ZLogのAppend前に、ログデータのバックアップしてください。'#13
       + 'このまま続けますか？';
    if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
      exit;

    Title         := 'Append ZLog';
    XmlIni.OpenNode('File', true);
    InpExName     := XmlIni.ReadString('ZLog', '');
    DefaltFolder  :=  FMyDocPath;
    Filter        := 'ZLog files (*.all)|*.all|all files (*.*)|*.*';
    if GetOpenFileName(self, Title, DefaltFolder, Filter, InpExName)  then
      begin
      XmlIni.WriteString('ZLog', InpExName);
      XmlIni.CloseNode;
      XmlIni.UpdateFile;
      end
    else
      exit;

    if not GetTimeZoneBias(Bias) then
      exit;

    InpFile.LoadFromFile(InpExName);
    if InpFile.Count <= 1 then
      exit;
    t := 'zLog for Windows'; // 'zLog for Windows'の後ろに何か1桁含まれているため
    InpRec := InpFile.Strings[0];
    if Copy(InpRec, 1, Length(T)) <> t then
      begin
      s := '"' + InpExName + '" はZLog.allのフォーマットでない。';
      MessageDlg(s, mtInformation	, [mbYes],0);
      Exit;
      end;

    with ProgDlg do
      begin
      Title    := 'ZLogからインポート';
      Caption1 := '少しお待ちください。';
      Max := InpFile.Count;
      StepIt;   //  第一レコードの分
      Show;
      end;
//  ここからAppeend処理
    Screen.Cursor := crHourGlass;
    Num  :=  GetNewNumOfQsoLog;     //   開始Numを記録
//    ErrRecCnt := 0;
    cdsQsoLog.DisableConstraints;
    Event :=  cdsQsoLog.OnCalcFields;
    cdsQsoLog.OnCalcFields  :=  nil;
    OutRecCnt := 0;

    for i := 1 to InpFile.Count - 1 do    // 開始が0でない
      begin
      cdsQsoLog.Append;
      if AppendZLog_Sub(Num, InpFile[i], ErrMsg, Bias, ExtractFileNameOnly(InpExName)) then
        begin
        cdsQsoLog.Post;
        Inc(Num);
        Inc(OutRecCnt);
        end
      else
        begin
        cdsQsoLog.Cancel;
        ErrFile.Add(format('Rec=%d %s', [i, ErrMsg]));
        end;
      ProgDlg.StepIt;
      end;

    ProgDlg.Caption1 := '更新を適用中です。少しお待ちください。';
    cdsQsoLog.ApplyUpdates(1);
    trnLogBase.Commit;
    cdsQsoLog.OnCalcFields  :=  Event;
    Application.ProcessMessages;
    ProgDlg.Close;
    ModifycdsQsoLog;
    cdsQsoLog.EnableControls;
    cdsQsoLog.Last;

    s := format('ZLogのAppendが完了しました。' + #13#10
       + 'レコード件数=%d',  [OutRecCnt]);
    MessageDlg(s, mtInformation, [mbOk], 0);
    if ErrFile.Count <> 0 then
      begin
      ErrExName :=  ExtractFilePath(InpExName) + 'AppendErr.txt';
      ErrFile.SaveToFile(ErrExName);
      s := format('ZlogのAppendエラーがあります。' + #13#10
         + 'ファイル名=%s' + #13#10
         + 'レコード件数=%d', [ErrExName, ErrFile.Count]);
      MessageDlg(s, mtInformation, [mbOk], 0);
      end;
  finally
    Screen.Cursor :=  crDefault;
    FreeAndNil(InpFile);
    FreeAndNil(ErrFile);
    FreeAndNil(ProgDlg);
    FreeAndNil(XmlIni);
  end;
end;

  {   ZLog.allのフォーマット
zLog for Windows
2003/08/02 21:05 JO7CYF/7     59  03M     59  06M     06    -     50   SSB  1
2005/04/17 00:03 JR9CRJ       59  03012   59  30      30    -     3.5  SSB  1  nakashima
2005/04/17 00:59 JE7CWH/7     59  03012   59  0612    0612  -     430  FM   1
2005/04/17 11:03 JA6DH        599 03012   599 40      40    -     14   CW   1
2007/04/29 09:31 JA7AAA       599 03P     599 03P     03    -     1200 RTTY 1
}
function TEngine.AppendZlog_Sub(Num: Integer; InpRec: string; var ErrMsg: string; Bias: double; Comment: string): boolean;
var
  s,t: string;
  f: double;
  dt: TDateTime;
  CallsignRec: TCallsignRec;
  FreqRec: TFreqRec;
  EntityList: TStringList;
  EntityRec:  TEntityRec;
  procedure PutErrRec(Value: string);
  begin
    if ErrMsg = '' then
      ErrMsg := Value
    else
      ErrMsg := ErrMsg + ',' + Value;
    result := false;
  end;
begin
  result  :=  true;
  EntityList := TStringList.Create;
  try
    cdsQsoLogNum.AsInteger          := Num;
    cdsQsoLogCallsign.AsString      := Trim(Copy(InpRec,18,12));
    if CheckCallsign(cdsQsoLogCallsign.AsString, CallsignRec) then
      begin
      cdsQsoLogOrgCallsign.AsString   := CallsignRec.OrgCallsign;
      cdsQsoLogPrefix.AsString        := CallsignRec.Prefix;
      cdsQsoLogSuffix.AsString        := CallsignRec.Suffix;
      GetEntityList(CallsignRec.Prefix, CallsignRec.Suffix, dt, EntityList);
      if EntityList.Count >= 1 then
        begin
        cdsQsoLogEntity.AsString      := EntityList.Names[0];
        CheckEntity(cdsQsoLogEntity.AsString, EntityRec);
        if EntityRec.result then
          begin
          cdsQsoLogEntity.AsString    := EntityRec.Entity;
          cdsQsoLogCountry.AsString   := EntityRec.Country;
          cdsQsoLogContinent.asString := EntityRec.Continent;
          cdsQsoLogItuZone.asString   := EntityRec.ItuZone;
          cdsQsoLogCqZone.AsString    := EntityRec.CqZone;
          end;
        end;
//      if EntityList.Count = 1 then
//        cdsQsoLogEntity.AsString      := EntityList.Names[0];
      end;

    t := Copy(InpRec,1,16);
    if TryStrToDateTime(t, dt) then
      cdsQsoLogOnDateTime.AsDateTime  := dt - Bias
    else
      begin
      s := Format('OnDateが日付="%s"でない',[t]);
      PutErrRec(s);
      end;

    t := Copy(InpRec,67,4);
    if TryStrToFloat(t, f) then
      begin
      f := f * kMHz;
      cdsQsoLogFreq.AsLargeInt      := Trunc(f);
      if CheckFreq(cdsQsoLogFreq.AsLargeInt, FreqRec) then
        cdsQsoLogBand.AsInteger           := FreqRec.Band
      else
        cdsQsoLogBand.AsInteger           := cdsQsoLogFreq.AsInteger;
      end
    else
      begin
      s := Format('Freqが数値="%s"でない',[t]);
      PutErrRec(s);
      end;

    cdsQsoLogHisReport.AsString     := Trim(Copy(InpRec,31,3));
    cdsQsoLogMyReport.AsString      := Trim(Copy(InpRec,43,3));
    cdsQsoLogMode.AsString          := Trim(Copy(InpRec,72,4));
    cdsQsoLogMemo.AsString          := Comment + ' ' + Trim(Copy(InpRec,47,8));
  finally
    FreeAndNil(EntityList);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//     ADIFファイルを出力する
//
////////////////////////////////////////////////////////////////////////////////
procedure TEngine.ExportADIF();
var
  s: string;
  s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12: string;
  RecNum: Integer;
//  UTC: TDateTime;
  ExpFileName: string;
  BandList: TStringList;
  ProgDlg: TProgressDlg;
  SaveDialog1: TSaveDialog;
  XmlIni: TXmlInifile;
  Adx: TAdx;
  isAdx: boolean;
begin
  BandList  := TStringList.Create;
  ProgDlg   := TProgressDlg.Create(self);
  SaveDialog1 := TSaveDialog.Create(Self);
  XmlIni    := TXmlIniFile.Create(FXmlIniFileName);
  Adx := TAdx.Create;
  isAdx  :=  false;
  try
    with SaveDialog1 do
      begin
      Title := 'Export ADIF/ADX';
      XmlIni.OpenNode('File', true);
      FileName    := XmlIni.ReadString('ADIF', '');
      if Filename = '' then
        begin
        InitialDir  :=  FMyDocPath;
        FileName    := FOptionsData.Callsign + '.adi';
        end
      else
        begin
        InitialDir    :=  ExtractFileDir(FileName);
        FileName      :=  ExtractFileName(FileName);
        end;
      DefaultExt := 'adi';
      Filter := 'ADIF/ADX files (*.adi)(*.adx)|*.adi;*.adx|All Files (*.*)|*.*';
      FilterIndex := 1;
      if not Execute then
        Exit;
      XmlIni.WriteString('ADIF', FileName);
      XmlIni.CloseNode;
      XmlIni.UpdateFile;
      ExpFileName := FileName;
      if UpperCase(ExtractFileExt(ExpFileName)) = '.ADX' then
        isAdx  :=  true;
      end;

    GetBandList('Band', 'Band_M', BandList);
    with ProgDlg do
      begin
      Title    := 'ADIF/ADXファイルへのエクスポート';
      Caption1 := '少しお待ちください。';
      Max := dsQsoLogSel.DataSet.RecordCount;
      Show;
    end;

    Screen.Cursor := crHourGlass;
    SimplifycdsQsoLogSel();
    with dsQsoLogSel.DataSet do
      begin
      DisableControls;
      Last;
      ProgDlg.Max := RecordCount;
      First;
      Adx.Clear;
      RecNum := 0;
      Adx.Add(aeHeader, 'ADIF_VER', '3.0.4');
      Adx.Add(aeHeader, 'CREATED_TIMESTAMP', FormatDateTime('yyyymmdd hhnnss', now - FTimeZoneBiasD));
      Adx.Add(aeHeader, 'PROGRAMID', GetVersionInfo(Application.ExeName, vrProductName));
      Adx.Add(aeHeader, 'PROGRAMVERSION', GetVersionInfo(Application.ExeName, vrFileVersion));
      while Not EOF do
        begin
        s1 := FieldByName('Callsign').asString;
        s2 := FormatDateTime('yyyymmdd',FieldByName('OnDateTime').AsDateTime);  // 常にUTCで出力する
        s3 := FormatDateTime('hhmm',FieldByName('OnDateTime').AsDateTime);
        s4 := BandList.Values[FieldByName('Band').asString];
        s5 := format('%.3f', [FieldByName('Freq').AsInteger / kMhz]);
        s6 := FieldByName('Mode').asString;
        s7 := FieldByName('HisReport').asString;
        s8 := FieldByName('MyReport').asString;
        s9 := FieldByName('Route').asString;

        Adx.Add(aeRecords);
        Adx.Add(aeRecord, 'CALL', s1);
        Adx.Add(aeRecord, 'QSO_DATE', s2);
        Adx.Add(aeRecord, 'TIME_ON', s3);
        Adx.Add(aeRecord, 'BAND', s4);
        Adx.Add(aeRecord, 'FREQ', s5);
        Adx.Add(aeRecord, 'MODE', s6);
        Adx.Add(aeRecord, 'RST_SENT', s7);
        Adx.Add(aeRecord, 'RST_RCVD', s8);
        if Uppercase(s9) = 'SATELLITE' then
          begin
          s10 := FieldByName('Repeater').asString;
          s11 := BandList.Values[FieldByName('RecvBand').asString];
          s12 := format('%.3f', [FieldByName('RecvFreq').AsInteger / kMhz]);
          Adx.Add(aeRecord, 'PROP_MODE', 'SAT');
          Adx.Add(aeRecord, 'SAT_NAME', s10);
          Adx.Add(aeRecord, 'BAND_RX', s11);
          Adx.Add(aeRecord, 'FREQ_RX', s12);
          end;
        Inc(RecNum);
        ProgDlg.StepIt;
        Next;
        end;
      if IsAdx then
        Adx.SaveAdx(ExpFileName)
      else
        begin
        Adx.AdxToAdif;
        Adx.SaveAdif(ExpFileName);
        end;

      EnableControls;
      First;
      end;
    ProgDlg.Close;
    ModifycdsQsoLogSel();
    Screen.Cursor := crDefault;
    s := Format('ADIF/ADXのエクスポートが完了しました。' + #13#10
       + 'レコード件数=%d', [RecNum]);
    MessageDlg(s, mtInformation, [mbOk], 0);
  finally
    FreeAndNil(BandList);
    FreeAndNil(ProgDlg);
    FreeAndNil(SaveDialog1);
    FreeAndNil(XmlIni);
    FreeAndNil(Adx);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//     EXCELファイルを出力する
//
////////////////////////////////////////////////////////////////////////////////
procedure TEngine.ExportExcel();
  type
   TValuesArray = Array of array of Variant;
  var
    xExcel        : Variant;
    xBook         : Variant;
    xSheet        : Variant;
    xLimitRowsCount: integer;
    xLimitColsCount:  integer;
    xBeginCell, xEndCell: OleVariant;
    xVer: string;
    Values: TValuesArray;
    Muls: array of double;
    r,c:  integer;
    s:  string;
    sl: TstringList;
    SaveDlg: TSaveDialog;
    ProgDlg: TProgressDlg;
    XmlIni: TXmlInifile;
    Bias: double;
  begin
    sl      := TStringList.Create;
    SaveDlg := TSaveDialog.Create(Self);
    ProgDlg := TProgressDlg.Create(Self);
    XmlIni  := TXmlIniFile.Create(FXmlIniFileName);
    xExcel  := CreateOleObject('Excel.Application');  //Excel起動
  //  if xExcel = null then
  //    exit;
    xVer := xExcel.Version;
    Try
      if not GetTimeZoneBias(Bias) then
        exit;

      with SaveDlg do
        begin
        Title := 'Excel File';
        XmlIni.OpenNode('File', true);
        FileName    := XmlIni.ReadString('ExcelFile', '');
        if FileName = '' then
          InitialDir  :=  FMyDocPath
        else
          begin
          InitialDir    :=  ExtractFileDir(FileName);
          FileName      :=  ExtractFileName(FileName);
          end;
        if StrToFloatDef(xVer, 0.0) > 11.9 then
          begin
          DefaultExt := 'xlsx';
          Filter := 'Excel files (*.xls;*.xlsx)|*.xls;*.xlsx';
          if FileName = '' then
          end
        else
          begin
          DefaultExt := 'xls';
          Filter := 'Excel files (*.xls)|*.xls';
          if FileName = '' then
            FileName := FOptionsData.Callsign + '.xls';
          end;
        if not Execute then
          Exit;
        XmlIni.WriteString('ExcelFile', FileName);
        XmlIni.CloseNode;
        XmlIni.UpdateFile;
        end;

      with ProgDlg do
        begin
        Title    := 'Excelファイルへのエクスポート';
        Caption1 := '少しお待ちください。';
        Caption2 := '';
        Show;
        end;
      Screen.Cursor := crHourGlass;
      SimplifycdsQsoLogSel();
      cdsQsoLogSel.DisableControls;

  //    xExcel.Visible  := True;
      xBook       :=  xExcel.Workbooks.add;
      xSheet      :=  xBook.ActiveSheet;
      xSheet.Name := application.Title;
      xLimitRowsCount := xSheet.Rows.count;
      xLimitColsCount := xSheet.Columns.count;
      if (xLimitcolsCount < dsQsoLogSel.DataSet.FieldCount)
      or (xLimitRowsCount < dsQsoLogSel.DataSet.RecordCount) then
        begin
        s := 'Excelの制限を越えるデータです';
        MessageDlg(s, mtError, [mbOk], 0);
        exit;
        end;
      SetLength(Values, dsQsoLogSel.DataSet.RecordCount + 1, dsQsoLogSel.DataSet.FieldCount);
      SetLength(Muls, dsQsoLogSel.DataSet.FieldCount);

      dsQsoLogSel.Dataset.GetFieldNames(sl);   //  フィールド名を出力する。
      for c := 0 to sl.Count - 1 do
        begin
        Values[0, c] := sl[C];
        if (dsQsoLogSel.Dataset.Fields[c].DataType = ftString)
        or (dsQsoLogSel.Dataset.Fields[c].DataType = ftWideString) then
          begin
          xSheet.columns[c + 1].NumberFormatLocal := '@';
          end
        else if (dsQsoLogSel.Dataset.Fields[c].DataType = ftLargeInt) then
          begin
          s := UpperCase(sl[c]);
          if (s = 'FREQ') or (s = 'BAND') or (s = 'RECVFREQ') or (s = 'RECVBAND') then
            begin
            Muls[c] := kMHz;
            xSheet.columns[c + 1].NumberFormatLocal := '#,##0.0000';
            end;
          end
        else if (dsQsoLogSel.Dataset.Fields[c].DataType = ftDateTime) then
          begin
  //        xSheet.columns[c + 1].ColumnWidth := 15.38;
          xSheet.columns[c + 1].NumberFormatLocal := 'yyyy/mm/dd hh:mm';
          end;
        end;
      with dsQsoLogSel.Dataset do              //  データを出力する。
        begin
        DisableControls;
        Last;
        ProgDlg.Max := RecordCount;
        First;
        r := 0;
        while Not EOF do
          begin
          inc(r);
          for c := 0 to dsQsoLogSel.Dataset.FieldCount - 1 do
            begin
            if (Fields[c].DataType = ftString)
            or (Fields[c].DataType = ftWideString) then
              begin
              Values[r, c]  :=  Fields[c].AsString;
              end
            else if Fields[c].DataType = ftLargeInt then
              begin
              Values[r, c]  :=  Fields[c].AsLargeInt / Muls[c];
              end
            else if Fields[c].DataType = ftDateTime then
              begin
              if Fields[c].asString <> '' then
              Values[r, c]  :=  FormatDateTime('yyyy/mm/dd hh:nn',Fields[c].asDateTime + Bias);
              end
            else if Fields[c].DataType = ftDate then
              begin
              if Fields[c].asString <> '' then
                Values[r, c]  :=  FormatDateTime('yyyy/mm/dd',Fields[c].asDateTime);
              end
            else
              Values[r, c]  :=  Fields[c].AsVariant;
            end;
          ProgDlg.StepIt;
          Next;
          end;
        EnableControls;
        First;
        end;
      xBeginCell  := xSheet.Cells.Item[1,1];
      xEndCell    := xSheet.Cells.Item[dsQsoLogSel.DataSet.RecordCount + 1, dsQsoLogSel.DataSet.FieldCount];
      xSheet.Range[xBeginCell, xEndCell] := variant(Values);
      xSheet.columns[cdsQsoLogSelCallsign.Index + 1].AutoFit;
      xSheet.columns[cdsQsoLogSelOnDateTime.Index + 1].AutoFit;   // 日付のカラム幅を設定
      xSheet.columns[cdsQsoLogSelOffDateTime.Index + 1].AutoFit;
      if FileExists(SaveDlg.FileName) then
        DeleteFile(SaveDlg.FileName);
      xBook.SaveAs(SaveDlg.FileName);
      xBook.Close;
      Screen.Cursor := crDefault;
      ModifycdsQsoLogSel();
      cdsQsoLogSel.EnableControls;
      ProgDlg.Close;
      s := Format('Excel Fileのエクスポートが完了しました。' + #13#10
         + 'レコード件数=%d', [r]);
      MessageDlg(s, mtInformation, [mbOk], 0);
    Finally
      if not VarIsEmpty(xExcel) then
        begin
        xbook := unAssigned;
        xSheet := UnAssigned;
        xExcel.Quit;
        xExcel := unAssigned;
        end;
      Values  := nil;
      Muls    := nil;
      FreeAndNil(XmlIni);
      FreeAndNil(SaveDlg);
      FreeAndNil(ProgDlg);
      FreeAndNil(sl);
    End;
  end;

////////////////////////////////////////////////////////////////////////////////
//
//     Txtファイルを出力する
//
////////////////////////////////////////////////////////////////////////////////
procedure TEngine.ExportText();
var
  i: integer;
  s: string;
  sl: TStringList;
  ExpFileName: string;
  ExpStream: TStringList;
  SaveDlg: TSaveDialog;
  ProgDlg: TProgressDlg;
  XmlIni: TXmlInifile;
  Bias: double;
begin
  sl  := TstringList.Create;
  SaveDlg := TSaveDialog.Create(Self);
  ProgDlg := TProgressDlg.Create(Self);
  ExpStream := TstringList.Create;
  XmlIni    := TXmlIniFile.Create(FXmlIniFileName);
  try
    if not GetTimeZoneBias(Bias) then
      exit;

    with SaveDlg do
      begin
      Title := 'Export File';
      XmlIni.OpenNode('File', true);
      FileName    := XmlIni.ReadString('TextFile', '');
      if fileName = '' then
        InitialDir  :=  FMyDocPath
      else
        begin
        InitialDir    :=  ExtractFileDir(FileName);
        FileName      :=  ExtractFileName(FileName);
        end;
      DefaultExt := 'TXT';
      Filter := 'Text files (*.txt)|*.txt';
      FilterIndex := 1;
//      FileName := OptionsData.Callsign + '.TXT';
      if not Execute then
        Exit;
      XmlIni.WriteString('TextFile', FileName);
      XmlIni.CloseNode;
      XmlIni.UpdateFile;
      ExpFileName := FileName;
      end;
    with ProgDlg do
      begin
      Title    := 'Textファイルへのエクスポート';
      Caption1 := '少しお待ちください。';
      Caption2 := '';
      Show;
      end;
    Screen.Cursor := crHourGlass;
    SimplifycdsQsoLogSel();
    cdsQsoLogSel.DisableControls;
    Engine.dsQsoLogSel.Dataset.GetFieldNames(sl);   //  フィールド名を出力する。
    ExpStream.Add(sl.CommaText);
    with dsQsoLogSel.Dataset do                     //  データを出力する。
      begin
      DisableControls;
      Last;
      ProgDlg.Max := RecordCount;
      First;
      while Not EOF do
        begin
        sl.Clear;
        for i := 0 to dsQsoLogSel.Dataset.FieldCount - 1 do
          begin
          if Fields[i].DataType = ftDateTime then
            begin
            if Fields[i].asString = '' then
              sl.Add('')
            else
              sl.Add(FormatDateTime('yyyy/mm/dd hh:nn',Fields[i].asDateTime + Bias))
            end
          else if Fields[i].DataType = ftDate then
            begin
            if Fields[i].asString = '' then
              sl.Add('')
            else
              sl.Add(FormatDateTime('yyyy/mm/dd',Fields[i].AsDateTime))
            end
          else
            sl.Add(Fields[i].asString);
          end;
        ExpStream.Add(sl.CommaText);
        ProgDlg.StepIt;
        Next;
        end;
      EnableControls;
      First;
      end;
    ProgDlg.Close;
    ExpStream.SaveToFile(ExpFileName,TEncoding.UTF8);

    Screen.Cursor := crDefault;
    ModifycdsQsoLogSel();
    cdsQsoLogSel.EnableControls;
    s := Format('Text Fileのエクスポートが完了しました。' + #13#10
       + 'レコード件数=%d', [ExpStream.Count-1]);
    MessageDlg(s, mtInformation, [mbOk], 0);
  finally
    FreeAndNil(XmlIni);
    FreeAndNil(SaveDlg);
    FreeAndNil(ProgDlg);
    FreeAndNil(sl);
    FreeAndNil(ExpStream);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//     HAMLOG用のCSVファイルを出力する
//
////////////////////////////////////////////////////////////////////////////////
procedure TEngine.ExportHamLogCVS();
  var
    s: string;
    Qsl,QslSend,QslRecv: string;
    dt: TDateTime;
    sl: TStringList;
    ExpFileName: string;
    ExpStream: TStringList;
    ProgDlg: TProgressDlg;
    RegionRec: TRegionRec;
    EntityRec: TEntityRec;
    SaveDialog1:      TSaveDialog;
    XmlIni: TXmlInifile;
    HamlogQslList: TStringList;
  begin
    sl  :=  TStringList.Create;
    HamlogQslList  :=  TStringList.Create;
    ExpStream :=  TStringList.Create;
    ProgDlg   := TProgressDlg.Create(self);
    SaveDialog1 := TSaveDialog.Create(Self);
    XmlIni    := TXmlIniFile.Create(FXmlIniFileName);
    try
      GetHamlogQslList(HamLogQslList);    // HAMLOGのQSLマークを置き換える為
      with SaveDialog1 do
        begin
        Title := 'Export File';
        XmlIni.OpenNode('File', true);
        FileName    := XmlIni.ReadString('HAMLOG', '');
        if FileName = '' then
          begin
          InitialDir  :=  FMyDocPath;
          FileName    := FOptionsData.Callsign + '.CSV';
          end
        else
          begin
          InitialDir    :=  ExtractFileDir(FileName);
          FileName      :=  ExtractFileName(FileName);
          end;
        DefaultExt := 'CSV';
        Filter := 'Hamlog CSV files (*.CSV)|*.CSV|all files (*.*)|*.*';
        FilterIndex := 1;
        if not Execute then
          Exit;
        XmlIni.WriteString('HAMLOG', FileName);
        XmlIni.CloseNode;
        XmlIni.UpdateFile;
        ExpFileName := FileName;
        end;
      with ProgDlg do
        begin
        Title    := 'HAMLOGファイルへのエクスポート';
        Caption1 := '少しお待ちください。';
        Caption2 := '';
        Show;
        end;

      Screen.Cursor := crHourGlass;
      SimplifycdsQsoLogSel();
      cdsQsoLogSel.DisableControls;
      with dsQsoLogSel.Dataset do
        begin
        Last;
        ProgDlg.Max := RecordCount;
        First;
        while Not EOF do
          begin
          sl.Clear;
          sl.Add(FieldByName('Callsign').asString);
          if FieldByName('Country').asString = 'JPN' then
            begin
            DT := FieldByName('OnDateTime').asDateTime + FTimeZoneBiasD;
            sl.Add(FormatDateTime('yy/mm/dd', dt));
            sl.Add(FormatDateTime('hh:mm', dt)+'J');
            end
          else
            begin
            sl.Add(FormatDateTime('yy/mm/dd',FieldByName('OnDateTime').asDateTime));
            sl.Add(FormatDateTime('hh:mm',FieldByName('OnDateTime').asDateTime)+'U');
            end;
          sl.Add(FieldByName('HisReport').asString);
          sl.Add(FieldByName('MyReport').asString);
          sl.Add(FloatToStr(FieldByName('Freq').AsLargeInt / kMhz));
          sl.Add(FieldByName('Mode').asString);
          if FieldByName('Entity').asString = 'JA' then
            sl.Add(FieldByName('Region').asString)
          else
            begin
            if CheckEntity(FieldByName('Entity').asString, EntityRec) then
              sl.Add(EntityRec.HamLog)
            else
              sl.Add('')
            end;
          sl.Add(FieldByName('GridLoc').asString);

          Qsl     :=  FieldByName('Qsl').asString;
          QslSend :=  FieldByName('QslSend').asString;
          QslRecv :=  FieldByName('QslRecv').asString;
          if Qsl      = HamLogQslList.ValueFromIndex[0]   then
            Qsl         := HamLogQslList.Names[0];
          if QslSend  = HamLogQslList.ValueFromIndex[1] then
            QslSend     := HamLogQslList.Names[1];
          if QslRecv  = HamLogQslList.ValueFromIndex[2] then
            QslRecv     := HamLogQslList.Names[2];
          Qsl :=  Copy(Qsl + ' ', 1, 1);
          QslSend :=  Copy(QslSend + ' ', 1, 1);
          QslRecv :=  Copy(QslRecv + ' ', 1, 1);
          sl.Add(Qsl + QslSend + QslRecv);

          sl.Add(Copy(FieldByName('Name').asString, 1, 12));
          if FieldByName('Country').asString = 'JPN' then
            if CheckRegion(FieldByName('Country').asString, FieldByName('Region').asString, RegionRec) then
              sl.Add(RegionRec.Name)
            else
              sl.Add('')
          else
            sl.Add(EntityRec.Name);
          s := StringReplace(FieldByName('Memo').asString, ',', ' ', [rfReplaceAll]);
          s := StringReplace(s, #13#10, ' ', [rfReplaceAll]);
          s := Copy(s, 1, 48);
          sl.Add(s);
          s := StringReplace(FieldByName('MyMemo').asString, ',', ' ', [rfReplaceAll]);
          s := StringReplace(s, #13#10, ' ', [rfReplaceAll]);
          s := Copy(s, 1, 48);
          sl.Add(s);
          sl.Add('');
          ExpStream.Add(sl.CommaText);
          ProgDlg.StepIt;
          Next;
          end;
        First;
        end;
      ExpStream.SaveToFile(ExpFileName);    // Shift-Jis出力
      ProgDlg.Close;
      ModifycdsQsoLogSel();
      cdsQsoLogSel.EnableControls;
      Screen.Cursor := crDefault;
      s := Format('Hamlog''s CSVのエクスポートが完了しました。' + #13#10
         + 'レコード件数=%d', [ExpStream.Count]);
      MessageDlg(s, mtInformation, [mbOk], 0);
    finally
      FreeAndNil(XmlIni);
      FreeAndNil(sl);
      FreeAndNil(HamlogQslList);
      FreeAndNil(ExpStream);
      FreeAndNil(ProgDlg);
      FreeAndNil(SaveDialog1);
    end;
  end;

////////////////////////////////////////////////////////////////////////////////
//
//     Qslデータ for MMQSL用のCSVファイルを出力する
//
////////////////////////////////////////////////////////////////////////////////
procedure TEngine.ExportQslData();
var
  b: boolean;
  s: string;
  sl: TStringList;
  ExpFileName: string;
  ExpStream:    TStringList;
  ProgDlg:      TProgressDlg;
  SaveDialog1:  TSaveDialog;
  XmlIni:       TXmlInifile;
begin
  sl          := TStringList.Create;
  ExpStream   := TStringList.Create;
  SaveDialog1 := TSaveDialog.Create(self);
  ProgDlg     := TProgressDlg.Create(self);
  XmlIni      := TXmlIniFile.Create(FXmlIniFileName);
  try
    with SaveDialog1 do
      begin
      Title := 'Export Txt File for MMQSL';
      XmlIni.OpenNode('File', true);
      FileName    := XmlIni.ReadString('MMQSL', '');
      if FileName = '' then
        begin
        InitialDir  :=  FMyDocPath;
        FileName := FOptionsData.Callsign + ' QSL.Txt';
        end
      else
        begin
        InitialDir    :=  ExtractFileDir(FileName);
        FileName      :=  ExtractFileName(FileName);
        end;
      DefaultExt := 'Txt';
      Filter := 'CSV files (*.Txt)|*.Txt|all files (*.*)|*.*';
      FilterIndex := 1;
      if not Execute then
        Exit;
      XmlIni.WriteString('MMQSL', FileName);
      XmlIni.CloseNode;
      XmlIni.UpdateFile;
      ExpFileName := FileName;
      end;
    with ProgDlg do
      begin
      Title    := 'MMQSLファイルへのエクスポート';
      Caption1 := '少しお待ちください。';
      Show;
      end;

    Screen.Cursor := crHourGlass;
    SimplifycdsQsoLogSel();
    cdsQsoLogSel.DisableControls;
    with dsQsoLogSel.DataSet do
      begin
      Last;
      ProgDlg.Max := RecordCount;
      First;
      while Not EOF do
        begin
        s := Trim(FieldByName('Qsl').AsString);
        b := (s = 'N') or (s = '1') or (s = '') or (FieldByName('QslSend').asString = 'S');   // QSL印刷不要の判断
        if not b then
          begin
          s  :=  FormationgQslData(dsQsoLogSel.DataSet.Fields);
          if s <> '' then
            ExpStream.Add(s);
          end;
        ProgDlg.StepIt;
        Next;
        end;
      First;
      end;
    ExpStream.SaveToFile(ExpFileName);
    ProgDlg.Close;
    ModifycdsQsoLogSel();
    cdsQsoLogSel.EnableControls;
    Screen.Cursor := crDefault;
    s := Format('QSL Print Data CSVのエクスポートが完了しました。' + #13#10
       + 'レコード件数=%d', [ExpStream.Count]);
    MessageDlg(s, mtInformation, [mbOk], 0);
  finally
    FreeAndNil(XmlIni);
    FreeAndNil(ProgDlg);
    FreeAndNil(sl);
    FreeAndNil(ExpStream);
    FreeAndNil(SaveDialog1);
  end;
end;

function TEngine.FormationgQslData(Rec: TFields): string;
var
  s,t: string;
  DT: TDateTime;
  sl: TStringList;
  MyCountry: string;
  MyRegion: string;
  RegionRec: TRegionRec;
begin
  result  :=  '';
  sl  :=  TStringList.Create;
  try
    sl.Clear;
    with Rec do
      begin
      if TryStrToDateTime(FieldByName('OnDateTime').AsString, DT) then
        begin
        dt := dt + Engine.TimeZoneBiasD;        // MMQSLはLocalTimeしか扱わない為 JSTで出力
        sl.Add(FormatDateTime('yy.mm.dd', DT)); // 年月日
        sl.Add(FormatDateTime('hhnn',  DT));    // 時刻
        end
      else
        begin
        sl.Add('');
        sl.Add('');
        s := format('日付の形式が誤り Num=%d, Callsign=%s',
               [FieldByName('Num').AsInteger,FieldByName('Callsign').AsString]);
        MessageDlg(s,mtError,[mbYes],0);
        end;
      sl.Add(FieldByName('Callsign').AsString);     // Callsign
      sl.Add(FieldByName('HisReport').AsString);    // His Report
      sl.Add(FloatToStr(FieldByName ('Freq').AsFloat / kMHz));  // 周波数 MHｚ単位で
      sl.Add(FieldByName('Mode').AsString);         // Mode
      sl.Add('');                                   // Power
      sl.Add(FieldByName('Name').AsString);         // 名前
      sl.Add('');                                   // QTH
      t := '';                                      // 以下はQSLの内容
      begin
        if FieldByName('QslManager').AsString <> '' then     // QSL Manager
          t := t + '@' + FieldByName('QslManager').AsString + ' ';
        t := t + 'Num[' + IntToStr(FieldByName('Num').AsInteger) + '] '; // Num LogBaseのレコード番号
        if UpperCase(FieldByName('Route').AsString) = 'SATELLITE' then   // サテライト通信のとき
          begin
          t := t + 'Satellite[' + FieldByName('Repeater').AsString + '] ';    // サテライト名　衛星名
          t := t + 'LinkFreq['
            + FormatFloat('0', FieldByName('Freq').AsFloat / kMHz) + '/'      //　アップリンク・ダウンリンク周波数
            + FormatFloat('0', FieldByName('RecvFreq').AsFloat / kMHz) + '] ';
          t := t + 'LinkBand['
            + FormatFloat('0', FieldByName('Band').AsFloat / kMHz) + '/'      //　アップリンク・ダウンリンクバンド
            + FormatFloat('0', FieldByName('RecvBand').AsFloat / kMHz) + '] ';
          end;
        if FieldByName('Memo').AsString <> '' then                            //　メモの内容をそのまま出力
          t := t + Trim(FieldByName('Memo').AsString) + ' ';
        if FieldByName('MyMemo').AsString <> '' then
          begin
          t := t + FieldByName('MyMemo').AsString + ' ';    // Myメモの内容をそのまま出力
          t := t + 'MyMemo[' + FieldByName('MyMemo').AsString + '] ';    // Myメモの内容を[ ]で出力
          end;
        if FieldByName('MyCallsign').AsString <> '' then                      //　以下、マイデータの内容
          t := t + 'MyCallsign[' + FieldByName('MyCallsign').AsString + '] ';
        if FieldByName('MyGridLoc').AsString <> '' then
          t := t + 'MyGridLoc[' + FieldByName('MyGridLoc').AsString + '] ';
        if FieldByName('MyRegion').AsString <> '' then
          begin
          MyCountry := FieldByName('MyCountry').AsString;
          MyRegion  := FieldByName('MyRegion').AsString;
          t := t + 'MyCountry[' + MyCountry + '] ';
          t := t + 'MyRegion[' + MyRegion + '] ';
          if Engine.CheckRegion(MyCountry, MyRegion, RegionRec) then          //　MyRegionからRegion名に変換して出力
            t := t + 'MyQTH[' + RegionRec.Name + '] ';
          if MyCountry = 'JPN' then
            begin
            if (Length(MyRegion) = 4)
            or ((Length(MyRegion) = 6) and (Copy(MyRegion, 6, 1) <= '9')) then
              t := t + 'MyJCC[' + MyRegion + '] ';
            if (Length(MyRegion) = 5)
            or ((Length(MyRegion) >= 6) and (Copy(MyRegion, 6, 1) >=  'A')) then
              t := t + 'MyJCG[' + MyRegion + '] ';
            end;
          end;
        if FieldByName('MyRig').AsString <> '' then
          t := t + 'MyRig[' + FieldByName('MyRig').AsString + '] ';
        if FieldByName('MyAnt').AsString <> '' then
          t := t + 'MyAnt[' + FieldByName('MyAnt').AsString + '] ';
        if FieldByName('SWL').AsInteger = kTrue then
          t := t + 'SWL[] ';
        end;
      sl.Add(t);                                // QSL  実際には、多種のデータを詰められる
      sl.Add(Trim(FieldByName('QslSend').AsString));  // Send 送り
      sl.Add(Trim(FieldByName('QslRecv').AsString));  // Recv 受け　
      sl.Add(FieldByName('MyRegion').AsString); // Env 複数QSOを1枚のQSLカードに印刷するとき、自局に移動先によって改ページする
      result  :=  sl.CommaText;
    end;
  finally
    FreeAndNil(sl);
  end;
end;

// MMQSL用のSendMark設定処理
procedure TEngine.MarkingQslSend();
  var
    i, n: integer;
    s: string;
    InpFile1Name:  string;
    InpFile2Name:  string;
    sl: TStringList;
    Inp1Stream:   TStringList;
    Inp2Stream:   TStringList;
    ProgDlg:      TProgressDlg;
    XmlIni:       TXmlInifile;
    Brx:          TSkRegExp;
    Title: string;
    FileName: string;
    DefaltFolder: string;
    Filter: string;
  begin
    sl          := TStringList.Create;
    Inp1Stream  := TStringList.Create;
    Inp2Stream  := TStringList.Create;
    ProgDlg     := TProgressDlg.Create(self);
    XmlIni      := TXmlIniFile.Create(FXmlIniFileName);
    Brx := TSkRegExp.Create;
    n := 0;  // コンパイル時の警告のため
    try
      Brx.Expression := 'Num\[([0-9]+)\]';

      Title         := 'Append Txt File for MMQSL';
      XmlIni.OpenNode('File', true);
      FileName      := XmlIni.ReadString('MMQSL', '');
      DefaltFolder  :=  FMyDocPath;
      Filter        := 'CSV files (*.Txt)|*.Txt|all files (*.*)|*.*';
      if GetOpenFileName(self, Title, DefaltFolder, Filter, FileName)  then
        begin
        XmlIni.WriteString('MMQSL', FileName);
        XmlIni.CloseNode;
        XmlIni.UpdateFile;
        InpFile1Name := FileName;
        end
      else
        exit;

      InpFile2Name := ChangeFileExt(InpFile1Name, '.MMQ');
      with ProgDlg do
        begin
        Title    := 'MMQSLファイルのインポート';
        Caption1 := '少しお待ちください。';
        ProgDlg.Show;
        end;
      Screen.Cursor := crHourGlass;
      Inp1Stream.LoadFromFile(InpFile1Name);
      Inp2Stream.LoadFromFile(InpFile2Name);
      ProgDlg.Max  :=  Inp1Stream.Count;
      for i := 0 to Inp2Stream.Count - 1 do
        begin
        s := Inp1Stream[StrToInt(Inp2Stream[i]) - 1];
        if Brx.Exec(s) then
          n := StrToInt('0' + Brx.Groups[1].Strings);
        UpdateQslSend(n, QslSendDefault);
        ProgDlg.StepIt;
        end;
      ProgDlg.Close;
      Screen.Cursor := crDefault;
      s := Format('MMQSL Print Data のインポートが完了しました。' + #13#10
         + 'レコード件数=%d', [Inp1Stream.Count]);
      MessageDlg(s, mtInformation, [mbOk], 0);
    finally
      FreeAndNil(sl);
      FreeAndNil(XmlIni);
      FreeAndNil(ProgDlg);
      FreeAndNil(Inp1Stream);
      FreeAndNil(Inp2Stream);
      FreeAndNil(Brx);
    end;
  end;

////////////////////////////////////////////////////////////////////////////////
//
//     NetLog用のSendMark設定処理
//
////////////////////////////////////////////////////////////////////////////////
procedure TEngine.MarkingNetLogSend();
var
  s: string;
  i: integer;
  NetLog: string;

  sl: TStringList;
  NetLogDlg:  TNetLogDlg;
  ProgDlg:  TProgressDlg;
  XmlIni:   TXmlInifile;
begin
  sl          := TStringList.Create;
  NetLogDlg   := TNetLogDlg.Create(Self);
  ProgDlg     := TProgressDlg.Create(Application);
  XmlIni      := TXmlIniFile.Create(FXmlIniFileName);
  try
    if NetLogDlg.ShowModal <> mrOk then
      exit;
    NetLog := NetLogDlg.result;
    if NetLog = '' then
      exit;

    with ProgDlg do
      begin
      Title    := 'NetLogのマーク中';
      Caption1 := '少しお待ちください。';
      Max :=  cdsQsoLogSel.RecordCount;
      Show;
      end;

//  ここからマーク処理
    Screen.Cursor := crHourGlass;
    SimplifycdsQsoLog;
    cdsQsoLog.DisableControls;
    SimplifycdsQsoLogSel;
    cdsQsoLogSel.DisableControls;
    i := 0;
    dsQsoLogSel.DataSet.First;
    while not dsQsoLogSel.DataSet.Eof do
      begin
      sl.CommaText := dsQsoLogSel.DataSet.FieldByName('NetLogSend').AsString;
      if sl.IndexOf(NetLog) = -1 then
        begin
        Inc(i);
        dsQsoLogSel.DataSet.Edit;
        sl.Add(NetLog);
        sl.Sort;
        dsQsoLogSel.DataSet.FieldByName('NetLogSend').AsString := sl.CommaText;
        dsQsoLogSel.DataSet.Post;
        end;
      dsQsoLogSel.DataSet.Next;
      end;
    ProgDlg.Caption1 := '更新を適用中です。少しお待ちください。';
    Application.ProcessMessages;
    if dsQsoLogSel.DataSet = cdsQsoLogSel then
      cdsQsoLogSel.ApplyUpdates(1);
    ProgDlg.Close;
    Screen.Cursor := crDefault;
    ModifycdsQsoLog;
    dsQsoLogSel.DataSet.EnableControls;
//    ModifycdsQsoLogSel;
//    dsQsoLogSel.DataSet.EnableControls;
//    dsQsoLogSel.DataSet;
    s := format('NetLogのマーク処理が完了しました。' + #13#10
       + 'レコード件数=%d',  [i]);
    MessageDlg(s, mtInformation, [mbOk], 0);
  finally
    FreeAndNil(sl);
    FreeAndNil(NetLogDlg);
    FreeAndNil(ProgDlg);
    FreeAndNil(XmlIni);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//     ADIFを読んで、NetLogRecvを更新する
//
////////////////////////////////////////////////////////////////////////////////
procedure TEngine.MarkingNetLogRecv();
var
  s: string;

  InpRecCnt: Integer;
  InpExName: string;
  ErrExName: string;
  ErrFile: TStringList;
  ErrMsg: string;

  adif: tstringlist;

  ProgressDlg:  TProgressDlg;
  XmlIni: TXmlInifile;
  Adx: TAdx;
  BandList:   TStringList;
  NetLogDlg:  TNetLogDlg;
  wNetLog: string;

  Title: string;
  DefaltFolder: string;
  Filter: string;
  Event: TDataSetNotifyEvent;
begin
  ProgressDlg := TProgressDlg.Create(self);
  XmlIni      := TXmlInifile.Create(FXmlIniFileName);
  Adx         := TAdx.Create;
  ErrFile     := TStringList.Create;
  BandList    := TStringList.Create;
  NetLogDlg   := TNetLogDlg.Create(Self);

  adif := Tstringlist.Create;
  try
    s := 'マーキングの前に、ログデータのバックアップしてください。'#13
       + 'このまま続けますか？';
    if MessageDlg(s, mtConfirmation, [mbYes,mbNo],0) = mrNo then
      exit;

    XmlIni.OpenNode('File', true);
    InpExName     := XmlIni.ReadString('UpdateADIF', '');
    Title         := 'Update NetLog from ADIF/ADF';
    DefaltFolder  := FMyDocPath;
    Filter        := 'ADIF/ADX files (*.adi)(*.adx)|*.adi;*adx';
    if GetOpenFileName(self, Title, DefaltFolder, Filter, InpExName)  then
      begin
      XmlIni.WriteString('UpdateADIF', InpExName);
      XmlIni.CloseNode;
      XmlIni.UpdateFile;
      if UpperCase(ExtractFileExt(InpExName)) = '.ADX' then
        Adx.LoadAdx(InpExName)
      else
        begin
        Adx.LoadAdif(InpExName);
        end;
      end
    else
      exit;

    if NetLogDlg.ShowModal <> mrOk then
      exit;
    wNetLog := NetLogDlg.result;
    if wNetLog = '' then
      exit;

    with ProgressDlg do
      begin
      Title     := 'ADID/ADXからNetLogのMarkup';
      Caption1  := 'NetLog Markup';
      ProgressDlg.Min := 0;
      ProgressDlg.Max := Adx.AdxRecords.Count div 3; // 正しいレコード数が得られない?
      Show;
      end;

    GetBandList('Band_M', 'Band', BandList);     // Band変換用リスト(m→Hz)の作成
    BandList.CaseSensitive := false;
    BandList.Sort;

    s := 'SELECT Callsign, QSLRECV, ONDATETIME FROM QSOLOG '
      +  'WHERE (Callsign = :Callsign) and (QSLRECV <> '''');';
    with qryQsoLog2 do
      begin
      Close;
      Sql.Clear;
      Sql.Add(s);
    end;

    s := 'SELECT SUFFIX, QSLRECV, ONDATETIME FROM QSOLOG '
      +  'WHERE (SUFFIX = :suffix) AND (QSLRECV = ''R'') AND (ONDATETIME >= ''1997/7/15'');';
    with qryQsoLog do
      begin
      Close;
      Sql.Clear;
      Sql.Add(s);
    end;

    cdsQsoLog.DisableControls;
    Event   := cdsQsoLog.OnCalcFields;
    cdsQsoLog.OnCalcFields  := nil;
    InpRecCnt := 0;

    if Adx.First(aeRecords) then
      repeat
        ProgressDlg.StepIt;
        Inc(InpRecCnt);
        MarkingNetLogRecv_Sub(InpRecCnt, Adx, wNetLog, ErrMsg, BandList);
        if ErrMsg <> '' then
          ErrFile.Add(ErrMsg);                //  対象レコード無　又は　複数
      until not Adx.Next(aeRecords);

    cdsQsoLog.ApplyUpdates(1);
    trnLogBase.Commit;
    Application.ProcessMessages;
    ProgressDlg.Close;
    cdsQsoLog.Filtered := false;
    cdsQsoLog.Last;
    cdsQsoLog.OnCalcFields  := Event;
    cdsQsoLog.EnableControls;

    s := 'ADIF/ADXからのマーキングが完了しました。' + #13#10
       + 'レコード件数=' + IntToStr(InpRecCnt);
    MessageDlg(s, mtInformation, [mbOk], 0);

    if ErrFile.Count <> 0 then
      begin
      ErrFile.Insert(0,'No.,Action,Callsign,OnDateTime(UTC),OnDateTime(Local),Band,Mode');
      ErrExName :=  ChangeFileExt(InpExName, '') + '.csv';
      ErrFile.SaveToFile(ErrExName);
      s := 'ADIF/ADXからのマーキングに警告があります。' + #13#10
         + 'レコード件数=' + IntToStr(ErrFile.Count);
      MessageDlg(s, mtInformation, [mbOk], 0);
      end;
  finally
    qryQsoLog.Close;
    qryQsoLog2.Close;
    FreeAndNil(ProgressDlg);
    FreeAndNil(XmlIni);
    FreeAndNil(Adx);
    FreeAndNil(ErrFile);
    FreeAndNil(BandList);
    FreeAndNil(NetLogDlg);
    freeAndNil(adif);
  end;
end;

function TEngine.MarkingNetLogRecv_Sub(Num: Integer; Adx: TAdx; NetLogMark: string; var ErrMsg: string; BandList: TStringList): boolean;
type TUpdateState = (usNone, usNotFound, usUpdate, usNewCallsign, usNewJCA);
var
  s: string;
  NetLogRecvList: TstringList;
  wCallsign: string;
  wOnDate: string;
  wOnTime: string;
  wBand: string;
  wBand_I: Integer;
  wMode: string;
  wOnDateTime: TDateTime;
  wOnLocalDateTime: TDateTime;
  wFmOnDateTime: string;
  wToOnDateTime: string;
  wQslRecv: string;
  wNetLogRecv: string;
  wSatellite: string;
  ErrRecFormat: string;
  UpdateState: TUpdateState;
  sFilter: string;
  function CheckNewJCA(Suffix: string; DateTime: TDateTime): boolean;
  begin
    result := false;
    if DateTime <  StrToDateTime('1997/7/15') then
      exit;
    qryQsoLog.Close;
    qryQsoLog.ParamByName('SUFFIX').AsString := suffix;
    qryQsoLog.Open;
    if qryQsoLog.RecordCount = 0 then
      result := true;
  end;
  function CheckNewStation(Callsign: string): boolean;
  begin
    result := false;
    qryQsoLog2.Close;
    qryQsoLog2.ParamByName('Callsign').AsString := Callsign;
    qryQsoLog2.Open;
    qryQsoLog2.Last;
    if qryQsoLog2.RecordCount = 0 then
      result := true;
  end;

begin
  result  := true;
  ErrMsg  := '';

  NetLogRecvList  := TstringList.Create;
  try
    Adx.Find(aeRecord, 'CALL', wCallsign);
    Adx.Find(aeRecord, 'QSO_DATE', wOnDate);
    Adx.Find(aeRecord, 'TIME_ON', wOnTime);
    Adx.Find(aeRecord, 'BAND', wBand);
    if Adx.Find(aeRecord, 'SATELLITE', wSatellite) then
      if wSatellite <> '' then
        Adx.Find(aeRecord, 'BAND_RX', wBand);
    Adx.Find(aeRecord, 'MODE', wMode);
    wOnDate := Copy(wOnDate,1,4) + '/' + Copy(wOnDate,5,2) + '/' + Copy(wOnDate,7, 2);
    wOnTime := Copy(wOnTime,1,2) + ':' + Copy(wOnTime,3,2);
    if TryStrToDateTime(wOnDate + ' ' + wOnTime, wOnDateTime) then
      begin
      wOnLocalDateTime := wOnDateTime + FTimeZoneBiasD;
      wFmOnDateTime := FormatDateTime('yyyy/mm/dd hh:nn', wOnDateTime - 1/144); // 10分間ルール用
      wToOnDateTime := FormatDateTime('yyyy/mm/dd hh:nn', wOnDateTime + 1/144);
      end
    else
      begin
      wFmOnDateTime := '';
      wToOnDateTime := '';
      end;
    wBand_I     := StrToInt('0' + BandList.Values[wBand]);

    ErrRecFormat := '%d,%s,%s,%s,%s,%s,%s';
    sFilter := '(Callsign = ''%s'') AND (OnDateTime >= ''%s'') AND (OnDateTime <= ''%s'') '
          + ' AND (Band=%d) AND (Mode=''%s'')';
    cdsQsoLog.Filter := format(sFilter, [wCallsign, wFmOnDateTime, wToOnDateTime, wBand_I, wMode]);
    cdsQsoLog.Filtered := true;

    UpdateState := usNone;
    if cdsQsoLog.RecordCount = 1 then
      begin
//      cdsQsoLog.Filtered := false;
      wQslRecv    := Trim(cdsQsoLogQslRecv.asString);
      NetLogRecvList.CommaText := Trim(cdsQsoLogNetLogRecv.asString);
      if NetLogRecvList.IndexOf(NetLogMark) = -1  then
        begin
        NetLogRecvList.Add(NetLogMark);
        NetLogRecvList.Sort;
        wNetLogRecv  := NetLogRecvList.CommaText;
        UpdateState := usUpdate;
        end;
      if (wQslRecv = '') then   //eQSL用の判断
        begin
        if (NetLogMark = 'E') and CheckNewJCA(cdsQsoLogSuffix.AsString, cdsQsoLogOnDateTime.AsDateTime) then
          begin
          UpdateState := usNewJCA;
          wQslRecv    := NetLogMark;
          end
        else if CheckNewStation(cdsQsoLogCallsign.AsString)  then
          begin
          UpdateState := usNewCallsign;
          wQslRecv    := NetLogMark;
          end;
        end;

      s  := '';
      case UpdateState of
      usUpdate:       s := 'Update';
      usNewCallsign:  s := 'NewStation';
      usNewJCA:       s := 'NewJCA';
      end;

      if UpdateState >= usUpdate then                 //  更新処理 をする
        begin
        cdsQsoLog.Edit;
        cdsQsoLog.FieldByName('QslRecv').asString     := wQslRecv;
        cdsQsoLog.FieldByName('NetLogRecv').asString  := wNetLogRecv;
        cdsQsoLog.Post;
        cdsQsoLog.ApplyUpdates(1);
        ErrMsg := format(ErrRecFormat, [Num, s, wCallsign, formatDateTime('yyyy/mm/dd hh:nn', wOnDateTime),
                             formatDateTime('yyyy/mm/dd hh;nn', wOnLocalDateTime), wBand, wMode]);
        end;
      end
    else
      begin
        ErrMsg := format(ErrRecFormat, [Num, 'NotFound', wCallsign, formatDateTime('yyyy/mm/dd hh:nn', wOnDateTime),
                             formatDateTime('yyyy/mm/dd hh;nn', wOnLocalDateTime), wBand, wMode]);
      end;
  finally
    FreeAndNil(NetLogRecvList);
  end;
end;

end.


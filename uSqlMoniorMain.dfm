object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'IB SQL Monitor'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 635
    Height = 258
    Align = alClient
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
    ExplicitTop = 80
    ExplicitHeight = 219
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 1
    object Button1: TButton
      Left = 24
      Top = 8
      Width = 81
      Height = 25
      Caption = 'Clear'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object IBSQLMonitor1: TIBSQLMonitor
    OnSQL = IBSQLMonitor1SQL
    TraceFlags = [tfQPrepare, tfQExecute, tfQFetch, tfError, tfStmt, tfConnect, tfTransact, tfBlob, tfService, tfMisc]
    Left = 176
    Top = 136
  end
end

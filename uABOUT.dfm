object AboutBox: TAboutBox
  Left = 200
  Top = 108
  BorderStyle = bsDialog
  Caption = #12496#12540#12472#12519#12531#24773#22577
  ClientHeight = 213
  ClientWidth = 324
  Color = clCream
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 9658155
  Font.Height = -11
  Font.Name = #12513#12452#12522#12458
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 308
    Height = 161
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 0
    object ProgramIcon: TImage
      Left = 20
      Top = 16
      Width = 32
      Height = 32
      AutoSize = True
      Picture.Data = {
        055449636F6E0000010001002020100000000000E80200001600000028000000
        2000000040000000010004000000000080020000000000000000000000000000
        0000000000000000000080000080000000808000800000008000800080800000
        80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
        FFFFFF00FFFBBBBBBBBBBBBBBBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCBCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCBCFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFCBCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCBCFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFCBCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCBCFFFCCCCCFFFCCCCFFCCCFFF
        CCCFFFCBCFFFCCFFFCFCFFFCFCFFFCFCFFFCFFCBCFFFCCFFFCFCFFFCFFFCCFFC
        FFFFFFCBCFFFCCFFFCFFCCCCFFCFFFFCCCCCFFCBCFFFCCCCCFFFFFFCFCFFFCFC
        FFFCFFCBCFFFCCFFFCFFCCCFFFCCCFFFCCCFFFCBCFFFCCFFFCFFFFFFFFFFFFFF
        FFFFFFCBCFFFCCFFFCFFFFFFFFFFFFFFFFFFFFCBCFFFCCCCCFFFFFFFFFFFFFFF
        FFFFFFCBCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCBCFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFCBCFFFFFFFFFFFFCCFFFFFFFFFFFFFFFCBCFFFCCFFFFCCCFFFCCCFFCCC
        CCCCFFCBCFFCFFCFFCFFCCFFCFFCFFCFFFFCFFCBCFFCFFFFCFCCFFCFFFFCFFCF
        FFFFFFCBCFFCCCCFCFFFFFCFFFFCFFCFFFFFFFCBCFFCFFCFCFFFFFCFFCCFFFCF
        FFFFFFCBCFFFCCFFCFFFFFCFCFFFFFCFFFFFFFCBCFFFFFFFCFFFFFCFCFFFFFCF
        FFFFFFCBCFFFFFFFFCFFFCFFCFFCFFCFFFFFFFCBCFFFFFFFFFCCCFFFFCCCFCCC
        FFFFFFCBCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCBCFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFCBCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCCCCCCCCCCCCCCCCCCCCCCCC
        CCCCCCCF00000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000}
      Stretch = True
      IsControl = True
    end
    object ProductName: TLabel
      Left = 88
      Top = 16
      Width = 42
      Height = 17
      Caption = #35069#21697#21517': '
      IsControl = True
    end
    object Version: TLabel
      Left = 88
      Top = 40
      Width = 55
      Height = 17
      Caption = #12496#12540#12472#12519#12531
      IsControl = True
    end
    object Copyright: TLabel
      Left = 8
      Top = 80
      Width = 53
      Height = 17
      Caption = 'Copyright'
      IsControl = True
    end
    object Comments: TLabel
      Left = 8
      Top = 101
      Width = 65
      Height = 16
      AutoSize = False
      Caption = #12467#12513#12531#12488
      WordWrap = True
      IsControl = True
    end
    object lblProductName: TLabel
      Left = 154
      Top = 16
      Width = 87
      Height = 17
      Caption = 'lblProductName'
    end
    object lblVersion: TLabel
      Left = 154
      Top = 40
      Width = 53
      Height = 17
      Caption = 'lblVersion'
    end
    object lblCopyRight: TLabel
      Left = 79
      Top = 80
      Width = 69
      Height = 17
      Caption = 'lblCopyRight'
    end
    object lblComment: TLabel
      Left = 79
      Top = 101
      Width = 66
      Height = 17
      Caption = 'lblComment'
    end
    object CompanyName: TLabel
      Left = 8
      Top = 123
      Width = 33
      Height = 17
      Caption = #20316#25104#32773
      WordWrap = True
      IsControl = True
    end
    object lblCompanyName: TLabel
      Left = 79
      Top = 123
      Width = 95
      Height = 17
      Caption = 'lblCompanyName'
    end
  end
  object OKButton: TButton
    Left = 127
    Top = 180
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = OKButtonClick
  end
end

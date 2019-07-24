object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Login'
  ClientHeight = 154
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object edtUsername: TLabeledEdit
    Left = 80
    Top = 24
    Width = 137
    Height = 21
    EditLabel.Width = 48
    EditLabel.Height = 13
    EditLabel.Caption = 'Username'
    LabelPosition = lpLeft
    LabelSpacing = 5
    TabOrder = 0
    OnExit = edtUsernameExit
  end
  object edtPassword: TLabeledEdit
    Left = 80
    Top = 51
    Width = 137
    Height = 21
    EditLabel.Width = 46
    EditLabel.Height = 13
    EditLabel.Caption = 'Password'
    LabelPosition = lpLeft
    LabelSpacing = 5
    PasswordChar = '*'
    TabOrder = 1
    OnExit = edtPasswordExit
  end
  object btnLogin: TButton
    Left = 24
    Top = 101
    Width = 89
    Height = 33
    Caption = 'Login'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 128
    Top = 101
    Width = 89
    Height = 33
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object cbxAutoLogin: TCheckBox
    Left = 80
    Top = 78
    Width = 89
    Height = 17
    Caption = 'Auto Login'
    TabOrder = 4
  end
end

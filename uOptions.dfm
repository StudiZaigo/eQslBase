object frmOptions: TfrmOptions
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 316
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 498
    Height = 316
    ActivePage = tabSystem
    TabOrder = 0
    object tabSystem: TTabSheet
      Caption = 'System'
      ImageIndex = 1
      object Label1: TLabel
        Left = 14
        Top = 16
        Width = 52
        Height = 13
        Caption = 'Application'
      end
      object Label3: TLabel
        Left = 17
        Top = 99
        Width = 49
        Height = 13
        Caption = 'Time Zone'
      end
      object Label4: TLabel
        Left = 32
        Top = 127
        Width = 34
        Height = 13
        Caption = 'Validity'
      end
      object btnImgPath: TButton
        Left = 423
        Top = 69
        Width = 57
        Height = 25
        Caption = 'Path...'
        TabOrder = 0
        OnClick = btnImgPathClick
      end
      object cmbApplication: TComboBox
        Left = 72
        Top = 13
        Width = 121
        Height = 21
        ItemIndex = 0
        TabOrder = 1
        Text = 'LogBase'
        Items.Strings = (
          'LogBase'
          'HAMLOG')
      end
      object edtImgPath: TLabeledEdit
        Left = 72
        Top = 69
        Width = 345
        Height = 21
        EditLabel.Width = 44
        EditLabel.Height = 13
        EditLabel.Caption = 'IMG Path'
        LabelPosition = lpLeft
        LabelSpacing = 5
        TabOrder = 2
      end
      object edtDataPath: TLabeledEdit
        Left = 72
        Top = 40
        Width = 345
        Height = 21
        EditLabel.Width = 48
        EditLabel.Height = 13
        EditLabel.Caption = 'Data Path'
        LabelPosition = lpLeft
        LabelSpacing = 5
        TabOrder = 3
      end
      object btnDataPath: TButton
        Left = 423
        Top = 38
        Width = 57
        Height = 25
        Caption = 'Path...'
        TabOrder = 4
        OnClick = btnDataPathClick
      end
      object cmbTimeZone: TComboBox
        Left = 72
        Top = 96
        Width = 121
        Height = 21
        ItemIndex = 0
        TabOrder = 5
        Text = 'UTC'
        Items.Strings = (
          'UTC'
          'JST')
      end
      object cmbValidity: TComboBox
        Left = 72
        Top = 123
        Width = 121
        Height = 21
        TabOrder = 6
      end
      object btnOK1: TButton
        Left = 32
        Top = 239
        Width = 89
        Height = 33
        Caption = 'Ok'
        Default = True
        ModalResult = 1
        TabOrder = 7
      end
      object btnCancel1: TButton
        Left = 152
        Top = 239
        Width = 89
        Height = 33
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 8
      end
    end
    object tabDBGrid: TTabSheet
      Caption = 'DBGrid'
      object Label2: TLabel
        Left = 112
        Top = 13
        Width = 59
        Height = 13
        Caption = 'Visible Items'
      end
      object Label5: TLabel
        Left = 328
        Top = 13
        Width = 84
        Height = 13
        Caption = 'NoneVisible Items'
      end
      object btnVisibleItemUp: TButton
        Left = 24
        Top = 56
        Width = 49
        Height = 33
        Caption = 'Up'
        TabOrder = 0
        OnClick = btnVisibleItemUpClick
      end
      object btnVisibleItemDown: TButton
        Left = 24
        Top = 93
        Width = 49
        Height = 33
        Caption = 'Down'
        TabOrder = 1
        OnClick = btnVisibleItemDownClick
      end
      object btnLeft: TButton
        Left = 232
        Top = 54
        Width = 49
        Height = 33
        Caption = #8592
        TabOrder = 2
        OnClick = btnLeftClick
      end
      object btnRight: TButton
        Left = 232
        Top = 93
        Width = 49
        Height = 33
        Caption = #8594
        TabOrder = 3
        OnClick = btnRightClick
      end
      object lstVisibleItems: TListBox
        Left = 79
        Top = 32
        Width = 137
        Height = 201
        ItemHeight = 13
        TabOrder = 4
        OnDragDrop = ListBoxDragDrop
      end
      object lstNoneVisibleItems: TListBox
        Left = 304
        Top = 32
        Width = 137
        Height = 201
        ItemHeight = 13
        Sorted = True
        TabOrder = 5
        OnDragDrop = ListBoxDragDrop
      end
      object btnOk2: TButton
        Left = 40
        Top = 247
        Width = 89
        Height = 33
        Caption = 'Ok'
        Default = True
        ModalResult = 1
        TabOrder = 6
      end
      object btnCancel2: TButton
        Left = 160
        Top = 247
        Width = 89
        Height = 33
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 7
      end
    end
  end
end

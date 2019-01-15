object settingsForm: TsettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 136
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object labSaveInfo: TLabel
    Left = 145
    Top = 110
    Width = 126
    Height = 13
    Caption = 'Settings saved succesfully'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object btnSave: TButton
    Left = 8
    Top = 103
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 325
    Top = 103
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 393
    Height = 89
    Caption = 'DX Cluster '
    TabOrder = 2
    object txtDXCUsername: TLabeledEdit
      Left = 11
      Top = 32
      Width = 97
      Height = 21
      Margins.Top = 4
      EditLabel.Width = 32
      EditLabel.Height = 13
      EditLabel.Caption = 'Login: '
      MaxLength = 12
      TabOrder = 0
      Text = 'UN7ZAF'
    end
    object txtDXCHost: TLabeledEdit
      Left = 112
      Top = 32
      Width = 121
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = 'Host:'
      MaxLength = 254
      TabOrder = 1
      Text = 'dxc.kfrr.kz'
    end
    object txtDXCPort: TLabeledEdit
      Left = 239
      Top = 32
      Width = 58
      Height = 21
      EditLabel.Width = 24
      EditLabel.Height = 13
      EditLabel.Caption = 'Port:'
      MaxLength = 5
      TabOrder = 2
      Text = '8000'
      OnKeyPress = txtDXCPortKeyPress
    end
    object chkDXCAutoConnect: TCheckBox
      Left = 303
      Top = 32
      Width = 82
      Height = 17
      Caption = 'Auto connect'
      TabOrder = 3
    end
  end
end

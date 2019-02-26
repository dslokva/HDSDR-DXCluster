object settingsForm: TsettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 233
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
    Left = 123
    Top = 208
    Width = 149
    Height = 13
    Caption = 'Settings saved succesfully'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object btnSave: TButton
    Left = 8
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 325
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 8
    Width = 393
    Height = 113
    Caption = 'DX Cluster '
    TabOrder = 2
    object Label2: TLabel
      Left = 115
      Top = 80
      Width = 129
      Height = 13
      Caption = 'Maximum number of spots:'
    end
    object Label3: TLabel
      Left = 114
      Top = 16
      Width = 26
      Height = 13
      Caption = 'Host:'
    end
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
    object txtDXCPort: TLabeledEdit
      Left = 239
      Top = 32
      Width = 58
      Height = 21
      EditLabel.Width = 24
      EditLabel.Height = 13
      EditLabel.Caption = 'Port:'
      MaxLength = 5
      TabOrder = 1
      Text = '8000'
      OnKeyPress = txtDXCPortKeyPress
    end
    object chkDXCAutoConnect: TCheckBox
      Left = 303
      Top = 32
      Width = 82
      Height = 17
      Caption = 'Auto connect'
      TabOrder = 2
    end
    object txtStationCallsign: TLabeledEdit
      Left = 11
      Top = 77
      Width = 97
      Height = 21
      Margins.Top = 4
      EditLabel.Width = 75
      EditLabel.Height = 13
      EditLabel.Caption = 'Station callsign:'
      MaxLength = 12
      TabOrder = 3
      Text = 'UN7ZAF'
    end
    object spSpotMaxNumber: TSpinEdit
      Left = 250
      Top = 77
      Width = 47
      Height = 22
      Increment = 5
      MaxValue = 400
      MinValue = 50
      TabOrder = 4
      Value = 50
      OnChange = spSpotMaxNumberChange
    end
    object txtDXCHost: TComboBox
      Left = 114
      Top = 32
      Width = 113
      Height = 21
      TabOrder = 5
      Text = 'dxc.kfrr.kz'
      Items.Strings = (
        'dxc.kfrr.kz'
        'dxc.pi4cc.nl'
        'dxfun.com'
        'odxc.ru')
    end
  end
  object gbAALogIntegration: TGroupBox
    Left = 8
    Top = 127
    Width = 201
    Height = 67
    Caption = '       AALog integration '
    Enabled = False
    TabOrder = 3
    object txtAalAddr: TLabeledEdit
      Left = 12
      Top = 34
      Width = 95
      Height = 21
      EditLabel.Width = 77
      EditLabel.Height = 13
      EditLabel.Caption = 'Server address:'
      Enabled = False
      MaxLength = 15
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object txtAalPort: TLabeledEdit
      Left = 122
      Top = 34
      Width = 63
      Height = 21
      EditLabel.Width = 59
      EditLabel.Height = 13
      EditLabel.Caption = 'Server port:'
      Enabled = False
      MaxLength = 5
      TabOrder = 1
      Text = '3541'
      OnKeyPress = txtDXCPortKeyPress
    end
  end
  object cbAALogIntegrationEnabled: TCheckBox
    Left = 20
    Top = 126
    Width = 15
    Height = 17
    TabOrder = 4
    OnClick = cbAALogIntegrationEnabledClick
  end
end

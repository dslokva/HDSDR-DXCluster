object settingsForm: TsettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 191
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
    Top = 166
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
    Top = 159
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 325
    Top = 159
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
    Height = 145
    Caption = 'DX Cluster '
    TabOrder = 2
    object Label1: TLabel
      Left = 114
      Top = 83
      Width = 268
      Height = 13
      Caption = '(will be used for extra color spots, that sent by youself)'
    end
    object Label2: TLabel
      Left = 11
      Top = 112
      Width = 129
      Height = 13
      Caption = 'Maximum number of spots:'
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
    object txtStationCallsign: TLabeledEdit
      Left = 11
      Top = 80
      Width = 97
      Height = 21
      Margins.Top = 4
      EditLabel.Width = 75
      EditLabel.Height = 13
      EditLabel.Caption = 'Station callsign:'
      MaxLength = 12
      TabOrder = 4
      Text = 'UN7ZAF'
    end
    object spSpotMaxNumber: TSpinEdit
      Left = 146
      Top = 109
      Width = 47
      Height = 22
      Increment = 5
      MaxValue = 400
      MinValue = 50
      TabOrder = 5
      Value = 50
    end
  end
end

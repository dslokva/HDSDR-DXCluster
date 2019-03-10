object settingsForm: TsettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 321
  ClientWidth = 457
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
  object Label1: TLabel
    Left = 8
    Top = 213
    Width = 81
    Height = 13
    Caption = 'Freq panel color:'
  end
  object Label5: TLabel
    Left = 9
    Top = 270
    Width = 200
    Height = 13
    Caption = '--------------------------------------------------'
  end
  object labSaveInfo: TLabel
    Left = 101
    Top = 294
    Width = 15
    Height = 13
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object btnSave: TButton
    Left = 8
    Top = 289
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 134
    Top = 289
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 7
    Width = 442
    Height = 113
    Caption = 'DX Cluster '
    TabOrder = 2
    object Label2: TLabel
      Left = 114
      Top = 81
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
      Width = 59
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
      Left = 304
      Top = 34
      Width = 82
      Height = 17
      Caption = 'Auto connect'
      TabOrder = 2
    end
    object txtStationCallsign: TLabeledEdit
      Left = 11
      Top = 78
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
      Left = 249
      Top = 78
      Width = 47
      Height = 22
      Increment = 5
      MaxValue = 400
      MinValue = 50
      TabOrder = 4
      Value = 120
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
    Height = 77
    Caption = '       AALog integration '
    Enabled = False
    TabOrder = 3
    object txtAalAddr: TLabeledEdit
      Left = 12
      Top = 42
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
      Top = 42
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
  object GroupBox2: TGroupBox
    Left = 215
    Top = 127
    Width = 234
    Height = 187
    Caption = 'Spot colors'
    TabOrder = 5
    object Label4: TLabel
      Left = 9
      Top = 107
      Width = 216
      Height = 13
      Caption = '--------------------AALog data--------------------'
    end
    object cbOwnSpotColorize: TCheckBox
      Left = 8
      Top = 17
      Width = 66
      Height = 17
      Caption = 'Own spot:'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbOwnSpotColorizeClick
    end
    object colBoxOwnSpot: TColorBox
      Left = 127
      Top = 15
      Width = 97
      Height = 22
      Selected = clYellow
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      TabOrder = 1
    end
    object colBoxSpotMouseMove: TColorBox
      Left = 127
      Top = 45
      Width = 97
      Height = 22
      Selected = clLime
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      TabOrder = 2
    end
    object cbSpotMouseMoveColorize: TCheckBox
      Left = 8
      Top = 47
      Width = 82
      Height = 17
      Caption = 'Mouse move:'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = cbSpotMouseMoveColorizeClick
    end
    object cbSpotInLog: TCheckBox
      Left = 8
      Top = 130
      Width = 98
      Height = 17
      Caption = 'Already in Log:'
      Checked = True
      State = cbChecked
      TabOrder = 4
      OnClick = cbSpotInLogClick
    end
    object colBoxSpotInLog: TColorBox
      Left = 127
      Top = 128
      Width = 97
      Height = 22
      Selected = clGray
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      TabOrder = 5
    end
    object cbSpotLotwEqsl: TCheckBox
      Left = 8
      Top = 156
      Width = 161
      Height = 17
      Caption = 'Underline if LoTW or EQSL.cc'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object cbEarlySpot: TCheckBox
      Left = 8
      Top = 75
      Width = 113
      Height = 17
      Caption = 'Early spot (2 min):'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object colBoxEarlySpot: TColorBox
      Left = 127
      Top = 73
      Width = 97
      Height = 22
      Selected = clRed
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      TabOrder = 8
    end
  end
  object colBoxMainFreqPanel: TColorBox
    Left = 95
    Top = 210
    Width = 114
    Height = 22
    Selected = 4659989
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 6
    OnChange = colBoxMainFreqPanelChange
  end
  object btnDefaultFreqPanColor: TButton
    Left = 176
    Top = 240
    Width = 35
    Height = 20
    Caption = 'Def'
    TabOrder = 7
    OnClick = btnDefaultFreqPanColorClick
  end
  object btnGreennyFreqPanColor: TButton
    Left = 8
    Top = 240
    Width = 35
    Height = 20
    Caption = 'Grn'
    TabOrder = 8
    OnClick = btnGreennyFreqPanColorClick
  end
  object Button1: TButton
    Left = 92
    Top = 240
    Width = 35
    Height = 20
    Caption = 'Gre'
    TabOrder = 9
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 134
    Top = 240
    Width = 35
    Height = 20
    Caption = 'Blk'
    TabOrder = 10
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 50
    Top = 240
    Width = 35
    Height = 20
    Caption = 'Grn'
    TabOrder = 11
    OnClick = Button3Click
  end
end

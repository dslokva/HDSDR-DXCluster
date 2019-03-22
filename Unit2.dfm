object settingsForm: TsettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 348
  ClientWidth = 476
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
    Top = 221
    Width = 81
    Height = 13
    Caption = 'Freq panel color:'
  end
  object Label5: TLabel
    Left = 9
    Top = 300
    Width = 220
    Height = 13
    Caption = '-------------------------------------------------------'
  end
  object labSaveInfo: TLabel
    Left = 112
    Top = 323
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
    Top = 317
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 153
    Top = 317
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 7
    Width = 460
    Height = 112
    Caption = ' DX Cluster: '
    TabOrder = 2
    object Label2: TLabel
      Left = 114
      Top = 82
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
      Left = 318
      Top = 31
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
    object chkAllowSpotSelect: TCheckBox
      Left = 318
      Top = 80
      Width = 102
      Height = 17
      Caption = 'Allow spot select'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
  end
  object gbAALogIntegration: TGroupBox
    Left = 8
    Top = 127
    Width = 220
    Height = 85
    Caption = '       AALog integration '
    Enabled = False
    TabOrder = 3
    object txtAalAddr: TLabeledEdit
      Left = 8
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
      Left = 118
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
    object cbSendCallFreqToAALog: TCheckBox
      Left = 8
      Top = 61
      Width = 209
      Height = 17
      Caption = 'Send info to AALog New QSO window'
      Enabled = False
      TabOrder = 2
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
    Left = 234
    Top = 126
    Width = 234
    Height = 215
    Caption = ' Spot colors: '
    TabOrder = 5
    object Label4: TLabel
      Left = 9
      Top = 139
      Width = 216
      Height = 13
      Caption = '--------------------AALog data--------------------'
    end
    object Label6: TLabel
      Left = 9
      Top = 109
      Width = 65
      Height = 13
      Caption = 'Regular spot:'
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
      Top = 162
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
      Top = 160
      Width = 97
      Height = 22
      Selected = clGray
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      TabOrder = 5
    end
    object cbSpotLotwEqsl: TCheckBox
      Left = 8
      Top = 188
      Width = 161
      Height = 17
      Caption = 'Underline if LoTW or EQSL.cc'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object cbEarlySpot: TCheckBox
      Left = 8
      Top = 77
      Width = 113
      Height = 17
      Caption = 'Early spot (2 min):'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object colBoxEarlySpot: TColorBox
      Left = 127
      Top = 75
      Width = 97
      Height = 22
      Selected = clRed
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      TabOrder = 8
    end
    object colBoxRegularSpot: TColorBox
      Left = 80
      Top = 105
      Width = 144
      Height = 22
      Selected = clWhite
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
      TabOrder = 9
    end
  end
  object colBoxMainFreqPanel: TColorBox
    Left = 95
    Top = 218
    Width = 133
    Height = 22
    Selected = 4659989
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
    TabOrder = 6
    OnChange = colBoxMainFreqPanelChange
  end
  object btnDefaultFreqPanColor: TButton
    Left = 88
    Top = 274
    Width = 60
    Height = 20
    Caption = 'Dark Blue'
    TabOrder = 7
    OnClick = btnDefaultFreqPanColorClick
  end
  object btnGreennyFreqPanColor: TButton
    Left = 8
    Top = 248
    Width = 60
    Height = 20
    Caption = 'Green'
    TabOrder = 8
    OnClick = btnGreennyFreqPanColorClick
  end
  object Button1: TButton
    Left = 8
    Top = 274
    Width = 60
    Height = 20
    Caption = 'Grey'
    TabOrder = 9
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 248
    Width = 60
    Height = 20
    Caption = 'Black'
    TabOrder = 10
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 168
    Top = 274
    Width = 60
    Height = 20
    Caption = 'Default 2'
    TabOrder = 11
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 168
    Top = 248
    Width = 60
    Height = 20
    Caption = 'Brick'
    TabOrder = 12
    OnClick = Button4Click
  end
end

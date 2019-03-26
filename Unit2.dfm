object settingsForm: TsettingsForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 296
  ClientWidth = 496
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
    Left = 106
    Top = 271
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
    Top = 266
    Width = 92
    Height = 25
    Caption = 'Save config'
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 405
    Top = 266
    Width = 83
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 481
    Height = 252
    ActivePage = Colors
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'DX Cluster'
      ExplicitLeft = -28
      ExplicitTop = 32
      ExplicitWidth = 629
      object GroupBox1: TGroupBox
        Left = 3
        Top = 3
        Width = 310
        Height = 132
        Caption = 'Main settings: '
        TabOrder = 0
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
          TabOrder = 2
          Text = 'UN7ZAF'
        end
        object spSpotMaxNumber: TSpinEdit
          Left = 250
          Top = 78
          Width = 47
          Height = 22
          Increment = 5
          MaxValue = 350
          MinValue = 50
          TabOrder = 3
          Value = 120
          OnChange = spSpotMaxNumberChange
        end
        object txtDXCHost: TComboBox
          Left = 114
          Top = 32
          Width = 119
          Height = 21
          TabOrder = 4
          Text = 'dxc.kfrr.kz'
          Items.Strings = (
            'dxc.kfrr.kz'
            'dxc.pi4cc.nl'
            'dxfun.com'
            'odxc.ru')
        end
        object chkDXCAutoConnect: TCheckBox
          Left = 11
          Top = 106
          Width = 174
          Height = 17
          Caption = 'Auto connect at program start'
          TabOrder = 5
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Log integration'
      ImageIndex = 1
      ExplicitWidth = 281
      ExplicitHeight = 165
      object gbAALogIntegration: TGroupBox
        Left = 3
        Top = 9
        Width = 220
        Height = 88
        Caption = '       AALog integration '
        Enabled = False
        TabOrder = 0
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
        Left = 14
        Top = 7
        Width = 15
        Height = 17
        TabOrder = 1
        OnClick = cbAALogIntegrationEnabledClick
      end
    end
    object Colors: TTabSheet
      Caption = 'Colors'
      ImageIndex = 2
      ExplicitLeft = 132
      ExplicitTop = -16
      ExplicitWidth = 281
      ExplicitHeight = 165
      object GroupBox2: TGroupBox
        Left = 3
        Top = 3
        Width = 234
        Height = 215
        Caption = ' Spot colors: '
        TabOrder = 0
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
      object GroupBox3: TGroupBox
        Left = 243
        Top = 3
        Width = 224
        Height = 179
        Caption = ' Frequency panel: '
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 18
          Width = 52
          Height = 13
          Caption = 'Main color:'
        end
        object Label8: TLabel
          Left = 7
          Top = 80
          Width = 208
          Height = 13
          Caption = '---------------------Presets----------------------'
        end
        object Label5: TLabel
          Left = 8
          Top = 51
          Width = 55
          Height = 13
          Caption = 'Scale color:'
        end
        object colBoxMainFreqPanel: TColorBox
          Left = 95
          Top = 15
          Width = 118
          Height = 22
          Selected = 4659989
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
          TabOrder = 0
          OnChange = colBoxMainFreqPanelChange
        end
        object btnDefaultFreqPanColor: TButton
          Left = 150
          Top = 99
          Width = 64
          Height = 21
          Caption = 'Dark Blue'
          TabOrder = 1
          OnClick = btnDefaultFreqPanColorClick
        end
        object btnGreennyFreqPanColor: TButton
          Left = 79
          Top = 99
          Width = 64
          Height = 21
          Caption = 'Green'
          TabOrder = 2
          OnClick = btnGreennyFreqPanColorClick
        end
        object Button1: TButton
          Left = 7
          Top = 126
          Width = 65
          Height = 21
          Caption = 'Grey'
          TabOrder = 3
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 150
          Top = 126
          Width = 64
          Height = 21
          Caption = 'Black'
          TabOrder = 4
          OnClick = Button2Click
        end
        object Button3: TButton
          Left = 7
          Top = 99
          Width = 65
          Height = 21
          Caption = 'Blue'
          TabOrder = 5
          OnClick = Button3Click
        end
        object Button4: TButton
          Left = 79
          Top = 126
          Width = 64
          Height = 21
          Caption = 'Brick'
          TabOrder = 6
          OnClick = Button4Click
        end
        object chkAllowSpotSelect: TCheckBox
          Left = 7
          Top = 155
          Width = 102
          Height = 17
          Caption = 'Allow spot select'
          Checked = True
          State = cbChecked
          TabOrder = 7
        end
        object colBoxScale: TColorBox
          Left = 95
          Top = 45
          Width = 118
          Height = 22
          Selected = clWhite
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
          TabOrder = 8
          OnChange = colBoxScaleChange
        end
      end
    end
  end
end

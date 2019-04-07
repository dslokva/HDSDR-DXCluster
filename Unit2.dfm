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
    Left = 108
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
    ActivePage = TabGeneralOptions
    TabOrder = 2
    object TabDXCluster: TTabSheet
      Caption = 'DX Cluster'
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
          MaxValue = 400
          MinValue = 50
          TabOrder = 3
          Value = 200
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
    object TabLogIntegration: TTabSheet
      Caption = 'Log integration'
      ImageIndex = 1
      object gbAALogIntegration: TGroupBox
        Left = 3
        Top = 9
        Width = 262
        Height = 92
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
          Top = 64
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
          Selected = 35071
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
        Height = 215
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
          Top = 103
          Width = 208
          Height = 13
          Caption = '---------------------Presets----------------------'
        end
        object Label5: TLabel
          Left = 8
          Top = 48
          Width = 55
          Height = 13
          Caption = 'Scale color:'
        end
        object Label12: TLabel
          Left = 8
          Top = 78
          Width = 92
          Height = 13
          Caption = 'CAT freq line color:'
        end
        object Label13: TLabel
          Left = 7
          Top = 170
          Width = 208
          Height = 13
          Caption = '----------------------------------------------------'
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
          Left = 151
          Top = 121
          Width = 64
          Height = 21
          Caption = 'Dark Blue'
          TabOrder = 1
          OnClick = btnDefaultFreqPanColorClick
        end
        object btnGreennyFreqPanColor: TButton
          Left = 80
          Top = 121
          Width = 64
          Height = 21
          Caption = 'Green'
          TabOrder = 2
          OnClick = btnGreennyFreqPanColorClick
        end
        object Button1: TButton
          Left = 8
          Top = 148
          Width = 65
          Height = 21
          Caption = 'Grey'
          TabOrder = 3
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 151
          Top = 148
          Width = 64
          Height = 21
          Caption = 'Black'
          TabOrder = 4
          OnClick = Button2Click
        end
        object Button3: TButton
          Left = 8
          Top = 121
          Width = 65
          Height = 21
          Caption = 'Blue'
          TabOrder = 5
          OnClick = Button3Click
        end
        object Button4: TButton
          Left = 80
          Top = 148
          Width = 64
          Height = 21
          Caption = 'Brick'
          TabOrder = 6
          OnClick = Button4Click
        end
        object chkAllowSpotSelect: TCheckBox
          Left = 8
          Top = 188
          Width = 102
          Height = 17
          Caption = 'Allow spot select:'
          Checked = True
          State = cbChecked
          TabOrder = 7
          OnClick = chkAllowSpotSelectClick
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
        object colBoxCATFreqColor: TColorBox
          Left = 106
          Top = 75
          Width = 107
          Height = 22
          Selected = clRed
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
          TabOrder = 9
          OnChange = colBoxScaleChange
        end
        object cboxSpotSelectBgColor: TColorBox
          Left = 116
          Top = 186
          Width = 97
          Height = 22
          Selected = clWhite
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
          TabOrder = 10
          OnChange = colBoxScaleChange
        end
      end
    end
    object TabGeneralOptions: TTabSheet
      Caption = 'General options'
      ImageIndex = 3
      object GroupBox4: TGroupBox
        Left = 7
        Top = 3
        Width = 334
        Height = 107
        Caption = '       OmniRig enable '
        Enabled = False
        TabOrder = 0
        object radGrpRigNum: TRadioGroup
          Left = 9
          Top = 22
          Width = 145
          Height = 48
          Caption = 'Rig select: '
          Columns = 2
          Enabled = False
          ItemIndex = 0
          Items.Strings = (
            'Rig #1'
            'Rig #2')
          TabOrder = 0
          OnClick = radGrpRigNumClick
        end
        object cbSetSpotFrequencyToTRX: TCheckBox
          Left = 10
          Top = 81
          Width = 191
          Height = 17
          Caption = 'Set selected spot frequency to TRX'
          Enabled = False
          TabOrder = 1
        end
        object Panel1: TPanel
          Left = 160
          Top = 31
          Width = 168
          Height = 41
          BevelOuter = bvNone
          TabOrder = 2
          object Label7: TLabel
            Left = 0
            Top = 0
            Width = 32
            Height = 13
            Caption = 'Model:'
            Enabled = False
          end
          object Label10: TLabel
            Left = 0
            Top = 22
            Width = 35
            Height = 13
            Caption = 'Status:'
            Enabled = False
          end
          object Label11: TLabel
            Left = 41
            Top = 22
            Width = 12
            Height = 13
            Caption = '---'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object Label9: TLabel
            Left = 41
            Top = 0
            Width = 12
            Height = 13
            Caption = '---'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
        end
      end
      object cbOmniRigEnabled: TCheckBox
        Left = 18
        Top = 1
        Width = 17
        Height = 17
        TabOrder = 1
        OnClick = cbOmniRigEnabledClick
      end
      object GroupBox5: TGroupBox
        Left = 7
        Top = 114
        Width = 334
        Height = 105
        Caption = 'Other options: '
        TabOrder = 2
        object SpeedButton1: TSpeedButton
          Left = 290
          Top = 67
          Width = 23
          Height = 23
          Caption = '...'
          Enabled = False
          OnClick = SpeedButton1Click
        end
        object cbHiRes: TCheckBox
          Left = 13
          Top = 22
          Width = 190
          Height = 17
          Caption = 'Try high resolution screen settings'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = cbHiResClick
        end
        object cbAdditionalInfoFromCall: TCheckBox
          Left = 13
          Top = 45
          Width = 188
          Height = 17
          Caption = 'Show additional info for callsigns:'
          TabOrder = 1
          OnClick = cbAdditionalInfoFromCallClick
        end
        object txtPathToPrefixLst: TEdit
          Left = 13
          Top = 68
          Width = 276
          Height = 21
          Enabled = False
          TabOrder = 2
        end
      end
    end
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Prefix lst'
        FileMask = '*.lst'
      end
      item
        DisplayName = 'All files'
        FileMask = '*.*'
      end>
    Options = [fdoFileMustExist]
    Left = 388
    Top = 208
  end
end

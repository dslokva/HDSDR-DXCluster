object FrequencyVisualForm: TFrequencyVisualForm
  Left = 0
  Top = 0
  Caption = 'SDR-DXCluster-Helper v0.32'
  ClientHeight = 292
  ClientWidth = 949
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = 4659989
  Constraints.MinHeight = 230
  Constraints.MinWidth = 965
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 192
    Width = 949
    Height = 100
    Align = alBottom
    BevelEdges = []
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseDown = Panel1MouseDown
    object StatusBar1: TStatusBar
      Left = 0
      Top = 81
      Width = 949
      Height = 19
      Panels = <
        item
          Text = 'DXCluster: disconnected'
          Width = 300
        end
        item
          Text = 'Scale factor: 0'
          Width = 100
        end
        item
          Text = 'Last status: none'
          Width = 350
        end
        item
          Text = 'TRX: disconnected'
          Width = 50
        end>
      OnMouseDown = StatusBar1MouseDown
    end
    object Panel2: TPanel
      Left = 685
      Top = 0
      Width = 264
      Height = 81
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      OnMouseDown = Panel4MouseDown
      object Bevel1: TBevel
        Left = 1
        Top = 6
        Width = 9
        Height = 69
        Shape = bsLeftLine
      end
      object chkStayOnTop: TCheckBox
        Left = 14
        Top = 48
        Width = 116
        Height = 17
        Caption = 'Always stay on top'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = chkStayOnTopClick
      end
      object Button2: TButton
        Left = 139
        Top = 13
        Width = 111
        Height = 25
        Caption = 'Settings...'
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button1: TButton
        Left = 139
        Top = 44
        Width = 111
        Height = 25
        Caption = 'Exit'
        TabOrder = 2
        OnClick = Button1Click
      end
      object chkTransparentForm: TCheckBox
        Left = 14
        Top = 17
        Width = 116
        Height = 17
        Caption = 'Transparent window'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = chkTransparentFormClick
      end
    end
    object Panel8: TPanel
      Left = 0
      Top = 0
      Width = 685
      Height = 81
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      OnMouseDown = Panel8MouseDown
      object btnSpotClearBand: TButton
        Left = 351
        Top = 44
        Width = 98
        Height = 25
        Hint = 'Exclude holded labels'
        Caption = 'Clear band'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btnSpotClearBandClick
      end
      object btnSpotClearAll: TButton
        Left = 455
        Top = 44
        Width = 74
        Height = 25
        Caption = 'Clear all (!)'
        TabOrder = 1
        OnClick = btnSpotClearAllClick
      end
      object Button3: TButton
        Left = 455
        Top = 13
        Width = 74
        Height = 25
        Caption = 'View DXC...'
        TabOrder = 2
        OnClick = Button3Click
      end
      object btnDXCConnect: TButton
        Left = 351
        Top = 13
        Width = 98
        Height = 25
        Caption = 'Connect to DXC'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = btnDXCConnectClick
      end
      object bandSwitcher: TRadioGroup
        Left = 6
        Top = 0
        Width = 331
        Height = 75
        Caption = 'Band select:'
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          '160m (1,8 mHz)'
          '80m (3,5 mHz) '
          '40m (7 mHz)'
          '30m (10 mHz)'
          '20m (14 mHz)'
          '17m (18 mHz)'
          '15m (21 mHz)'
          '12m (24 mHz)'
          '10m (28 mHz)')
        TabOrder = 4
        OnClick = bandSwitcherClick
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 949
    Height = 192
    Align = alClient
    BevelEdges = []
    BevelOuter = bvNone
    DoubleBuffered = True
    FullRepaint = False
    ParentDoubleBuffered = False
    TabOrder = 1
    object frequencyPaintBox: TPaintBox
      Left = 0
      Top = 40
      Width = 949
      Height = 129
      Align = alClient
      Color = clNavy
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      PopupMenu = spotLabelMenu
      ShowHint = True
      OnContextPopup = frequencyPaintBoxContextPopup
      OnMouseLeave = frequencyPaintBoxMouseLeave
      OnMouseMove = frequencyPaintBoxMouseMove
      OnMouseUp = frequencyPaintBoxMouseUp
      OnPaint = frequencyPaintBoxPaint
      ExplicitTop = 39
      ExplicitWidth = 888
    end
    object labelSpotHint: TLabel
      Left = 664
      Top = 8
      Width = 72
      Height = 14
      Caption = 'labelSpotHint'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = []
      Font.Quality = fqAntialiased
      ParentFont = False
      Visible = False
    end
    object frequencyPaintBoxTop: TPaintBox
      Left = 0
      Top = 0
      Width = 949
      Height = 40
      Hint = 
        'Shift+Left click - spot down, Shift+Right - up. Alt+Click - dele' +
        'te spot. Ctrl + Click - additional menu.'
      Align = alTop
      Color = clNavy
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      OnPaint = frequencyPaintBoxTopPaint
      ExplicitTop = -6
      ExplicitWidth = 888
    end
    object Panel3: TPanel
      Left = 0
      Top = 169
      Width = 949
      Height = 23
      Align = alBottom
      BevelEdges = [beTop, beBottom]
      BevelKind = bkSoft
      BevelOuter = bvNone
      TabOrder = 0
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 161
        Height = 19
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        OnMouseDown = Panel4MouseDown
        object Label4: TLabel
          Left = 6
          Top = 2
          Width = 95
          Height = 13
          Caption = 'Last labels refresh: '
          Color = clBlack
          ParentColor = False
          OnMouseDown = Label4MouseDown
        end
        object labLabelsRefresh: TLabel
          Left = 103
          Top = 2
          Width = 28
          Height = 13
          Caption = 'none'
          Color = clBlack
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          OnMouseDown = Label4MouseDown
        end
      end
      object spacerScroll: TScrollBar
        Left = 234
        Top = 0
        Width = 442
        Height = 19
        Align = alClient
        Max = 6000
        Min = 1200
        PageSize = 0
        Position = 2500
        TabOrder = 1
        OnChange = spacerScrollChange
      end
      object Panel7: TPanel
        Left = 161
        Top = 0
        Width = 73
        Height = 19
        Align = alLeft
        BevelEdges = [beLeft, beRight]
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 2
        object labPanelMode: TLabel
          Left = 3
          Top = 2
          Width = 62
          Height = 13
          Alignment = taCenter
          Caption = 'Normal mode'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnDblClick = labPanelModeDblClick
          OnMouseDown = Label4MouseDown
        end
      end
      object Panel6: TPanel
        Left = 676
        Top = 0
        Width = 273
        Height = 19
        Align = alRight
        BevelEdges = [beLeft]
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 3
        OnMouseDown = Panel4MouseDown
        object Label2: TLabel
          Left = 105
          Top = 3
          Width = 118
          Height = 13
          Hint = 'Double click to get last 50 spots (SH/DX 50)'
          Caption = 'Spot count total / band: '
          Color = clBlack
          ParentColor = False
          ParentShowHint = False
          ShowHint = True
          OnDblClick = Label2DblClick
          OnMouseDown = Label4MouseDown
        end
        object SpeedButton1: TSpeedButton
          Left = 76
          Top = 1
          Width = 23
          Height = 17
          Hint = '10 Khz forward -->'
          Caption = '8'
          Font.Charset = SYMBOL_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Webdings'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton1Click
        end
        object SpeedButton2: TSpeedButton
          Left = 1
          Top = 1
          Width = 23
          Height = 17
          Hint = '<-- Band begin'
          Caption = '9'
          Font.Charset = SYMBOL_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Webdings'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton2Click
        end
        object SpeedButton3: TSpeedButton
          Left = 51
          Top = 1
          Width = 23
          Height = 17
          Hint = 'Near center freq'
          Caption = ';'
          Font.Charset = SYMBOL_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Webdings'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton3Click
        end
        object SpeedButton4: TSpeedButton
          Left = 26
          Top = 1
          Width = 23
          Height = 17
          Hint = '<-- 10 Khz back'
          Caption = '7'
          Font.Charset = SYMBOL_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Webdings'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton4Click
        end
        object Panel9: TPanel
          Left = 221
          Top = 0
          Width = 50
          Height = 19
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 0
          object lbSpotTotal: TLabel
            Left = 1
            Top = 3
            Width = 26
            Height = 13
            Caption = '0 / 0'
            Color = clBlack
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            OnMouseDown = Label4MouseDown
          end
        end
      end
    end
  end
  object IdTelnet1: TIdTelnet
    OnDisconnected = IdTelnet1Disconnected
    OnConnected = IdTelnet1Connected
    Host = 'dxc.kfrr.kz'
    Port = 8000
    OnDataAvailable = IdTelnet1DataAvailable
    Terminal = 'dumb'
    Left = 24
    Top = 17
  end
  object freqPanelMenu: TPopupMenu
    Left = 24
    Top = 64
    object isPanelHoldActive: TMenuItem
      AutoCheck = True
      Caption = 'Hold frequency panel'
      OnClick = isPanelHoldActiveClick
    end
  end
  object spotLabelMenu: TPopupMenu
    OnPopup = spotLabelMenuPopup
    Left = 24
    Top = 112
    object Viewonqrzcom1: TMenuItem
      Caption = 'View on qrz.com...'
      OnClick = Viewonqrzcom1Click
    end
    object Viewonqrzru1: TMenuItem
      Caption = 'View on qrz.ru...'
      OnClick = Viewonqrzru1Click
    end
    object menuLabelOnHold: TMenuItem
      Caption = 'Hold label'
      OnClick = menuLabelOnHoldClick
    end
    object menuLabelRequestAALogData: TMenuItem
      Caption = 'Request info from AALog'
      OnClick = menuLabelRequestAALogDataClick
    end
  end
  object refreshLabelColorTimer: TTimer
    Interval = 50000
    OnTimer = refreshLabelColorTimerTimer
    Left = 144
    Top = 112
  end
  object spotCountResetTimer: TTimer
    Interval = 60000
    OnTimer = spotCountResetTimerTimer
    Left = 144
    Top = 64
  end
  object statusRefreshTimer: TTimer
    Interval = 61000
    OnTimer = statusRefreshTimerTimer
    Left = 144
    Top = 16
  end
end

object FrequencyVisualForm: TFrequencyVisualForm
  Left = 0
  Top = 0
  Caption = 'HDSDR-DXCluster-Helper'
  ClientHeight = 311
  ClientWidth = 729
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 745
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
    Top = 203
    Width = 729
    Height = 108
    Align = alBottom
    BevelEdges = []
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseDown = Panel1MouseDown
    object dxcStatusLabel: TLabel
      Left = 312
      Top = 21
      Width = 113
      Height = 13
      Caption = 'DXCluster disconnected'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Panel2: TPanel
      Left = 551
      Top = 0
      Width = 178
      Height = 108
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      OnMouseDown = Panel2MouseDown
      object Button1: TButton
        Left = 104
        Top = 71
        Width = 65
        Height = 25
        Caption = 'Exit'
        TabOrder = 0
        OnClick = Button1Click
      end
      object chkStayOnTop: TCheckBox
        Left = 11
        Top = 15
        Width = 73
        Height = 17
        Caption = 'Stay on top'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = chkStayOnTopClick
      end
      object cbHiRes: TCheckBox
        Left = 11
        Top = 38
        Width = 89
        Height = 17
        Caption = 'HighRes screen'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = cbHiResClick
      end
      object Button2: TButton
        Left = 10
        Top = 71
        Width = 88
        Height = 25
        Caption = 'Settings'
        TabOrder = 3
        OnClick = Button2Click
      end
    end
    object bandSwitcher: TRadioGroup
      Left = 6
      Top = 4
      Width = 299
      Height = 93
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
      TabOrder = 1
      OnClick = bandSwitcherClick
    end
    object btnDXCConnect: TButton
      Left = 311
      Top = 40
      Width = 123
      Height = 25
      Caption = 'Connect to DXCluster'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnDXCConnectClick
    end
    object btnSpotClearAll: TButton
      Left = 311
      Top = 70
      Width = 56
      Height = 26
      Caption = 'Clear all'
      TabOrder = 3
      OnClick = btnSpotClearAllClick
    end
    object btnSpotClearBand: TButton
      Left = 367
      Top = 70
      Width = 67
      Height = 26
      Caption = 'Clear band'
      TabOrder = 4
      OnClick = btnSpotClearBandClick
    end
    object Button3: TButton
      Left = 440
      Top = 71
      Width = 105
      Height = 25
      Caption = 'View DXCluster'
      TabOrder = 5
      OnClick = Button3Click
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 729
    Height = 203
    Align = alClient
    BevelEdges = []
    BevelOuter = bvNone
    TabOrder = 1
    object PaintBox1: TPaintBox
      Left = 0
      Top = 0
      Width = 729
      Height = 182
      Hint = 'Left click - spot down, right - up. Alt+Click - delete spot.'
      Align = alClient
      Color = clSkyBlue
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      OnDblClick = PaintBox1DblClick
      OnMouseLeave = PaintBox1MouseLeave
      OnMouseMove = PaintBox1MouseMove
      OnPaint = PaintBox1Paint
      ExplicitLeft = 81
      ExplicitTop = 15
      ExplicitWidth = 900
      ExplicitHeight = 171
    end
    object Panel3: TPanel
      Left = 0
      Top = 182
      Width = 729
      Height = 21
      Align = alBottom
      BevelEdges = [beTop, beBottom]
      BevelKind = bkSoft
      BevelOuter = bvNone
      TabOrder = 0
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 137
        Height = 17
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        OnMouseDown = Panel4MouseDown
        object Label1: TLabel
          Left = 6
          Top = 2
          Width = 104
          Height = 13
          Caption = 'Scale factor min/max:'
          Color = clBlack
          ParentColor = False
          OnMouseDown = Label1MouseDown
        end
        object lbScaleFactor: TLabel
          Left = 116
          Top = 2
          Width = 7
          Height = 13
          Caption = '0'
          Color = clBlack
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
        end
      end
      object spacerScroll: TScrollBar
        Left = 137
        Top = 0
        Width = 440
        Height = 17
        Align = alClient
        Max = 2500
        Min = 1000
        PageSize = 0
        Position = 1070
        TabOrder = 1
        OnChange = spacerScrollChange
      end
      object Panel6: TPanel
        Left = 577
        Top = 0
        Width = 152
        Height = 17
        Align = alRight
        BevelEdges = [beLeft]
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 2
        object lbSpotTotal: TLabel
          Left = 98
          Top = 2
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
        end
        object Label2: TLabel
          Left = 4
          Top = 2
          Width = 93
          Height = 13
          Hint = 'Double click to get last 50 spots (SH/DX 50)'
          Caption = 'Spots total / band: '
          Color = clBlack
          ParentColor = False
          ParentShowHint = False
          ShowHint = True
          OnDblClick = Label2DblClick
          OnMouseDown = Label2MouseDown
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
    Left = 856
    Top = 13
  end
end

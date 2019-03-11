object FrequencyVisualForm: TFrequencyVisualForm
  Left = 0
  Top = 0
  Caption = 'HDSDR-DXCluster-Helper'
  ClientHeight = 307
  ClientWidth = 950
  Color = clBtnFace
  Constraints.MinHeight = 220
  Constraints.MinWidth = 768
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
    Top = 207
    Width = 950
    Height = 100
    Align = alBottom
    BevelEdges = []
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseDown = Panel1MouseDown
    ExplicitTop = 299
    object StatusBar1: TStatusBar
      Left = 0
      Top = 81
      Width = 950
      Height = 19
      Panels = <
        item
          Text = 'DXCluster: disconnected'
          Width = 300
        end
        item
          Text = 'Last labels refresh: never'
          Width = 220
        end
        item
          Text = 'Last status: operating normal / spot rate from cluster incrased'
          Width = 50
        end>
      OnMouseDown = StatusBar1MouseDown
      ExplicitTop = 102
      ExplicitWidth = 935
    end
    object Panel2: TPanel
      Left = 686
      Top = 0
      Width = 264
      Height = 81
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      OnMouseDown = Panel2MouseDown
      object Bevel1: TBevel
        Left = 4
        Top = 6
        Width = 9
        Height = 69
        Shape = bsLeftLine
      end
      object chkStayOnTop: TCheckBox
        Left = 158
        Top = 12
        Width = 73
        Height = 17
        Caption = 'Stay on top'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = chkStayOnTopClick
      end
      object chkAllowSpotSelect: TCheckBox
        Left = 158
        Top = 33
        Width = 102
        Height = 17
        Caption = 'Allow spot select'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object cbHiRes: TCheckBox
        Left = 158
        Top = 53
        Width = 89
        Height = 17
        Caption = 'HighRes screen'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object Button2: TButton
        Left = 19
        Top = 13
        Width = 123
        Height = 25
        Caption = 'Settings...'
        TabOrder = 3
        OnClick = Button2Click
      end
      object Button1: TButton
        Left = 19
        Top = 45
        Width = 123
        Height = 25
        Caption = 'Exit'
        TabOrder = 4
        OnClick = Button1Click
      end
    end
    object Panel8: TPanel
      Left = 0
      Top = 0
      Width = 686
      Height = 81
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      OnMouseDown = Panel8MouseDown
      ExplicitLeft = -2
      object btnSpotClearBand: TButton
        Left = 487
        Top = 13
        Width = 120
        Height = 25
        Caption = 'Clear this band spots'
        TabOrder = 0
        OnClick = btnSpotClearBandClick
      end
      object btnSpotClearAll: TButton
        Left = 487
        Top = 45
        Width = 120
        Height = 25
        Caption = 'Clear all spots (!)'
        TabOrder = 1
        OnClick = btnSpotClearAllClick
      end
      object Button3: TButton
        Left = 351
        Top = 44
        Width = 123
        Height = 25
        Caption = 'View DXCluster...'
        TabOrder = 2
        OnClick = Button3Click
      end
      object btnDXCConnect: TButton
        Left = 351
        Top = 13
        Width = 123
        Height = 25
        Caption = 'Connect to DXCluster'
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
    Width = 950
    Height = 207
    Align = alClient
    BevelEdges = []
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 935
    ExplicitHeight = 270
    object frequencyPaintBox: TPaintBox
      Left = 0
      Top = 0
      Width = 950
      Height = 184
      Hint = 
        'Shift+Left click - spot down, Shift+Right - up. Alt+Click - dele' +
        'te spot. Ctrl + Click - additional menu.'
      Align = alClient
      Color = clSkyBlue
      ParentColor = False
      ParentShowHint = False
      PopupMenu = freqPanelMenu
      ShowHint = True
      OnContextPopup = frequencyPaintBoxContextPopup
      OnDblClick = frequencyPaintBoxDblClick
      OnMouseLeave = frequencyPaintBoxMouseLeave
      OnMouseMove = frequencyPaintBoxMouseMove
      OnPaint = frequencyPaintBoxPaint
      ExplicitWidth = 935
      ExplicitHeight = 352
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
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Panel3: TPanel
      Left = 0
      Top = 184
      Width = 950
      Height = 23
      Align = alBottom
      BevelEdges = [beTop, beBottom]
      BevelKind = bkSoft
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitTop = 354
      ExplicitWidth = 935
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 137
        Height = 19
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        OnMouseDown = Panel4MouseDown
        ExplicitHeight = 17
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
        Left = 209
        Top = 0
        Width = 575
        Height = 19
        Align = alClient
        Max = 3000
        Min = 500
        PageSize = 0
        Position = 1070
        TabOrder = 1
        OnChange = spacerScrollChange
        ExplicitWidth = 384
        ExplicitHeight = 17
      end
      object Panel7: TPanel
        Left = 137
        Top = 0
        Width = 72
        Height = 19
        Align = alLeft
        BevelEdges = [beLeft, beRight]
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 2
        ExplicitHeight = 17
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
        end
      end
      object Panel6: TPanel
        Left = 784
        Top = 0
        Width = 166
        Height = 19
        Align = alRight
        BevelEdges = [beLeft]
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 3
        object lbSpotTotal: TLabel
          Left = 122
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
          Width = 118
          Height = 13
          Hint = 'Double click to get last 50 spots (SH/DX 50)'
          Caption = 'Spot count total / band: '
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
    Left = 24
    Top = 13
  end
  object freqPanelMenu: TPopupMenu
    Left = 24
    Top = 72
    object isPanelHoldActive: TMenuItem
      AutoCheck = True
      Caption = 'Hold frequency panel'
      OnClick = isPanelHoldActiveClick
    end
  end
  object spotLabelMenu: TPopupMenu
    OnPopup = spotLabelMenuPopup
    Left = 24
    Top = 128
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
  end
  object refreshTimer: TTimer
    Interval = 5000
    OnTimer = refreshTimerTimer
    Left = 96
    Top = 128
  end
end

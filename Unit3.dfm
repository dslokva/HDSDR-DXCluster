object dxcViewForm: TdxcViewForm
  Left = 0
  Top = 0
  Caption = 'DX Cluster view'
  ClientHeight = 391
  ClientWidth = 768
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 730
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 331
    Width = 768
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 714
    object Panel2: TPanel
      Left = 662
      Top = 0
      Width = 106
      Height = 60
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitLeft = 608
      object Button1: TButton
        Left = 8
        Top = 24
        Width = 85
        Height = 25
        Caption = 'Close'
        TabOrder = 0
        OnClick = Button1Click
      end
    end
    object rgSortOpts: TRadioGroup
      Left = 9
      Top = 6
      Width = 155
      Height = 43
      Caption = 'Sort by:'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Frequency'
        'Local time')
      TabOrder = 1
      OnClick = btnRefreshClick
    end
    object GroupBox1: TGroupBox
      Left = 170
      Top = 5
      Width = 487
      Height = 43
      Caption = 'Band filter:'
      TabOrder = 2
      object cb12m: TCheckBox
        Left = 311
        Top = 18
        Width = 33
        Height = 17
        Caption = '12'
        TabOrder = 0
        OnClick = btnRefreshClick
      end
      object cb15m: TCheckBox
        Left = 273
        Top = 18
        Width = 33
        Height = 17
        Caption = '15'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = btnRefreshClick
      end
      object cb17m: TCheckBox
        Left = 234
        Top = 18
        Width = 33
        Height = 17
        Caption = '17'
        TabOrder = 2
        OnClick = btnRefreshClick
      end
      object cb20m: TCheckBox
        Left = 197
        Top = 18
        Width = 33
        Height = 17
        Caption = '20'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = btnRefreshClick
      end
      object cb30m: TCheckBox
        Left = 160
        Top = 18
        Width = 33
        Height = 17
        Caption = '30'
        TabOrder = 4
        OnClick = btnRefreshClick
      end
      object cb40m: TCheckBox
        Left = 124
        Top = 18
        Width = 33
        Height = 17
        Caption = '40'
        Checked = True
        State = cbChecked
        TabOrder = 5
        OnClick = btnRefreshClick
      end
      object cb80m: TCheckBox
        Left = 54
        Top = 18
        Width = 33
        Height = 17
        Caption = '80'
        Checked = True
        State = cbChecked
        TabOrder = 6
        OnClick = btnRefreshClick
      end
      object cb160m: TCheckBox
        Left = 12
        Top = 18
        Width = 36
        Height = 17
        Caption = '160'
        Checked = True
        State = cbChecked
        TabOrder = 7
        OnClick = btnRefreshClick
      end
      object cb10m: TCheckBox
        Left = 349
        Top = 18
        Width = 33
        Height = 17
        Caption = '10'
        TabOrder = 8
        OnClick = btnRefreshClick
      end
      object cb6m: TCheckBox
        Left = 385
        Top = 18
        Width = 33
        Height = 17
        Caption = '6'
        TabOrder = 9
        OnClick = btnRefreshClick
      end
      object cb2m: TCheckBox
        Left = 452
        Top = 18
        Width = 29
        Height = 17
        Caption = '2'
        TabOrder = 10
        OnClick = btnRefreshClick
      end
      object cb60m: TCheckBox
        Left = 89
        Top = 18
        Width = 33
        Height = 17
        Caption = '60'
        Checked = True
        State = cbChecked
        TabOrder = 11
        OnClick = btnRefreshClick
      end
      object cb4m: TCheckBox
        Left = 418
        Top = 18
        Width = 29
        Height = 17
        Caption = '4'
        TabOrder = 12
        OnClick = btnRefreshClick
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 768
    Height = 331
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 714
    object dxcMainTable: TStringGrid
      Left = 0
      Top = 25
      Width = 768
      Height = 265
      Align = alClient
      DefaultRowHeight = 18
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing, goRowSelect, goFixedColClick]
      TabOrder = 0
      OnDrawCell = dxcMainTableDrawCell
      ExplicitWidth = 714
      ColWidths = (
        96
        97
        100
        255
        122)
    end
    object Panel4: TPanel
      Left = 0
      Top = 290
      Width = 768
      Height = 41
      Align = alBottom
      TabOrder = 1
      ExplicitWidth = 714
      object Button3: TButton
        Left = 89
        Top = 6
        Width = 75
        Height = 25
        Caption = 'SH/DX 50'
        TabOrder = 0
        OnClick = Button3Click
      end
      object Button2: TButton
        Left = 8
        Top = 6
        Width = 75
        Height = 25
        Caption = 'SH/DX 100'
        TabOrder = 1
        OnClick = Button2Click
      end
      object Panel5: TPanel
        Left = 662
        Top = 1
        Width = 105
        Height = 39
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 2
        ExplicitLeft = 608
        object btnRefresh: TButton
          Left = 9
          Top = 5
          Width = 85
          Height = 25
          Caption = 'Refresh'
          TabOrder = 0
          OnClick = btnRefreshClick
        end
      end
    end
    object Panel6: TPanel
      Left = 0
      Top = 0
      Width = 768
      Height = 25
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitWidth = 714
      object Label1: TLabel
        Left = 8
        Top = 6
        Width = 132
        Height = 13
        Caption = 'Total / showed spot count: '
      end
      object lbSpotCount: TLabel
        Left = 146
        Top = 6
        Width = 26
        Height = 13
        Caption = '0 / 0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
end

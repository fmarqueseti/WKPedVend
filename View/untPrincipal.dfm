object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Pedido de Venda'
  ClientHeight = 561
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object grpCliente: TGroupBox
    Left = 0
    Top = 0
    Width = 784
    Height = 81
    Align = alTop
    Caption = 'Cliente'
    TabOrder = 0
    object Label1: TLabel
      Left = 43
      Top = 24
      Width = 37
      Height = 13
      Caption = 'C'#243'digo:'
    end
    object Label2: TLabel
      Left = 49
      Top = 43
      Width = 31
      Height = 13
      Caption = 'Nome:'
    end
    object lblNomeCliente: TLabel
      Left = 91
      Top = 43
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 43
      Top = 62
      Width = 37
      Height = 13
      Caption = 'Cidade:'
    end
    object lblCidadeUFCliente: TLabel
      Left = 91
      Top = 62
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtCodigoCliente: TEdit
      Left = 91
      Top = 21
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '0'
      OnKeyPress = EditKeyPressApenasNumeros
    end
    object btnBuscarCliente: TBitBtn
      Left = 218
      Top = 19
      Width = 75
      Height = 25
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = btnBuscarClienteClick
    end
    object btnCarregarPedido: TBitBtn
      Left = 323
      Top = 19
      Width = 75
      Height = 25
      Caption = 'Carregar'
      TabOrder = 2
      OnClick = btnCarregarPedidoClick
    end
    object btnCancelarPedido: TBitBtn
      Left = 323
      Top = 50
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      TabOrder = 3
      OnClick = btnCancelarPedidoClick
    end
  end
  object grpProduto: TGroupBox
    Left = 0
    Top = 81
    Width = 784
    Height = 86
    Align = alTop
    Caption = 'Produto'
    TabOrder = 1
    object Label3: TLabel
      Left = 43
      Top = 24
      Width = 37
      Height = 13
      Caption = 'C'#243'digo:'
    end
    object Label5: TLabel
      Left = 30
      Top = 43
      Width = 50
      Height = 13
      Caption = 'Descri'#231#227'o:'
    end
    object lblDescricaoProduto: TLabel
      Left = 91
      Top = 43
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 16
      Top = 62
      Width = 64
      Height = 13
      Caption = 'Pre'#231'o Venda:'
    end
    object lblPrVdaProduto: TLabel
      Left = 91
      Top = 62
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 224
      Top = 64
      Width = 22
      Height = 13
      Caption = 'Qtd:'
    end
    object edtCodigoProduto: TEdit
      Left = 91
      Top = 21
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '0'
      OnKeyPress = EditKeyPressApenasNumeros
    end
    object btnBuscarProduto: TBitBtn
      Left = 218
      Top = 19
      Width = 75
      Height = 25
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = btnBuscarProdutoClick
    end
    object btnAdicionarProduto: TBitBtn
      Left = 299
      Top = 19
      Width = 75
      Height = 25
      Caption = 'Adicionar'
      TabOrder = 2
      OnClick = btnAdicionarProdutoClick
    end
    object edtQtdProduto: TEdit
      Left = 253
      Top = 59
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '0'
      OnKeyPress = EditKeyPressApenasNumeros
    end
  end
  object grpDetalhe: TGroupBox
    Left = 0
    Top = 167
    Width = 784
    Height = 353
    Align = alClient
    Caption = 'Itens do Pedido'
    TabOrder = 2
    object grdDetalhesPedido: TStringGrid
      Left = 2
      Top = 15
      Width = 780
      Height = 336
      Align = alClient
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
      TabOrder = 0
      OnKeyDown = grdDetalhesPedidoKeyDown
      ColWidths = (
        113
        296
        64
        64
        64)
      RowHeights = (
        24)
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 520
    Width = 784
    Height = 41
    Align = alBottom
    TabOrder = 3
    object lblVlrToralPedido: TLabel
      Left = 721
      Top = 1
      Width = 62
      Height = 39
      Align = alRight
      Alignment = taCenter
      Caption = 'R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitHeight = 19
    end
    object btnGravarPedido: TBitBtn
      Left = 5
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Gravar Pedido'
      TabOrder = 0
      OnClick = btnGravarPedidoClick
    end
  end
end

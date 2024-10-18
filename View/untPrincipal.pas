unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Mask, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids,
  untFachadaBanco, untCliente, untPedidoCabecalho, untProduto, untPedidoDetalhe;


type
  TfrmPrincipal = class(TForm)
    grpCliente: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lblNomeCliente: TLabel;
    Label4: TLabel;
    lblCidadeUFCliente: TLabel;
    edtCodigoCliente: TEdit;
    btnBuscarCliente: TBitBtn;
    grpProduto: TGroupBox;
    Label3: TLabel;
    edtCodigoProduto: TEdit;
    btnBuscarProduto: TBitBtn;
    Label5: TLabel;
    lblDescricaoProduto: TLabel;
    Label7: TLabel;
    lblPrVdaProduto: TLabel;
    btnAdicionarProduto: TBitBtn;
    grpDetalhe: TGroupBox;
    grdDetalhesPedido: TStringGrid;
    Panel1: TPanel;
    lblVlrToralPedido: TLabel;
    btnGravarPedido: TBitBtn;
    Label8: TLabel;
    edtQtdProduto: TEdit;
    btnCarregarPedido: TBitBtn;
    btnCancelarPedido: TBitBtn;
    procedure EditKeyPressApenasNumeros(Sender: TObject; var Key: Char);
    procedure btnBuscarClienteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBuscarProdutoClick(Sender: TObject);
    procedure btnAdicionarProdutoClick(Sender: TObject);
    procedure grdDetalhesPedidoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure btnCarregarPedidoClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure edtCodigoClienteChange(Sender: TObject);
  private
    { Private declarations }
    FFachadaBanco: TFachadaBanco;
    FCliente: TCliente;
    FPedido: TPedidoCabecalho;
    FPedidoDetalhe: TPedidoDetalhe;
    FProduto: TProduto;

    procedure PreencherDadosCliente;
    procedure PreencherDadosProduto;
    procedure PrepararGrid;
    procedure PrencherGrid;
    procedure InformarTotalPedido;
    procedure LimparGUI;
  public
    { Public declarations }

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.PrencherGrid;
var
  LRow: Integer;
  LPedidoDetalhe: TPedidoDetalhe;
begin
  Self.PrepararGrid;
  Self.grdDetalhesPedido.RowCount := Self.FPedido.Detalhe.Count +1;

  for LRow := 0 to Self.FPedido.Detalhe.Count -1 do
  begin
    LPedidoDetalhe := Self.FPedido.Detalhe.Items[LRow];

    Self.grdDetalhesPedido.Objects[0, LRow +1] := LPedidoDetalhe;

    Self.grdDetalhesPedido.Cells[0, LRow +1] := IntToStr(LPedidoDetalhe.Produto.Codigo);
    Self.grdDetalhesPedido.Cells[1, LRow +1] := LPedidoDetalhe.Produto.Descricao;
    Self.grdDetalhesPedido.Cells[2, LRow +1] := FloatToStrF(LPedidoDetalhe.Qtd, ffFixed, 3, 2);
    Self.grdDetalhesPedido.Cells[3, LRow +1] := FloatToStrF(LPedidoDetalhe.Produto.Prvda, ffFixed, 5, 2);
    Self.grdDetalhesPedido.Cells[4, LRow +1] := FloatToStrF(LPedidoDetalhe.VlrTotal, ffFixed, 7, 2);
  end;

  Self.InformarTotalPedido;
end;

procedure TfrmPrincipal.btnAdicionarProdutoClick(Sender: TObject);
var
  LPedidoDetalhe: TPedidoDetalhe;
  LQtd: Double;
begin
  if (NOT Assigned(Self.FProduto)) then
  begin
    Self.edtCodigoProduto.SetFocus;

    raise Exception.Create('O produto ainda não foi informado.');
  end;

  TryStrToFloat(Self.edtQtdProduto.Text, LQtd);

  if (NOT Assigned(Self.FPedidoDetalhe)) then
    Self.FPedidoDetalhe := TPedidoDetalhe.Create;

  Self.FPedidoDetalhe.Produto := Self.FProduto;
  Self.FPedidoDetalhe.Qtd := LQtd;

  if (Self.FPedidoDetalhe.Ordem = 0) then
    Self.FPedido.AdicionarItemAoPedido(Self.FPedidoDetalhe);

  Self.PrencherGrid;

  Self.FProduto := Nil; // Proximo propduto
  Self.FPedidoDetalhe := Nil;
  Self.PreencherDadosProduto;

  Self.edtCodigoProduto.Enabled := True;
  Self.edtCodigoProduto.Text := '0';
  Self.edtCodigoProduto.SetFocus;
  Self.edtCodigoProduto.SelectAll;
end;

procedure TfrmPrincipal.btnBuscarClienteClick(Sender: TObject);
var
  LCodigo: Integer;
begin
  if (Assigned(Self.FCliente)) then
  begin
    if (Assigned(Self.FPedido)) then
      Self.FPedido.Free;

    Self.FCliente.Free;
  end;

  TryStrToInt(Self.edtCodigoCliente.Text, LCodigo);

  Self.FCliente := Self.FFachadaBanco.ObterCliente(LCodigo);

  if (Assigned(Self.FCliente)) then
    begin
      Self.FPedido := TPedidoCabecalho.Create;
      Self.FPedido.Cliente := Self.FCliente;
      Self.edtCodigoProduto.SetFocus;
      Self.edtCodigoProduto.SelectAll;
    end
  else
    raise Exception.Create('Cliente não encontrado');

  Self.PreencherDadosCliente;
end;

procedure TfrmPrincipal.btnBuscarProdutoClick(Sender: TObject);
var
  LCodigo: Integer;
begin
  if (NOT Assigned(Self.FCliente)) then
  begin
    Self.edtCodigoCliente.SetFocus;

    raise Exception.Create('O cliente da venda ainda não foi informado.');
  end;

  TryStrToInt(Self.edtCodigoProduto.Text, LCodigo);

  Self.FProduto := Self.FFachadaBanco.ObterProduto(LCodigo);

  if (NOT Assigned(Self.FProduto)) then
    Application.MessageBox('Produto não encontrado', 'ERRO', MB_OK + MB_ICONERROR);

  Self.PreencherDadosProduto;
  Self.edtQtdProduto.SetFocus;
  Self.edtQtdProduto.SelectAll;
end;

procedure TfrmPrincipal.btnCancelarPedidoClick(Sender: TObject);
begin
  Self.btnCarregarPedido.Click;

  if (NOT Assigned(Self.FPedido)) then
    Exit;

  if (Application.MessageBox('Confirma o cancelamento do pedido?',
                             'CONFIRMAÇÃO',
                             MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON1) = IDYES) then
  begin
    Self.FFachadaBanco.CancelarPedido(Self.FPedido.Numero);

    Application.MessageBox('Pedido cancelado.', 'AVISO', MB_OK);

    Self.LimparGUI;

    Self.edtCodigoCliente.SetFocus;
    Self.edtCodigoCliente.SelectAll;
  end;
end;

procedure TfrmPrincipal.btnCarregarPedidoClick(Sender: TObject);
var
  LInput: string;
  LCodigo: Integer;
  LPedido: TPedidoCabecalho;
begin
  InputQuery('INFORMAÇÃO', 'Informe o código do pedido para buscar:', LInput);
  TryStrToInt(LInput, LCodigo);

  LPedido := Self.FFachadaBanco.ObterPedido(LCodigo);

  if (NOT Assigned(LPedido)) then
    raise Exception.Create('Pedido não localizado');

  Self.FPedido := LPedido;
  Self.FCliente := LPedido.Cliente;

  Self.edtCodigoCliente.Text := IntToStr(Self.FCliente.Codigo);
  Self.PreencherDadosCliente;
  Self.PrencherGrid;
end;

procedure TfrmPrincipal.btnGravarPedidoClick(Sender: TObject);
begin
  if (Application.MessageBox('Confirma a gravação do pedido?',
                             'CONFIRMAÇÃO',
                             MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON1) = IDYES) then
  begin
    Self.FFachadaBanco.InserirPedido(Self.FPedido);

    if (Self.FPedido.Numero > 0) then
    begin
      Application.MessageBox(PChar('Pedido inserido sob o número: ' + IntToStr(Self.FPedido.Numero)),
                             'AVISO', MB_OK);

      Self.LimparGUI;

      Self.edtCodigoCliente.SetFocus;
      Self.edtCodigoCliente.SelectAll;
    end;
  end;
end;

procedure TfrmPrincipal.EditKeyPressApenasNumeros(Sender: TObject;
  var Key: Char);
begin
  if (Key = Char(VK_RETURN)) then
    begin
      if (Sender = Self.edtCodigoCliente) then
        Self.btnBuscarCliente.Click
      else if (Sender = Self.edtCodigoProduto) then
        Self.btnBuscarProduto.Click
      else if (Sender = Self.edtQtdProduto) then
        Self.btnAdicionarProduto.Click;
    end
  else if (NOT (CharInSet(Key, ['0'..'9']) or (Key = Char(VK_BACK)))) then
    Key := #0;
end;

procedure TfrmPrincipal.edtCodigoClienteChange(Sender: TObject);
var
  LVisible: Boolean;
begin
  LVisible := (Self.edtCodigoCliente.Text = '');

  Self.btnCarregarPedido.Visible := LVisible;
  Self.btnCancelarPedido.Visible := LVisible;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Self.FFachadaBanco.Free;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  Self.FFachadaBanco := TFachadaBanco.Create;
  Self.PrepararGrid;
end;

procedure TfrmPrincipal.grdDetalhesPedidoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Self.grdDetalhesPedido.Row > 0) then
  begin
    if (Key = VK_RETURN) then
      begin
        //Self.FPedidoDetalhe := Self.FPedido.Detalhe.Items[Self.grdDetalhesPedido.Row];
        Self.FPedidoDetalhe := TPedidoDetalhe(Self.grdDetalhesPedido.Objects[0, Self.grdDetalhesPedido.Row]);
        Self.FProduto := Self.FPedidoDetalhe.Produto;

        Self.PreencherDadosProduto;

        Self.edtCodigoProduto.Enabled := False;
        Self.edtCodigoProduto.Text := IntToStr(Self.FProduto.Codigo);
        Self.edtQtdProduto.Text := FloatToStrF(Self.FPedidoDetalhe.Qtd, ffFixed, 3, 2);
        Self.edtQtdProduto.SetFocus;
        Self.edtQtdProduto.SelectAll;
      end
    else if (Key = VK_DELETE) then
      begin
        if (Application.MessageBox('Confirma a retirada do produto do pedido?',
                                   'CONFIRMAÇÃO',
                                   MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2) = IDYES) then
        begin
          Self.FPedido.Detalhe.Delete(Self.grdDetalhesPedido.Row -1);
          Self.PrencherGrid;
          Self.edtCodigoProduto.SetFocus;
          Self.edtCodigoProduto.SelectAll;
        end;
      end;
  end;
end;

procedure TfrmPrincipal.InformarTotalPedido;
begin
  Self.lblVlrToralPedido.Caption := 'R$ ' + FloatToStrF(Self.FPedido.ValorToral, ffFixed, 7, 2);
end;

procedure TfrmPrincipal.LimparGUI;
begin
  if (Assigned(Self.FProduto)) then
    FreeAndNil(Self.FProduto);

  if (Assigned(Self.FPedidoDetalhe)) then
    FreeAndNil(Self.FPedidoDetalhe);

  if (Assigned(Self.FPedido)) then
    FreeAndNil(Self.FPedido);

  if (Assigned(Self.FCliente)) then
    FreeAndNil(Self.FCliente);

  Self.PreencherDadosCliente;
  Self.PreencherDadosProduto;
  Self.PrepararGrid;
end;

procedure TfrmPrincipal.PreencherDadosCliente;
begin
  if (Assigned(Self.FCliente)) then
    begin
      Self.lblNomeCliente.Caption := Self.FCliente.Nome;
      Self.lblCidadeUFCliente.Caption := Self.FCliente.Cidade + '/' + Self.FCliente.UF;
    end
  else
    begin
      Self.lblNomeCliente.Caption := EmptyStr;
      Self.lblCidadeUFCliente.Caption := EmptyStr;
    end;
end;

procedure TfrmPrincipal.PreencherDadosProduto;
begin
  if (Assigned(Self.FProduto)) then
    begin
      Self.lblDescricaoProduto.Caption := Self.FProduto.Descricao;
      Self.lblPrVdaProduto.Caption := 'R$ ' + FloatToStr(Self.FProduto.Prvda);
    end
  else
    begin
      Self.lblDescricaoProduto.Caption := EmptyStr;
      Self.lblPrVdaProduto.Caption := EmptyStr;
    end;

  Self.edtQtdProduto.Text := '0';
end;

procedure TfrmPrincipal.PrepararGrid;
begin
  Self.grdDetalhesPedido.RowCount := 1;

  Self.grdDetalhesPedido.Cells[0, 0] := 'Código Produto';
  Self.grdDetalhesPedido.Cells[1, 0] := 'Descrição do Produto';
  Self.grdDetalhesPedido.Cells[2, 0] := 'Qtd';
  Self.grdDetalhesPedido.Cells[3, 0] := 'Vlr Unit';
  Self.grdDetalhesPedido.Cells[4, 0] := 'Vlr Total';
end;

end.

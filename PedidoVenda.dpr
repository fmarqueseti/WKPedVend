program PedidoVenda;

uses
  Vcl.Forms,
  untPrincipal in 'View\untPrincipal.pas' {frmPrincipal},
  untConexao in 'Banco\untConexao.pas',
  untCliente in 'Model\untCliente.pas',
  untProduto in 'Model\untProduto.pas',
  untPedidoCabecalho in 'Model\untPedidoCabecalho.pas',
  untPedidoDetalhe in 'Model\untPedidoDetalhe.pas',
  untIClienteDAO in 'DAO\untIClienteDAO.pas',
  untIPedidoCabDAO in 'DAO\untIPedidoCabDAO.pas',
  untIProdutoDAO in 'DAO\untIProdutoDAO.pas',
  untClienteDAO in 'DAO\Impl\untClienteDAO.pas',
  untPedidoCabDAO in 'DAO\Impl\untPedidoCabDAO.pas',
  untProdutoDAO in 'DAO\Impl\untProdutoDAO.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.

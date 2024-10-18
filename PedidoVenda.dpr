program PedidoVenda;

uses
  Vcl.Forms,
  untPrincipal in 'View\untPrincipal.pas' {frmPrincipal},
  untConexao in 'Banco\untConexao.pas',
  untFachadaBanco in 'Banco\untFachadaBanco.pas',
  untCliente in 'Model\untCliente.pas',
  untProduto in 'Model\untProduto.pas',
  untPedidoCabecalho in 'Model\untPedidoCabecalho.pas',
  untPedidoDetalhe in 'Model\untPedidoDetalhe.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.

unit untPedidoCabecalho;

interface

uses
  untCliente, untPedidoDetalhe, System.Generics.Collections;

type
  TPedidoCabecalho = class
    private
      FNumero: Integer;
      FDataEmissao: TDate;
      FCliente: TCliente;
      FDetalhe: TList<TPedidoDetalhe>;

      procedure SetNumero(const ANumero: Integer);
      procedure SetDataEmissao(const ADataEmissao: TDate);
      function GetValorToral: Double;
    public
      constructor Create;
      destructor Destroy;

      property Numero: Integer read FNumero write SetNumero;
      property DataEmissao: TDate read FDataEmissao write SetDataEmissao;
      property Cliente: TCliente read FCliente write FCliente;
      property Detalhe: TList<TPedidoDetalhe> read FDetalhe;
      property ValorToral: Double read GetValorToral;
      procedure AdicionarItemAoPedido(ADetalhePedido: TPedidoDetalhe);
  end;

implementation

uses
  System.SysUtils;

{ TPedidoCabecalho }

procedure TPedidoCabecalho.AdicionarItemAoPedido(
  ADetalhePedido: TPedidoDetalhe);
begin
  ADetalhePedido.Ordem := Self.FDetalhe.Count +1;
  Self.Detalhe.Add(ADetalhePedido);
end;

constructor TPedidoCabecalho.Create;
begin
  Self.FDetalhe := TList<TPedidoDetalhe>.Create;
  Self.FDataEmissao := Date;
end;

destructor TPedidoCabecalho.Destroy;
begin
  Self.FDetalhe.Clear;
  Self.FDetalhe.Free;
end;

function TPedidoCabecalho.GetValorToral: Double;
var
  LContador: Integer;
  LPedidoDetalhe: TPedidoDetalhe;
begin
  Result := 0;

  // Nas versões mais modernas do Delphi pode-se se usar o foreach
  for LContador := 0 to Self.FDetalhe.Count -1 do
  begin
    LPedidoDetalhe := Self.Detalhe.Items[LContador];

    Result := Result + LPedidoDetalhe.VlrTotal;
  end;
end;

procedure TPedidoCabecalho.SetDataEmissao(const ADataEmissao: TDate);
begin
  if (ADataEmissao > Date) then
    raise Exception.Create('Emissão não pode ser uma data futura.');

  if (ADataEmissao < Date) then
    raise Exception.Create('Emissão não pode ser uma data passada.');

  Self.FDataEmissao := ADataEmissao;
end;

procedure TPedidoCabecalho.SetNumero(const ANumero: Integer);
begin
  if (ANumero <= 0) then
    raise Exception.Create('Número de pedido inválido.');

  Self.FNumero := ANumero;
end;

end.

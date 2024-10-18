unit untPedidoDetalhe;

interface

uses
  untProduto;

type
  TPedidoDetalhe = class
    private
      FOrdem: Integer;
      FProduto: TProduto;
      FQtd: Double;

      procedure SetOrdem(const AOrdem: Integer);
      procedure SetQtd(const AQtd: Double);
      function GetVlrTotal: Double;
    public
      constructor Create;
      destructor Destroy;

      property Ordem: Integer read FOrdem write SetOrdem;
      property Produto: TProduto read FProduto write FProduto;
      property Qtd: Double read FQtd write SetQtd;
      property VlrTotal: Double read GetVlrTotal;
  end;

implementation

uses
  System.SysUtils;

{ TPedidoDetalhe }

constructor TPedidoDetalhe.Create;
begin
  Self.FOrdem := 0;
  Self.FProduto := Nil;
  Self.FQtd := 0;
end;

destructor TPedidoDetalhe.Destroy;
begin
  if (Assigned(Self.FProduto)) then
    FProduto.Free;

  inherited;
end;

function TPedidoDetalhe.GetVlrTotal: Double;
begin
  if (NOT Assigned(Self.FProduto)) then
    raise Exception.Create('O produto ainda não foi informado');

  Result := Self.FProduto.Prvda * Self.FQtd;
end;

procedure TPedidoDetalhe.SetOrdem(const AOrdem: Integer);
begin
  if (AOrdem <= 0) then
    raise Exception.Create('Ordem inválida');

  Self.FOrdem := AOrdem;
end;

procedure TPedidoDetalhe.SetQtd(const AQtd: Double);
begin
  if (AQtd <= 0) then
    raise Exception.Create('Quantidade inválida');

  Self.FQtd := AQtd;
end;

end.

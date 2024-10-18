unit untFachadaBanco;

interface

uses
  untConexao, untCliente, untProduto, untPedidoCabecalho, untPedidoDetalhe,
  Data.DB;

  type TFachadaBanco = class
    private
      FConecao: TConexao;
    public
      constructor Create; virtual;
      destructor Destroy; override;

      function ObterCliente(ACodigo: Integer): TCliente;
      function ObterProduto(ACodigo: Integer): TProduto;
      function ObterPedido(ACodigo: Integer): TPedidoCabecalho;
      procedure InserirPedido(APedido: TPedidoCabecalho);
      procedure CancelarPedido(ACodigo: Integer);
  end;

implementation

uses
  System.SysUtils;

{ TFachadaBanco }

procedure TFachadaBanco.CancelarPedido(ACodigo: Integer);
var
  LSQL: string;
begin
  LSQL := 'DELETE FROM PEDIDODET WHERE PEDIDO = ' + IntToStr(ACodigo) + '; ' +
          'DELETE FROM PEDIDOCAB WHERE NUMERO = ' + IntToStr(ACodigo) + '; ';

  Self.FConecao.ExecutarConsulta(LSQL);
end;

constructor TFachadaBanco.Create;
begin
  inherited;
  Self.FConecao := TConexao.GetInstance;
  Self.FConecao.Conectar;
end;

destructor TFachadaBanco.Destroy;
begin
  Self.FConecao.Desconectar;
  Self.FConecao.Free;
  inherited;
end;

procedure TFachadaBanco.InserirPedido(APedido: TPedidoCabecalho);

  function FormatarValor(AValor: Double): string;
  var
    LFormatSettings: TFormatSettings;
  begin
    LFormatSettings := FormatSettings;

    FormatSettings.DecimalSeparator := '.';
    Result := FloatToStr(AValor);

    FormatSettings := LFormatSettings;
  end;

var
  LSQL: string;
  LContador: Integer;
  LPedidoDetalhe: TPedidoDetalhe;
begin
  LSQL := 'INSERT INTO PEDIDOCAB (DTEMISS, CLIENTE, VLRTOT) ' +
          'VALUES (' + QuotedStr(FormatDateTime('yyyy-mm-dd', APedido.DataEmissao)) + ', ' +
                       IntToStr(APedido.Cliente.Codigo) + ', ' +
                       FormatarValor(APedido.ValorToral) + ');';

  Self.FConecao.IniarTransacao;
  try
    APedido.Numero := Self.FConecao.ExecutarConsulta(LSQL, 'PEDIDOCAB');

    // Nas versoes mais recentes do Delphi, poderia-se utilizar o for each
    for LContador := 0 to APedido.Detalhe.Count -1 do
    begin
      LPedidoDetalhe := APedido.Detalhe.Items[LContador];

      LSQL := 'INSERT INTO PEDIDODET (PEDIDO, PRODUTO, QTD, VLRUNIT, VLRTOT) ' +
              'VALUES (' + IntToStr(APedido.Numero) + ', ' +
                           IntToStr(LPedidoDetalhe.Produto.Codigo) + ', ' +
                           FormatarValor(LPedidoDetalhe.Qtd) + ', ' +
                           FormatarValor(LPedidoDetalhe.Produto.Prvda) + ', ' +
                           FormatarValor(LPedidoDetalhe.VlrTotal) + '); ';

      Self.FConecao.ExecutarConsulta(LSQL);
    end;

    Self.FConecao.ConfirmarTransacao;
  finally
    Self.FConecao.DesfazerTransacao;
  end;
end;

function TFachadaBanco.ObterCliente(ACodigo: Integer): TCliente;
var
  LSQL: string;
  LDataSet: TDataSet;
begin
  LSQL := 'SELECT NOME, CIDADE, UF ' +
          'FROM CLIENTE ' +
          'WHERE CODIGO = ' + Inttostr(ACodigo);
  Result := Nil;

  LDataSet := Self.FConecao.AbrirConsulta(LSQL);
  try
    if (NOT LDataSet.EOF) then
    begin
      Result := TCliente.Create(ACodigo,
                                LDataSet.FieldByName('NOME').AsString,
                                LDataSet.FieldByName('CIDADE').AsString,
                                LDataSet.FieldByName('UF').AsString);
    end;
  finally
    LDataSet.Close;
    LDataSet.Free;
  end;
end;

function TFachadaBanco.ObterProduto(ACodigo: Integer): TProduto;
var
  LSQL: string;
  LDataSet: TDataSet;
begin
  LSQL := 'SELECT DESCRICAO, PRVDA ' +
          'FROM PRODUTO ' +
          'WHERE CODIGO = ' + Inttostr(ACodigo);
  Result := Nil;

  LDataSet := Self.FConecao.AbrirConsulta(LSQL);
  try
    if (NOT LDataSet.EOF) then
    begin
      Result := TProduto.Create(ACodigo,
                                LDataSet.FieldByName('DESCRICAO').AsString,
                                LDataSet.FieldByName('PRVDA').AsFloat);
    end;
  finally
    LDataSet.Close;
    LDataSet.Free;
  end;
end;

function TFachadaBanco.ObterPedido(ACodigo: Integer): TPedidoCabecalho;
var
  LSQL: string;
  LDataSet: TDataSet;
  LPedidoDetalhe: TPedidoDetalhe;
begin
  LSQL := ' SELECT ' +
          '     CLI.CODIGO    AS CLI_CODIGO, ' +
          '     CLI.NOME      AS CLI_NOME, ' +
          '     CLI.CIDADE    AS CLI_CIDADE, ' +
          '     CLI.UF        AS CLI_UF, ' +

          '     CAB.NUMERO    AS CAB_NUMERO, ' +
          '     CAB.DTEMISS   AS CAB_DTEMISS, ' +

          '     PRO.CODIGO    AS PRO_CODIGO, ' +
          '     PRO.DESCRICAO AS PRO_DESCRICAO, ' +
          '     PRO.PRVDA     AS PRO_PRVDA, ' +

          '     DET.ORDEM     AS DET_ORDEM, ' +
          '     DET.QTD       AS DET_QTD ' +

          '     FROM PEDIDOCAB CAB ' +
          '     INNER JOIN PEDIDODET DET ' +
          '          ON DET.PEDIDO = CAB.NUMERO ' +
          '     INNER JOIN CLIENTE CLI ' +
          '          ON CLI.CODIGO = CAB.CLIENTE' +
          '     INNER JOIN PRODUTO PRO ' +
          '          ON PRO.CODIGO = DET.PRODUTO' +
          '     WHERE   CAB.NUMERO = ' + IntToStr(ACodigo) +
          '     ORDER BY DET.ORDEM; ';

  Result := Nil;

  LDataSet := Self.FConecao.AbrirConsulta(LSQL);
  try
    if (NOT LDataSet.EOF) then
    begin
      Result := TPedidoCabecalho.Create;

      Result.Numero := LDataSet.FieldByName('CAB_NUMERO').AsInteger;
      Result.DataEmissao := LDataSet.FieldByName('CAB_DTEMISS').AsDateTime;

      Result.Cliente := TCliente.Create(LDataSet.FieldByName('CLI_CODIGO').AsInteger,
                                        LDataSet.FieldByName('CLI_NOME').AsString,
                                        LDataSet.FieldByName('CLI_CIDADE').AsString,
                                        LDataSet.FieldByName('CLI_UF').AsString);

      while (NOT LDataSet.EOF) do
      begin
        LPedidoDetalhe := TPedidoDetalhe.Create;

        LPedidoDetalhe.Ordem := LDataSet.FieldByName('DET_ORDEM').AsInteger;
        LPedidoDetalhe.Qtd := LDataSet.FieldByName('DET_QTD').AsFloat;
        LPedidoDetalhe.Produto := TProduto.Create(LDataSet.FieldByName('PRO_CODIGO').AsInteger,
                                                  LDataSet.FieldByName('PRO_DESCRICAO').AsString,
                                                  LDataSet.FieldByName('PRO_PRVDA').AsFloat);

        Result.AdicionarItemAoPedido(LPedidoDetalhe);
        LDataSet.Next;
      end;
    end;
  finally
    LDataSet.Close;
    LDataSet.Free;
  end;
end;

end.

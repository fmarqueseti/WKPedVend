unit untProdutoDAO;

interface

uses
  untIProdutoDAO, untConexao, untProduto;

type
  TProdutoDAO = class(TInterfacedObject, IProdutoDAO)
  private
    FConexao: TConexao;
  public
    constructor Create;
    destructor Destroy; override;
    function ObterPorID(ACodigo: Integer): TProduto;
  end;

implementation

uses
  Data.DB, System.SysUtils;

{ TProdutoDAOMySQL }

constructor TProdutoDAO.Create;
begin
  inherited;

  Self.FConexao := TConexao.GetInstance;
end;

destructor TProdutoDAO.Destroy;
begin

  inherited;
end;

function TProdutoDAO.ObterPorID(ACodigo: Integer): TProduto;
var
  LSQL: string;
  LDataSet: TDataSet;
begin
  LSQL := 'SELECT DESCRICAO, PRVDA ' +
          'FROM PRODUTO ' +
          'WHERE CODIGO = ' + IntToStr(ACodigo);
  Result := Nil;

  LDataSet := Self.FConexao.AbrirConsulta(LSQL);
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

end.

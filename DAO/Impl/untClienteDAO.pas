unit untClienteDAO;

interface

uses
  untIClienteDAO, untCliente, untConexao;

type
  TClienteDAO = class (TInterfacedObject, IClienteDAO)
    private
      FConexao: TConexao;
    public
      constructor Create;
      destructor Destroy; override;
      function ObterPorID(ACodigo: Integer): TCliente;
  end;

implementation

uses
  Data.DB, System.SysUtils;

{ TClienteDAO }

constructor TClienteDAO.Create;
begin
  inherited;

  Self.FConexao := TConexao.GetInstance;
end;

destructor TClienteDAO.Destroy;
begin

  inherited;
end;

function TClienteDAO.ObterPorID(ACodigo: Integer): TCliente;
var
  LSQL: string;
  LDataSet: TDataSet;
begin
  LSQL := 'SELECT NOME, CIDADE, UF ' +
          'FROM CLIENTE ' +
          'WHERE CODIGO = ' + IntToStr(ACodigo);
  Result := Nil;

  LDataSet := Self.FConexao.AbrirConsulta(LSQL);
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

end.

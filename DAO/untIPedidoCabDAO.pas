unit untIPedidoCabDAO;

interface

uses
  untPedidoCabecalho;

type
  IPedidoCabDAO = interface
    ['{61A1486A-D53B-4B08-9BA8-8642DE50295B}']
    function ObterPorID(ACodigo: Integer): TPedidoCabecalho;
    procedure Adicionar(APedido: TPedidoCabecalho);
    procedure Cancelar(ACodigo: Integer);
  end;

implementation

end.

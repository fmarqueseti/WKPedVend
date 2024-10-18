unit untIProdutoDAO;

interface

uses
  untProduto;

type
  IProdutoDAO = interface
    ['{D4C7D218-88BF-4DCF-BB53-7BFB539C74BD}']
    function ObterPorID(ACodigo: Integer): TProduto;
  end;

implementation

end.

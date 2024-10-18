unit untIClienteDAO;

interface

uses
  untCliente;

type
  IClienteDAO = interface
    ['{C3AA6CAF-D720-4489-9ADA-1D270116D195}']
    function ObterPorID(ACodigo: Integer): TCliente;
  end;

implementation

end.

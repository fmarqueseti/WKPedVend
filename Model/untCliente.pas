unit untCliente;

interface

type
  TCliente = class
    private
      FCodigo: Integer;
      FNome: string;
      FCidade: string;
      FUF: string;

      // M�todos de acessores
      procedure SetCodigo(const ACodigo: Integer);
      procedure SetNome(const ANome: string);
      procedure SetCidade(const ACidade: string);
      procedure SetUF(const AUF: string);
    public
      constructor Create(ACodigo: Integer; ANome, ACidade, AUF: string);

      // Propriedades
      property Codigo: Integer read FCodigo write SetCodigo;
      property Nome: string read FNome write SetNome;
      property Cidade: string read FCidade write SetCidade;
      property UF: string read FUF write SetUF;
    end;

implementation

uses
  System.SysUtils;

{ TCliente }

constructor TCliente.Create(ACodigo: Integer; ANome, ACidade, AUF: string);
begin
  Self.FCodigo := ACodigo;
  Self.FNome := ANome;
  Self.FCidade := ACidade;
  Self.FUF := AUF;
end;

procedure TCliente.SetCidade(const ACidade: string);
begin
  if (Length(ACidade) < 5) then
    raise Exception.Create('Cidade inv�lida!');

  Self.FCidade := ACidade;
end;

procedure TCliente.SetCodigo(const ACodigo: Integer);
begin
  Self.FCodigo := ACodigo;
end;

procedure TCliente.SetNome(const ANome: string);
begin
  if (Length(ANome) < 5) then
    raise Exception.Create('Nome inv�lido!');

  Self.FNome := ANome;
end;

procedure TCliente.SetUF(const AUF: string);
begin
  if (Length(AUF) <> 2) then
    raise Exception.Create('UF inv�lida!');

  Self.FUF := AUF;
end;

end.

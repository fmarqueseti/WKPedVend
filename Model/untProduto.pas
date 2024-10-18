unit untProduto;

interface

type
  TProduto = class
    private
       FCodigo: Integer;
       FDescricao: string;
       FPrvda: Double;

       // Metodos acessores
       procedure SetCodigo(const ACodigo: Integer);
       procedure SetDescricao(const ADescricao: string);
       procedure SetPrvda(const APrvda: Double);
     public
       constructor Create(ACodigo: Integer; ADescricao: string; APrvda: Double);

       // Propriedades
       property Codigo: Integer read FCodigo write SetCodigo;
       property Descricao: string read FDescricao write SetDescricao;
       property Prvda: Double read FPrvda write SetPrvda;
     end;

implementation

uses
  System.SysUtils;

{ TProduto }

constructor TProduto.Create(ACodigo: Integer; ADescricao: string;
  APrvda: Double);
begin
  Self.FCodigo := ACodigo;
  Self.FDescricao := ADescricao;
  Self.FPrvda := APrvda;
end;

procedure TProduto.SetCodigo(const ACodigo: Integer);
begin
  if (ACodigo <= 0) then
    raise Exception.Create('C�digo inv�lido!');

  Self.FCodigo := ACodigo;
end;

procedure TProduto.SetDescricao(const ADescricao: string);
begin
  if (Length(ADescricao) < 5) then
    raise Exception.Create('Descri��o inv�lida!');


  Self.FDescricao := ADescricao;
end;

procedure TProduto.SetPrvda(const APrvda: Double);
begin
  if (APrvda <= 0) then
    raise Exception.Create('Pre�o de venda inv�lido!');

  Self.FPrvda := APrvda;
end;

end.

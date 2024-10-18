unit untConexao;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.Phys.MySQL, FireDAC.Phys, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Intf, FireDAC.VCLUI.Wait, Data.DB;

  type
     TConexao = class
     private
       class var FInstance: TConexao; // Singleton
       FDriverLink: TFDPhysMySQLDriverLink;
       FConexao: TFDConnection;
       FDatabase: string;
       FUsername: string;
       FServer: string;
       FPort: Integer;
       FPassword: string;
       FDllPath: string;

       procedure LerConfig;
       constructor Create;
     public
       class function GetInstance: TConexao; static;
       procedure Conectar;
       procedure Desconectar;
       procedure IniarTransacao;
       procedure ConfirmarTransacao;
       procedure DesfazerTransacao;

       function AbrirConsulta(ASQL: string): TDataSet;
       function ExecutarConsulta(ASQL: string; ATabela: string = ''): Integer;
     end;

implementation

uses
  IniFiles, Vcl.Forms;

{ TConexao }

function TConexao.AbrirConsulta(ASQL: string): TDataSet;
var
  LQuery: TFDQuery;
begin
  try
    LQuery := TFDQuery.Create(nil);
    LQuery.Connection := Self.FConexao;
    LQuery.SQL.Text := ASQL;
    LQuery.Open;

    Result := LQuery;
  except
    on E: Exception do
      raise Exception.Create('Erro ao abrir a consulta: '  + E.Message);
  end;
end;

procedure TConexao.Conectar;
begin
  if (Self.FConexao.Connected) then
    Exit;

  try
    FConexao.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao banco: '  + E.Message);
  end;
end;

procedure TConexao.ConfirmarTransacao;
begin
  Self.FConexao.Commit;
end;

constructor TConexao.Create;
begin
  FInstance.LerConfig;

  Self.FDriverLink := TFDPhysMySQLDriverLink.Create(nil);
  Self.FConexao := TFDConnection.Create(nil);

  FDriverLink.VendorLib := Self.FDllPath;

  FConexao.DriverName := 'MySQL';
  FConexao.Params.Add('Server=' + Self.FServer);
  FConexao.Params.Add('Database=' + Self.FDatabase);
  FConexao.Params.Add('User_Name=' + Self.FUsername);
  FConexao.Params.Add('Password=' + Self.FPassword);
  FConexao.Params.Add('Port=' + IntToStr(Self.FPort));
end;

procedure TConexao.Desconectar;
begin
  if (NOT Assigned(Self.FConexao)) then
    Exit;

  if (NOT Self.FConexao.Connected) then
    Exit;

  try
    FConexao.Connected := False;
  except
    on E: Exception do
      raise Exception.Create('Erro ao desconectar do banco: '  + E.Message);
  end;
end;

procedure TConexao.DesfazerTransacao;
begin
  Self.FConexao.Rollback;
end;

function TConexao.ExecutarConsulta(ASQL, ATabela: string): Integer;
var
  LQuery: TFDQuery;
begin
  Result := 0;

  try
    LQuery := TFDQuery.Create(nil);
    LQuery.Connection := Self.FConexao;
    LQuery.SQL.Text := ASQL;
    LQuery.ExecSQL;

    if (ATabela <> EmptyStr) then
      Result := Self.FConexao.GetLastAutoGenValue(ATabela);

    LQuery.Free;
  except
    on E: Exception do
      raise Exception.Create('Erro ao executar consulta: '  + E.Message);
  end;
end;

class function TConexao.GetInstance: TConexao;
begin
  if (NOT Assigned(FInstance)) then
    FInstance := TConexao.Create;

  Result := FInstance;
end;

procedure TConexao.IniarTransacao;
begin
  Self.FConexao.StartTransaction;
end;

procedure TConexao.LerConfig;
var
  LIniFile: TIniFile;
  LIniFilePath: string;
begin
  LIniFilePath := ExtractFilePath(Application.ExeName) + 'conexao.ini';
  LIniFile := TIniFile.Create(LIniFilePath);
  try
    Self.FDatabase := LIniFile.ReadString('Database', 'DatabaseName', '');
    Self.FUsername := LIniFile.ReadString('Database', 'Username', '');
    Self.FServer := LIniFile.ReadString('Database', 'Server', '');
    Self.FPort := LIniFile.ReadInteger('Database', 'Port', 0);
    Self.FPassword := LIniFile.ReadString('Database', 'Password', '');
    Self.FDllPath := LIniFile.ReadString('Paths', 'DllPath', '');
  finally
    LIniFile.Free;
  end;
end;

end.

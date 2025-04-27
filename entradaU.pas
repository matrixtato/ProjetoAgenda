unit entradaU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  dxGDIPlusClasses;

type
  TEntrada = class(TForm)
    Image1: TImage;
    btnFechar: TButton;
    btnCalendario: TButton;
    btnOrdem: TButton;
    procedure btnFecharClick(Sender: TObject);
    procedure btnCalendarioClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOrdemClick(Sender: TObject);
    procedure AbrirForma(var Forma: TForm; ClasseForma: TFormClass);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Entrada: TEntrada;

implementation

uses
  Agenda, chamados;

{$R *.dfm}

{procedure TEntrada.FormCreate(Sender: TObject);
var
  EventosHoje: TStringList;
  DataStr: string;
  i: Integer;
  Mensagem: string;
  Arquivo: TextFile;
begin
  // Verifica eventos para o dia atual e exibe mensagem
  EventosHoje := TStringList.Create;
  try
    DataStr := FormatDateTime('dd/mm/yyyy', Trunc(Now));
    if FileExists('eventos.txt') then
    begin
      AssignFile(Arquivo, 'eventos.txt');
      try
        Reset(Arquivo);
        while not EOF(Arquivo) do
        begin
          ReadLn(Arquivo, Mensagem);
          if (Trim(Mensagem) <> '') and (Pos(DataStr + ':', Mensagem) = 1) then
            EventosHoje.Add(Copy(Mensagem, Length(DataStr) + 2, MaxInt));
        end;
      except
        on E: Exception do
          ShowMessage('Erro ao verificar eventos de hoje: ' + E.Message);
      end;
      CloseFile(Arquivo);
    end;

    if EventosHoje.Count > 0 then
    begin
      Mensagem := 'Eventos de hoje (' + DataStr + '):' + #13#10;
      for i := 0 to EventosHoje.Count - 1 do
        Mensagem := Mensagem + '- ' + EventosHoje[i] + #13#10;
      ShowMessage(Mensagem);
    end
    else
      ShowMessage('Nenhum evento para hoje (' + DataStr + ').');
  finally
    EventosHoje.Free;
  end;
end;   }

procedure TEntrada.FormCreate(Sender: TObject);
var
  EventosHoje: TStringList;
  DataStr, Mensagem, Linha: string;
  i: Integer;
  Arquivo: TextFile;
begin
  EventosHoje := TStringList.Create;
  try
    DataStr := FormatDateTime('dd/mm/yyyy', Trunc(Now));
    if FileExists('eventos.txt') then
    begin
      AssignFile(Arquivo, 'eventos.txt');
      try
        Reset(Arquivo);
        try
          while not EOF(Arquivo) do
          begin
            ReadLn(Arquivo, Linha);
            if (Trim(Linha) <> '') and (Pos(DataStr + ':', Linha) = 1) then
              EventosHoje.Add(Copy(Linha, Length(DataStr) + 2, MaxInt));
          end;
        finally
          CloseFile(Arquivo);
        end;
      except
        on E: Exception do
          ShowMessage('Erro ao verificar eventos de hoje: ' + E.Message);
      end;
    end;

    if EventosHoje.Count > 0 then
    begin
      Mensagem := 'Eventos de hoje (' + DataStr + '):' + #13#10;
      for i := 0 to EventosHoje.Count - 1 do
        Mensagem := Mensagem + '- ' + EventosHoje[i] + #13#10;
      ShowMessage(Mensagem);
    end
    else
      ShowMessage('Nenhum evento para hoje (' + DataStr + ').');
  finally
    EventosHoje.Free;
  end;
end;

procedure TEntrada.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TEntrada.AbrirForma(var Forma: TForm; ClasseForma: TFormClass);
begin
  if not Assigned(Forma) then
    Forma := ClasseForma.Create(Entrada);
  Forma.Show;
  Entrada.Hide;
end;

procedure TEntrada.btnCalendarioClick(Sender: TObject);
begin
  AbrirForma(TForm(fAgenda), TfAgenda);
end;

procedure TEntrada.btnOrdemClick(Sender: TObject);
begin
  AbrirForma(TForm(Atendimentos), TAtendimentos);
end;

{procedure TEntrada.btnOrdemClick(Sender: TObject);
begin
  if Assigned(Atendimentos) then
  begin
    Atendimentos.Show;
    Entrada.Hide;
  end
  else
  begin
    Atendimentos := TAtendimentos.Create(nil);
    Atendimentos.Show;
    Entrada.Hide;
  end;
end;

procedure TEntrada.btnCalendarioClick(Sender: TObject);
begin
  if Assigned(fAgenda) then
  begin
    fAgenda.Show;
    Entrada.Hide;
  end
  else
  begin
    fAgenda := TfAgenda.Create(nil);
    fAgenda.Show;
    Entrada.Hide;
  end;
end;

procedure TEntrada.btnCalendarioClick(Sender: TObject);
begin
  if not Assigned(fAgenda) then
    fAgenda := TfAgenda.Create(Entrada); // Entrada como Owner
  fAgenda.Show;
  Entrada.Hide;
end; }

end.

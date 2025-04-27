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
      //ShowMessage('Nenhum evento para hoje (' + DataStr + ').');
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

end.

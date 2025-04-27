unit agenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, System.DateUtils,
  Vcl.Menus;

type
  TfAgenda = class(TForm)
    MemoEventos: TMemo;
    btnSalvar: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    Calendar1: TMonthCalendar;
    TimerVerificaDia: TTimer;
    TimerLembrete: TTimer;
    cbIntervaloLembrete: TComboBox;
    btnAtivarLembrete: TButton;
    shpIndicadorLembrete: TShape;
    lblStatusLembrete: TLabel;
    TrayIcon: TTrayIcon;
    btnVoltar: TButton;
    btnMinimizar: TButton;
    pmTrayMenu: TPopupMenu;
    miRestaurar: TMenuItem;
    miSair: TMenuItem;
    procedure Calendar1Click(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MemoEventosExit(Sender: TObject);
    procedure TimerVerificaDiaTimer(Sender: TObject);
    procedure TimerLembreteTimer(Sender: TObject);
    procedure btnAtivarLembreteClick(Sender: TObject);
    procedure miRestaurarClick(Sender: TObject);
    procedure miSairClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnMinimizarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FEditando: Boolean; // Controla se está no modo de edição
    FLembreteAtivo: Boolean; // Controla se o lembrete periódico está ativo
    procedure CarregarEventosDoDia;
    procedure SalvarEventosDoDia;
    procedure ExcluirEventosDoDia;
    procedure VerificarEdicaoPendente;
    procedure HabilitarEdicao(Habilitar: Boolean);
    procedure ExibirEventosDia;
    procedure ConfigurarLembrete(IntervaloMinutos: Integer);
    procedure AtualizarIndicadorLembrete;
  public
    { Public declarations }
  end;

var
  fAgenda: TfAgenda;

implementation

uses
  entradaU;

{$R *.dfm}

const
  ARQUIVO_EVENTOS = 'eventos.txt'; // Arquivo para armazenar eventos

procedure TfAgenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Oculta o formulário e mostra na bandeja do sistema
  Action := caNone;
  Hide;
  TrayIcon.Visible := True;
  //Entrada.Show;
end;

procedure TfAgenda.FormCreate(Sender: TObject);
var
  Agora, ProximaVerificacao: TDateTime;
begin
  // Define a data inicial como a data atual
  Calendar1.Date := Trunc(Now);
  // Inicializa o estado de edição
  FEditando := False;
  FLembreteAtivo := False;

  // Configura o ComboBox com intervalos de lembrete
  cbIntervaloLembrete.Items.Add('15 minutos');
  cbIntervaloLembrete.Items.Add('30 minutos');
  cbIntervaloLembrete.Items.Add('45 minutos');
  cbIntervaloLembrete.Items.Add('1 hora');
  cbIntervaloLembrete.ItemIndex := 0;

  // Configura o timer de lembrete (inicialmente desativado)
  TimerLembrete.Enabled := False;

  // Configura o indicador de lembrete inicial
  AtualizarIndicadorLembrete;

  // Configura o TrayIcon
  TrayIcon.Hint := 'Agenda - Lembretes';
  TrayIcon.Visible := False;

  // Carrega os eventos do dia atual
  CarregarEventosDoDia;

  // Configura o timer para verificar às 8h
  Agora := Now;
  ProximaVerificacao := Trunc(Agora) + EncodeTime(8, 0, 0, 0);
  if Agora > ProximaVerificacao then
    ProximaVerificacao := ProximaVerificacao + 1; // Próximo dia
  TimerVerificaDia.Interval := Round((ProximaVerificacao - Agora) * 24 * 60 * 60 * 1000);
  TimerVerificaDia.Enabled := True;
end;

procedure TfAgenda.FormDestroy(Sender: TObject);
begin
  TrayIcon.Visible := False;
end;

procedure TfAgenda.Calendar1Click(Sender: TObject);
begin
  // Verifica se há edição pendente antes de mudar a data
  VerificarEdicaoPendente;
  // Carrega os eventos do dia selecionado
  CarregarEventosDoDia;
end;

procedure TfAgenda.btnSalvarClick(Sender: TObject);
begin
  if not FEditando and (MemoEventos.Lines.Count = 0) then
  begin
    ShowMessage('Nenhum evento para salvar!');
    Exit;
  end;

  // Salva os eventos do dia atual
  SalvarEventosDoDia;
  // Recarrega os eventos para confirmar a atualização
  CarregarEventosDoDia;
  // Desativa o modo de edição
  HabilitarEdicao(False);
  ShowMessage('Eventos salvos com sucesso!');
end;

procedure TfAgenda.btnVoltarClick(Sender: TObject);
begin
  TrayIcon.Visible := False; // Desativa o ícone ao voltar
  Entrada.Show;
  fAgenda.Hide;
end;

procedure TfAgenda.btnEditarClick(Sender: TObject);
begin
  // Habilita o modo de edição
  HabilitarEdicao(True);
  ShowMessage('Modo de edição ativado.');
end;

procedure TfAgenda.btnExcluirClick(Sender: TObject);
begin
  if MemoEventos.Lines.Count = 0 then
  begin
    ShowMessage('Nenhum evento para excluir!');
    Exit;
  end;

  // Confirma exclusão
  if MessageDlg('Deseja realmente excluir os eventos do dia ' + FormatDateTime('dd/mm/yyyy', Calendar1.Date) + '?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ExcluirEventosDoDia;
    CarregarEventosDoDia;
    ShowMessage('Eventos excluídos com sucesso!');
  end;
end;

procedure TfAgenda.btnMinimizarClick(Sender: TObject);
begin
  Hide;
  TrayIcon.Visible := True;
end;

procedure TfAgenda.btnAtivarLembreteClick(Sender: TObject);
begin
  if FLembreteAtivo then
  begin
    // Desativa o lembrete
    TimerLembrete.Enabled := False;
    FLembreteAtivo := False;
    btnAtivarLembrete.Caption := 'Ativar Lembrete';
    ShowMessage('Lembrete desativado.');
  end
  else
  begin
    // Ativa o lembrete com o intervalo selecionado
    case cbIntervaloLembrete.ItemIndex of
      0: ConfigurarLembrete(15); // 15 minutos
      1: ConfigurarLembrete(30); // 30 minutos
      2: ConfigurarLembrete(45); // 45 minutos
      3: ConfigurarLembrete(60); // 1 hora
    end;
    FLembreteAtivo := True;
    btnAtivarLembrete.Caption := 'Desativar Lembrete';
    ShowMessage('Lembrete ativado para ' + cbIntervaloLembrete.Text + '.');
  end;
  // Atualiza o indicador visual
  AtualizarIndicadorLembrete;
end;

procedure TfAgenda.MemoEventosExit(Sender: TObject);
begin
  // Verifica se há edição pendente ao sair do Memo
  VerificarEdicaoPendente;
end;

{procedure TfAgenda.TimerVerificaDiaTimer(Sender: TObject);
var
  HoraAtual: TDateTime;
begin
  // Verifica se é 8h da manhã
  HoraAtual := Time;
  if (HourOf(HoraAtual) = 8) and (MinuteOf(HoraAtual) = 0) then
  begin
    Calendar1.Date := Trunc(Now); // Atualiza para o dia atual
    CarregarEventosDoDia;
    ExibirEventosDia;
  end;
end;  }

procedure TfAgenda.TimerVerificaDiaTimer(Sender: TObject);
begin
  Calendar1.Date := Trunc(Now);
  CarregarEventosDoDia;
  ExibirEventosDia;
  TimerVerificaDia.Interval := 24 * 60 * 60 * 1000; // Próximo dia
end;

procedure TfAgenda.TimerLembreteTimer(Sender: TObject);
begin
  // Exibe os eventos do dia atual, se houver
  ExibirEventosDia;
end;

procedure TfAgenda.miRestaurarClick(Sender: TObject);
begin
  if not Visible then
  begin
    Show;
    WindowState := wsNormal;
    TrayIcon.Visible := False;
  end;
end;

procedure TfAgenda.miSairClick(Sender: TObject);
begin
  // Fecha a aplicação completamente
  TrayIcon.Visible := False;
  Application.Terminate;
end;

procedure TfAgenda.TrayIconDblClick(Sender: TObject);
begin
  // Restaura o formulário ao clicar duas vezes no ícone
  miRestaurarClick(Sender);
end;

procedure TfAgenda.CarregarEventosDoDia;
var
  Arquivo: TextFile;
  Linha: string;
  DataStr: string;
  TemEventos: Boolean;
begin
  MemoEventos.Clear;
  DataStr := FormatDateTime('dd/mm/yyyy', Calendar1.Date); // Formato dd/mm/aaaa
  TemEventos := False;

  if FileExists(ARQUIVO_EVENTOS) then
  begin
    AssignFile(Arquivo, ARQUIVO_EVENTOS);
    try
      Reset(Arquivo);
      while not EOF(Arquivo) do
      begin
        ReadLn(Arquivo, Linha);
        if Trim(Linha) <> '' then // Ignora linhas vazias
        begin
          if Pos(DataStr + ':', Linha) = 1 then
          begin
            MemoEventos.Lines.Add(Copy(Linha, Length(DataStr) + 2, MaxInt));
            TemEventos := True;
          end;
        end;
      end;
    except
      on E: Exception do
        ShowMessage('Erro ao carregar eventos: ' + E.Message);
    end;
    CloseFile(Arquivo);
  end;

  // Configura o estado do Memo e botões
  if TemEventos then
  begin
    MemoEventos.ReadOnly := True;
    btnEditar.Enabled := True;
    btnExcluir.Enabled := True;
    btnSalvar.Enabled := False;
  end
  else
  begin
    MemoEventos.ReadOnly := False;
    btnEditar.Enabled := False;
    btnExcluir.Enabled := False;
    btnSalvar.Enabled := True;
  end;

  FEditando := False;
end;

procedure TfAgenda.SalvarEventosDoDia;
var
  Arquivo: TextFile;
  TempFile: TextFile;
  Linha, DataStr, TempFileName: string;
  i: Integer;
begin
  DataStr := FormatDateTime('dd/mm/yyyy', Calendar1.Date); // Formato dd/mm/aaaa
  TempFileName := 'temp_eventos.txt';

  // Cria um arquivo temporário
  AssignFile(TempFile, TempFileName);
  try
    Rewrite(TempFile);

    // Copia eventos existentes, exceto os da data atual
    if FileExists(ARQUIVO_EVENTOS) then
    begin
      AssignFile(Arquivo, ARQUIVO_EVENTOS);
      try
        Reset(Arquivo);
        while not EOF(Arquivo) do
        begin
          ReadLn(Arquivo, Linha);
          if (Trim(Linha) <> '') and (Pos(DataStr + ':', Linha) <> 1) then
            WriteLn(TempFile, Linha);
        end;
      except
        on E: Exception do
          ShowMessage('Erro ao ler eventos existentes: ' + E.Message);
      end;
      CloseFile(Arquivo);
    end;

    // Adiciona os novos eventos do dia
    for i := 0 to MemoEventos.Lines.Count - 1 do
    begin
      if Trim(MemoEventos.Lines[i]) <> '' then
        WriteLn(TempFile, DataStr + ':' + Trim(MemoEventos.Lines[i]));
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao salvar eventos: ' + E.Message);
  end;
  CloseFile(TempFile);

  // Substitui o arquivo original pelo temporário
  try
    if FileExists(ARQUIVO_EVENTOS) then
      DeleteFile(ARQUIVO_EVENTOS);
    if not RenameFile(TempFileName, ARQUIVO_EVENTOS) then
      ShowMessage('Erro ao renomear o arquivo temporário.');
  except
    on E: Exception do
      ShowMessage('Erro ao substituir o arquivo: ' + E.Message);
  end;
end;

procedure TfAgenda.ExcluirEventosDoDia;
var
  Arquivo: TextFile;
  TempFile: TextFile;
  Linha, DataStr, TempFileName: string;
begin
  DataStr := FormatDateTime('dd/mm/yyyy', Calendar1.Date); // Formato dd/mm/aaaa
  TempFileName := 'temp_eventos.txt';

  // Cria um arquivo temporário
  AssignFile(TempFile, TempFileName);
  try
    Rewrite(TempFile);

    // Copia eventos existentes, exceto os da data atual
    if FileExists(ARQUIVO_EVENTOS) then
    begin
      AssignFile(Arquivo, ARQUIVO_EVENTOS);
      try
        Reset(Arquivo);
        while not EOF(Arquivo) do
        begin
          ReadLn(Arquivo, Linha);
          if (Trim(Linha) <> '') and (Pos(DataStr + ':', Linha) <> 1) then
            WriteLn(TempFile, Linha);
        end;
      except
        on E: Exception do
          ShowMessage('Erro ao ler eventos existentes: ' + E.Message);
      end;
      CloseFile(Arquivo);
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao excluir eventos: ' + E.Message);
  end;
  CloseFile(TempFile);

  // Substitui o arquivo original pelo temporário
  try
    if FileExists(ARQUIVO_EVENTOS) then
      DeleteFile(ARQUIVO_EVENTOS);
    if not RenameFile(TempFileName, ARQUIVO_EVENTOS) then
      ShowMessage('Erro ao renomear o arquivo temporário.');
  except
    on E: Exception do
      ShowMessage('Erro ao substituir o arquivo: ' + E.Message);
  end;
end;

procedure TfAgenda.VerificarEdicaoPendente;
begin
  if FEditando and (MemoEventos.Lines.Text <> '') then
  begin
    case MessageDlg('Deseja salvar as alterações antes de continuar?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        begin
          SalvarEventosDoDia;
          HabilitarEdicao(False);
          ShowMessage('Alterações salvas com sucesso!');
        end;
      mrNo:
        begin
          HabilitarEdicao(False);
          CarregarEventosDoDia; // Recarrega os eventos originais
        end;
      mrCancel:
        begin
          // Impede a mudança de data
          Calendar1.Date := Calendar1.Date;
          Exit;
        end;
    end;
  end;
end;

procedure TfAgenda.HabilitarEdicao(Habilitar: Boolean);
begin
  FEditando := Habilitar;
  MemoEventos.ReadOnly := not Habilitar;
  btnSalvar.Enabled := Habilitar;
  btnEditar.Enabled := not Habilitar;
  btnExcluir.Enabled := not Habilitar;
end;

{procedure TfAgenda.ExibirEventosDia;
var
  Mensagem: string;
begin
  if MemoEventos.Lines.Count > 0 then
  begin
    Mensagem := 'Eventos para ' + FormatDateTime('dd/mm/yyyy', Calendar1.Date) + ':' + sLineBreak +
                MemoEventos.Lines.Text;
    ShowMessage(Mensagem);
  end;
end; }

procedure TfAgenda.ExibirEventosDia;
begin
  if MemoEventos.Lines.Count > 0 then
  begin
    TrayIcon.BalloonTitle := 'Lembrete de Eventos';
    TrayIcon.BalloonHint := 'Eventos para ' + FormatDateTime('dd/mm/yyyy', Calendar1.Date) + ':' + sLineBreak +
                            MemoEventos.Lines.Text;
    TrayIcon.ShowBalloonHint;
  end;
end;

procedure TfAgenda.ConfigurarLembrete(IntervaloMinutos: Integer);
begin
  // Configura o intervalo do timer de lembrete em milissegundos
  TimerLembrete.Interval := IntervaloMinutos * 60000;
  TimerLembrete.Enabled := True;
end;

procedure TfAgenda.AtualizarIndicadorLembrete;
begin
  if FLembreteAtivo then
  begin
    shpIndicadorLembrete.Brush.Color := clLime; // Verde para ativo
    lblStatusLembrete.Caption := 'Ativo';
  end
  else
  begin
    shpIndicadorLembrete.Brush.Color := clSilver; // Cinza para desativado
    lblStatusLembrete.Caption := 'Desativado';
  end;
end;

end.

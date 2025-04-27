unit chamados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus,
  Vcl.Grids, Vcl.DBGrids, RzDbGrid, RzMetaData, RzDir, RzPathManager,
  RzDataCenter, ZAbstractConnection, ZConnection, RzConnection, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, RzQuery, RzEdit;

type
  TAtendimentos = class(TForm)
    TrayIcon: TTrayIcon;
    pmTrayMenu: TPopupMenu;
    mniRestaurar: TMenuItem;
    miSair: TMenuItem;
    btnMinimizar: TButton;
    btnVoltar: TButton;
    btnSair: TButton;
    RzDBGrid1: TRzDBGrid;
    TimerNovosChamados: TTimer;
    eCliente: TRzEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnVoltarClick(Sender: TObject);
    procedure miRestaurarClick(Sender: TObject);
    procedure miSairClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure btnMinimizarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure TimerNovosChamadosTimer(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Atendimentos: TAtendimentos;

implementation

uses
  entradaU, ConB;

{$R *.dfm}

procedure TAtendimentos.TimerNovosChamadosTimer(Sender: TObject);
var
  Mensagem: string;
  TemNovos: Boolean;
begin
  ConB.Conx.qConsulta.Refresh; // Atualiza a consulta
  // Reexecuta a lógica de mensagem
  Mensagem := '';
  TemNovos := False;
  ConB.Conx.qConsulta.First;
  while not ConB.Conx.qConsulta.Eof do
  begin
    if not ConB.Conx.qConsulta.FieldByName('Atendido').AsBoolean then
    begin
      TemNovos := True;
      Mensagem := Mensagem + 'Você possui um novo chamado Número ' +
                  ConB.Conx.qConsulta.FieldByName('Sequencia').AsString + ' (' +
                  ConB.Conx.qConsulta.FieldByName('NomeCliente').AsString + ')' + #13#10;
    end;
    ConB.Conx.qConsulta.Next;
  end;
  if TemNovos then
  begin
    TrayIcon.BalloonTitle := 'Novos Chamados';
    TrayIcon.BalloonHint := Mensagem;
    TrayIcon.ShowBalloonHint;
  end;
end;

procedure TAtendimentos.btnMinimizarClick(Sender: TObject);
begin
  Hide;
  TrayIcon.Visible := True;
end;

procedure TAtendimentos.btnSairClick(Sender: TObject);
begin
  Close;
  Entrada.Close;
end;

procedure TAtendimentos.btnVoltarClick(Sender: TObject);
begin
  TrayIcon.Visible := False; // Desativa o ícone ao voltar
  Entrada.Show;
  Atendimentos.Hide;
end;

procedure TAtendimentos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
  Hide;
  TrayIcon.Visible := True;
end;

procedure TAtendimentos.FormCreate(Sender: TObject);
var
  Mensagem: string;
  TemNovos: Boolean;
begin
  TrayIcon.Hint := 'Atendimentos';
  try
    // Garante que a conexão está ativa
    if not ConB.Conx.cBanco.Connected then
      ConB.Conx.cBanco.Connected := True;

    // Configura a consulta com JOIN para o nome do cliente
    ConB.Conx.qConsulta.Close;
    ConB.Conx.qConsulta.SQL.Text := 'SELECT ListaAtendimento.Sequencia, ListaAtendimento.CodCli, Clientes.Cliente, ListaAtendimento.Contato, ' +
                      'ListaAtendimento.DataHoraEdit, ListaAtendimento.Atendido ' +
                      'FROM ListaAtendimento ' +
                      'LEFT JOIN Clientes ON Clientes.CodCli = Clientes.CodCli ' +
                      'WHERE ListaAtendimento.Atendido = 0';
    if Trim(eCliente.Text) <> '' then
    begin
      ConB.Conx.qConsulta.SQL.Add(' AND Clientes.Cliente LIKE :Cliente');
      ConB.Conx.qConsulta.ParamByName('Cliente').AsString := '%' + Trim(eCliente.Text) + '%';
    end;
    ConB.Conx.qConsulta.SQL.Add(' ORDER BY c.DataHoraInsert DESC');
        ConB.Conx.qConsulta.Open;

    // Torna o grid somente leitura e configura colunas
    RzDBGrid1.ReadOnly := True;
    RzDBGrid1.Columns.Clear;
    with RzDBGrid1.Columns.Add do
    begin
      FieldName := 'Sequencia';
      Title.Caption := 'Número do Chamado';
      Width := 100;
    end;
    with RzDBGrid1.Columns.Add do
    begin
      FieldName := 'CodCli';
      Title.Caption := 'Código do Cliente';
      Width := 80;
    end;
    with RzDBGrid1.Columns.Add do
    begin
      FieldName := 'NomeCliente';
      Title.Caption := 'Nome do Cliente';
      Width := 200;
    end;
    with RzDBGrid1.Columns.Add do
    begin
      FieldName := 'Contato';
      Title.Caption := 'Contato';
      Width := 150;
    end;
    with RzDBGrid1.Columns.Add do
    begin
      FieldName := 'DataHoraEdit';
      Title.Caption := 'Data de Edição';
      Width := 120;
    end;
    with RzDBGrid1.Columns.Add do
    begin
      FieldName := 'Atendido';
      Title.Caption := 'Atendido';
      Width := 60;
    end;

    // Verifica chamados novos (não atendidos)
    Mensagem := '';
    TemNovos := False;
    ConB.Conx.qConsulta.First;
    while not ConB.Conx.qConsulta.Eof do
    begin
      if not ConB.Conx.qConsulta.FieldByName('Atendido').AsBoolean then
      begin
        TemNovos := True;
        Mensagem := Mensagem + 'Você possui um novo chamado Número ' +
                    ConB.Conx.qConsulta.FieldByName('Sequencia').AsString + ' (' +
                    ConB.Conx.qConsulta.FieldByName('NomeCliente').AsString + ')' + #13#10;
      end;
      ConB.Conx.qConsulta.Next;
    end;

    if TemNovos then
      ShowMessage(Mensagem)
    else
      ShowMessage('Nenhum chamado novo encontrado.');
  except
    on E: Exception do
      ShowMessage('Erro ao carregar chamados: ' + E.Message);
  end;
end;

procedure TAtendimentos.FormDestroy(Sender: TObject);
begin
  TrayIcon.Visible := False;
end;

procedure TAtendimentos.miRestaurarClick(Sender: TObject);
begin
  if not Visible then
  begin
    Show;
    WindowState := wsNormal;
    TrayIcon.Visible := False;
  end;
end;

procedure TAtendimentos.miSairClick(Sender: TObject);
begin
  // Fecha a aplicação completamente
  TrayIcon.Visible := False;
  Application.Terminate;
end;

procedure TAtendimentos.TrayIconDblClick(Sender: TObject);
begin
  // Restaura o formulário ao clicar duas vezes no ícone
  miRestaurarClick(Sender);
end;

end.

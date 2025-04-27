unit chamados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus;

type
  TAtendimentos = class(TForm)
    TrayIcon: TTrayIcon;
    btnMinimizar: TButton;
    btnVoltar: TButton;
    pmTrayMenu: TPopupMenu;
    mniRestaurar: TMenuItem;
    miSair: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnVoltarClick(Sender: TObject);
    procedure miRestaurarClick(Sender: TObject);
    procedure miSairClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure btnMinimizarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Atendimentos: TAtendimentos;

implementation

uses
  entradaU;

{$R *.dfm}

procedure TAtendimentos.btnMinimizarClick(Sender: TObject);
begin
  Hide;
  TrayIcon.Visible := True;
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
begin
  TrayIcon.Hint := 'Atendimentos';
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

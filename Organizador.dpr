program Organizador;

uses
  Vcl.Forms,
  entradaU in 'entradaU.pas' {Entrada},
  agenda in 'agenda.pas' {fAgenda},
  chamados in 'chamados.pas' {Atendimentos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TEntrada, Entrada);
  Application.Run;
end.

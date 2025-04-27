program Organizador;

uses
  Vcl.Forms,
  entradaU in 'entradaU.pas' {Entrada},
  agenda in 'agenda.pas' {fAgenda},
  chamados in 'chamados.pas' {Atendimentos},
  ConB in 'ConB.pas' {Conx};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TEntrada, Entrada);
  Application.CreateForm(TConx, Conx);
  Application.Run;
end.

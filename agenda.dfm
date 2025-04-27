object fAgenda: TfAgenda
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Agenda'
  ClientHeight = 266
  ClientWidth = 994
  Color = clSkyBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    994
    266)
  PixelsPerInch = 96
  TextHeight = 13
  object shpIndicadorLembrete: TShape
    Left = 147
    Top = 198
    Width = 19
    Height = 17
    Shape = stCircle
  end
  object lblStatusLembrete: TLabel
    Left = 171
    Top = 200
    Width = 31
    Height = 13
    Caption = 'Status'
  end
  object Calendar1: TMonthCalendar
    Left = 2
    Top = 3
    Width = 225
    Height = 160
    Cursor = crHandPoint
    BiDiMode = bdLeftToRight
    Date = 45536.586491574070000000
    DoubleBuffered = False
    DragCursor = crHandPoint
    ParentBiDiMode = False
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = Calendar1Click
  end
  object MemoEventos: TMemo
    Left = 317
    Top = 4
    Width = 674
    Height = 232
    Anchors = [akTop, akRight]
    Lines.Strings = (
      '')
    TabOrder = 1
    OnExit = MemoEventosExit
  end
  object btnSalvar: TButton
    Left = 234
    Top = 9
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 2
    OnClick = btnSalvarClick
  end
  object btnEditar: TButton
    Left = 234
    Top = 38
    Width = 75
    Height = 25
    Caption = 'Editar'
    TabOrder = 3
    OnClick = btnEditarClick
  end
  object btnExcluir: TButton
    Left = 234
    Top = 67
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 4
    OnClick = btnExcluirClick
  end
  object cbIntervaloLembrete: TComboBox
    Left = 3
    Top = 170
    Width = 145
    Height = 21
    TabOrder = 5
  end
  object btnAtivarLembrete: TButton
    Left = 149
    Top = 169
    Width = 106
    Height = 25
    Caption = 'Ativar Lembrete'
    TabOrder = 6
    OnClick = btnAtivarLembreteClick
  end
  object btnVoltar: TButton
    Left = 919
    Top = 239
    Width = 72
    Height = 25
    Caption = 'Inicio'
    TabOrder = 7
    OnClick = btnVoltarClick
  end
  object btnMinimizar: TButton
    Left = 807
    Top = 239
    Width = 110
    Height = 25
    Hint = 
      'Ao clicar neste Bot'#227'o, o App fica Minimizado junto Calend'#225'rio/Re' +
      'l'#243'gio do Windows'
    Caption = 'Minimizar IconTray'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = btnMinimizarClick
  end
  object TimerVerificaDia: TTimer
    OnTimer = TimerVerificaDiaTimer
    Left = 6
    Top = 196
  end
  object TimerLembrete: TTimer
    OnTimer = TimerLembreteTimer
    Left = 41
    Top = 196
  end
  object pmTrayMenu: TPopupMenu
    Left = 109
    Top = 197
    object miRestaurar: TMenuItem
      Caption = 'Restaurar'
      OnClick = miRestaurarClick
    end
    object miSair: TMenuItem
      Caption = 'Sair'
      OnClick = miSairClick
    end
  end
  object TrayIcon: TTrayIcon
    Hint = 'Agenda - Lembretes'
    PopupMenu = pmTrayMenu
    OnDblClick = TrayIconDblClick
    Left = 75
    Top = 197
  end
end

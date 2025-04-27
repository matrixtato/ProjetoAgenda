object Atendimentos: TAtendimentos
  Left = 0
  Top = 0
  Caption = 'Atendimentos'
  ClientHeight = 728
  ClientWidth = 1188
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnMinimizar: TButton
    Left = 1069
    Top = 1
    Width = 110
    Height = 25
    Hint = 
      'Ao clicar neste Bot'#227'o, o App fica Minimizado junto Calend'#225'rio/Re' +
      'l'#243'gio do Windows'
    Caption = 'Minimizar IconTray'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = btnMinimizarClick
  end
  object btnVoltar: TButton
    Left = 1107
    Top = 27
    Width = 72
    Height = 25
    Caption = 'Inicio'
    TabOrder = 1
    OnClick = btnVoltarClick
  end
  object btnSair: TButton
    Left = 1107
    Top = 53
    Width = 72
    Height = 25
    Caption = 'Fechar APP'
    TabOrder = 2
    OnClick = btnSairClick
  end
  object RzDBGrid1: TRzDBGrid
    Left = 4
    Top = 5
    Width = 991
    Height = 671
    AutoPosGrade = False
    MultiColorFont.Charset = DEFAULT_CHARSET
    MultiColorFont.Color = clWhite
    MultiColorFont.Height = -11
    MultiColorFont.Name = 'MS Sans Serif'
    MultiColorFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Sequencia'
        Title.Caption = 'Chamado'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CodCli'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Cliente'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Contato'
        Visible = True
      end>
    Color = clWindow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    Columns = <
      item
        Expanded = False
        FieldName = 'Sequencia'
        Title.Caption = 'Chamado'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CodCli'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Cliente'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Contato'
        Visible = True
      end>
  end
  object eCliente: TRzEdit
    Left = 1003
    Top = 102
    Width = 177
    Height = 21
    TabOrder = 4
    AsInteger = 0
    Value = ''
  end
  object TrayIcon: TTrayIcon
    Hint = 'Agenda - Lembretes'
    PopupMenu = pmTrayMenu
    OnDblClick = TrayIconDblClick
    Left = 1115
    Top = 592
  end
  object pmTrayMenu: TPopupMenu
    Left = 1148
    Top = 592
    object mniRestaurar: TMenuItem
      Caption = 'Restaurar'
      OnClick = miRestaurarClick
    end
    object miSair: TMenuItem
      Caption = 'Sair'
      OnClick = miSairClick
    end
  end
  object TimerNovosChamados: TTimer
    OnTimer = TimerNovosChamadosTimer
    Left = 1066
    Top = 592
  end
end

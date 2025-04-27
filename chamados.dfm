object Atendimentos: TAtendimentos
  Left = 0
  Top = 0
  Caption = 'Atendimentos'
  ClientHeight = 268
  ClientWidth = 1078
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
    Left = 891
    Top = 242
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
    Left = 1003
    Top = 241
    Width = 72
    Height = 25
    Caption = 'Inicio'
    TabOrder = 1
    OnClick = btnVoltarClick
  end
  object TrayIcon: TTrayIcon
    Hint = 'Agenda - Lembretes'
    PopupMenu = pmTrayMenu
    OnDblClick = TrayIconDblClick
    Left = 4
    Top = 223
  end
  object pmTrayMenu: TPopupMenu
    Left = 56
    Top = 224
    object mniRestaurar: TMenuItem
      Caption = 'Restaurar'
      OnClick = miRestaurarClick
    end
    object miSair: TMenuItem
      Caption = 'Sair'
      OnClick = miSairClick
    end
  end
end

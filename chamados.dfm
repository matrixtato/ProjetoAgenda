object Atendimentos: TAtendimentos
  Left = 0
  Top = 0
  Caption = 'Atendimentos'
  ClientHeight = 687
  ClientWidth = 1184
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
    RzDataCenter = dcConsulta
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
    DataSource = dsConsulta
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
  object qConsulta: TRzQuery
    Connection = cBanco
    SQL.Strings = (
      
        'SELECT ListaAtendimento.Sequencia, ListaAtendimento.CodCli, Clie' +
        'ntes.Cliente, ListaAtendimento.Contato,'
      'ListaAtendimento.DataHoraEdit, ListaAtendimento.Atendido'
      'FROM ListaAtendimento'
      'LEFT JOIN Clientes ON Clientes.CodCli = ListaAtendimento.CodCli'
      'WHERE ListaAtendimento.Atendido = 0'
      'ORDER BY ListaAtendimento.DataHoraInsert DESC')
    Params = <>
    AutoCreateFields = False
    RzDataCenter = dcConsulta
    Left = 1078
    Top = 593
    object qConsultaSequencia: TIntegerField
      FieldName = 'Sequencia'
      Required = True
    end
    object qConsultaCodCli: TIntegerField
      FieldName = 'CodCli'
    end
    object qConsultaCliente: TStringField
      FieldName = 'Cliente'
      Required = True
      Size = 60
    end
    object qConsultaContato: TStringField
      FieldName = 'Contato'
      Size = 50
    end
    object qConsultaDataHoraEdit: TDateTimeField
      FieldName = 'DataHoraEdit'
    end
    object qConsultaAtendido: TBooleanField
      FieldName = 'Atendido'
    end
  end
  object dsConsulta: TDataSource
    DataSet = qConsulta
    Left = 1047
    Top = 592
  end
  object cBanco: TRzConnection
    ControlsCodePage = cGET_ACP
    UTF8StringsAsWideField = True
    Properties.Strings = (
      'controls_cp=GET_ACP')
    HostName = 'DBSERVER2.RZSISTEMAS.COM.BR'
    Port = 6065
    Database = '146-Rz_Erp_RzSistemas'
    User = '146-rz'
    Password = 'bnu@2020'
    Protocol = 'FreeTDS_MsSQL>=2005'
    LibraryLocation = 'C:\Vis'#227'o_Futura\Agenda_Eventos\MsSql.dll'
    LogSqlEnabled = False
    LogRzMsSql = False
    Left = 1044
    Top = 647
  end
  object dcConsulta: TRzDataCenter
    Connection = cBanco
    DataBaseProtocol = DbpSQLServer
    UserTable = dsConsulta
    UserModulos = dsConsulta
    Modulos = dsConsulta
    PathManager = pmConsulta
    RzMetaData = RzMetadata1
    Left = 1084
    Top = 647
  end
  object pmConsulta: TRzPathManager
    ApGroup = TRzErp
    AutoInstallDAO = False
    InstallDirNivel = 1
    ServerPort = 0
    Customizacao = False
    Left = 1116
    Top = 646
  end
  object RzMetadata1: TRzMetadata
    Connection = cBanco
    Params = <>
    Left = 1148
    Top = 647
  end
  object TimerNovosChamados: TTimer
    OnTimer = TimerNovosChamadosTimer
    Left = 1014
    Top = 593
  end
end

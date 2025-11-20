inherited BackendDelphiCadastro: TBackendDelphiCadastro
  Width = 300
  object QryPesquisa: TFDQuery
    Connection = Connection
    Left = 200
    Top = 32
  end
  object QryCadastro: TFDQuery
    Connection = Connection
    Left = 200
    Top = 100
  end
  object QryRecordCount: TFDQuery
    Connection = Connection
    Left = 200
    Top = 168
    object QryRecordCountCOUNT: TLargeintField
      FieldName = 'COUNT'
    end
  end
end

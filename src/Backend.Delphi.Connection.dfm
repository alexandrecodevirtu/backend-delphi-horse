object BackendDelphiConnection: TBackendDelphiConnection
  Height = 255
  Width = 178
  object Connection: TFDConnection
    Params.Strings = (
      'ConnectionDef=Elovia_Pooled')
    ConnectedStoredUsage = []
    LoginPrompt = False
    Left = 74
    Top = 24
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorLib = 
      'E:\EstudoDelphi\MicroService\backEnd\product-api\Win32\Debug\lib' +
      'pq.dll'
    Left = 74
    Top = 92
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 74
    Top = 160
  end
end

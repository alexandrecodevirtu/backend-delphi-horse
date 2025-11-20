unit Backend.Delphi.Generics.Controller;

interface

Uses
  Horse;

type
  IGenericController<T: class, constructor> = interface
    ['{AA9BC81F-210F-4AC7-BBA9-1AEF087E4D6A}']
    procedure Registry(const AResource: string);
  end;

  TGenericController<T: class, constructor> = class(TInterfacedObject, IGenericController<T>)
  private
    Const
      NOT_FOUND = 'O registro não existe no sistema!';
  private
    procedure DoListAll(Req: THorseRequest; Res: THorseResponse);
    procedure DoGetById(Req: THorseRequest; Res: THorseResponse);
    procedure DoAppend(Req: THorseRequest; Res: THorseResponse);
    procedure DoUpdate(Req: THorseRequest; Res: THorseResponse);
    procedure DoDelete(Req: THorseRequest; Res: THorseResponse);
    procedure Registry(const AResource: string);
  public
    class function New: IGenericController<T>;
  end;

implementation

Uses
  Backend.Delphi.Cadastro, System.JSON, DataSet.Serialize, System.SysUtils, Data.DB;

procedure TGenericController<T>.DoAppend(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    if LService.Append(Req.Body<TJSONObject>) then
    begin
      Res.Status(THTTPStatus.Created);
//      Res.AddHeader('X-Teste', 'Teste 1121232');
      Res.Send<TJSONObject>(LService.QryCadastro.ToJSONObject());
    end;
  finally
    LService.Free;
  end;
end;

procedure TGenericController<T>.DoDelete(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    if LService.GetById(Req.Params['id'].ToInt64).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error(NOT_FOUND);
    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure TGenericController<T>.DoGetById(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    if LService.GetById(Req.Params['id'].ToInt64).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error(NOT_FOUND);
    Res.Send<TJSONObject>(LService.QryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure TGenericController<T>.DoListAll(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    var LJSONObject := TJSONObject.Create;
    LJSONObject.AddPair('data', LService.ListAll(Req.Query.Dictionary).ToJSONArray());
    LJSONObject.AddPair('records', LService.GetRecordCount);
    Res.Send<TJSONObject>(LJSONObject);
  finally
    LService.Free;
  end;
end;

procedure TGenericController<T>.DoUpdate(Req: THorseRequest; Res: THorseResponse);
begin
  var LService := TBackendDelphiCadastro(T.Create);
  try
    if LService.GetById(Req.Params['id'].ToInt64).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error(NOT_FOUND);
    if LService.Update(Req.Body<TJSONObject>) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

class function TGenericController<T>.New: IGenericController<T>;
begin
  Result := TGenericController<T>.Create;
end;

procedure TGenericController<T>.Registry(const AResource: string);
begin
  var LResourceId := AResource + '/:id';

  THorse.Get(AResource, DoListAll);
  THorse.Get(LResourceId, DoGetById);
  THorse.Post(AResource, DoAppend);
  THorse.Put(LResourceId, DoUpdate);
  THorse.Delete(LResourceId, DoDelete);
end;

end.

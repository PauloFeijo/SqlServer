create or alter PROCEDURE dbo.ConsultarDadosCEP(@cep char(8)) 
AS   
begin 
   declare @obj int;
   declare @url varchar(255);
   declare @resposta VARCHAR(8000);
   
   execute sp_configure 'show advanced options', 1;
   reconfigure with override;
   exec sp_configure 'Ole Automation Procedures', 1;
   reconfigure with override;
   
   set @url = 'http://viacep.com.br/ws/'+@cep+'/json';
   
   exec sys.sp_OACreate 'MSXML2.ServerXMLHTTP', @obj OUT
   exec sys.sp_OAMethod @obj, 'open', NULL, 'GET', @Url, FALSE
   exec sys.sp_OAMethod @obj, 'send'
   exec sys.sp_OAGetProperty @obj, 'responseText', @resposta OUT   
   
   select 
   	JSON_VALUE(@resposta, '$.localidade') as cidade,
   	JSON_VALUE(@resposta, '$.uf') as estado,
   	JSON_VALUE(@resposta, '$.ibge') as cod_ibge,
   	JSON_VALUE(@resposta, '$.ddd') as ddd;
   
   exec sys.sp_OADestroy @obj
end;

exec ConsultarDadosCEP '86975000'
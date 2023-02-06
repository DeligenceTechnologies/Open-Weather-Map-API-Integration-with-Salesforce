public class openWeatherWebserviceController {
    @auraEnabled
    public decimal temperature{get;set;}
    @auraEnabled
    public decimal feelsLike{get;set;}
    @auraEnabled
    public decimal minTemp{get;set;}
    @auraEnabled
    public decimal maxTemp{get;set;}
    @auraEnabled
    public integer pressure{get;set;}
    @auraEnabled
    public integer humidity{get;set;}
    @auraEnabled
    public string city{get;set;}
    @AuraEnabled
    public boolean hasCity{get;Set;}
    
    @auraEnabled
    public static openWeatherWebserviceController getCity(Id LeadId){
        Lead objLead = [select City from Lead where Id=:leadId];
        openWeatherWebserviceController data = new openWeatherWebserviceController();
        if(string.isBlank(objLead.City)){
            data.hasCity=true;
        }
        else{
            data.city=objLead.City;
            data.hasCity=false;
        }
        
        return data;
    }
    
    @auraEnabled
    public static openWeatherWebserviceController searchWeather(string CityName){
        
        string endPointUrRl=system.label.WeatherMapEndpointURL+CityName+'&appid='+system.label.WeatherMapApiKey;
        
        http httpObj = new http();
        
        httpRequest request = new httpRequest();
        request.setEndpoint(endPointUrRl);
        request.setMethod('GET');
        
        httpResponse  response = httpObj.send(request);
        
        system.JSONParser wParser = system.JSON.createParser(response.getBody());
        system.debug('###########'+response.getbody());
        openWeatherWebserviceController pg = new openWeatherWebserviceController();
        
        while(wParser.nextToken() != null){
            if(wParser.getCurrentToken()==system.JSONToken.FIELD_NAME && wParser.getText()=='main'){
                wParser.nextToken();
            }
            if(wParser.getCurrentToken()==JSONToken.START_OBJECT){
                wParser.nextToken();
                if(wParser.getCurrentToken()==system.JSONToken.FIELD_NAME && wParser.getText()=='temp'){
                    wParser.nextToken();
                    pg.temperature= (wParser.getDecimalValue()-273.15);
                }
                wParser.nextToken();
                if(wParser.getCurrentToken()==system.JSONToken.FIELD_NAME && wParser.getText()=='feels_like'){
                    wParser.nextToken();
                    pg.feelsLike= (wParser.getDecimalValue()-273.15);
                }
                wParser.nextToken();
                if(wParser.getCurrentToken()==system.JSONToken.FIELD_NAME && wParser.getText()=='temp_min'){
                    wParser.nextToken();
                    pg.minTemp= (wParser.getDecimalValue()-273.15);
                }
                wParser.nextToken();
                if(wParser.getCurrentToken()==system.JSONToken.FIELD_NAME && wParser.getText()=='temp_max'){
                    wParser.nextToken();
                    pg.maxTemp=(wParser.getDecimalValue()-273.15);
                }
                wParser.nextToken();
                if(wParser.getCurrentToken()==system.JSONToken.FIELD_NAME && wParser.getText()=='pressure'){
                    wParser.nextToken();
                    pg.pressure= wParser.getIntegerValue();
                }
                wParser.nextToken();
                if(wParser.getCurrentToken()==system.JSONToken.FIELD_NAME && wParser.getText()=='humidity'){
                    wParser.nextToken();
                    pg.humidity= wParser.getIntegerValue();
                }
            }
        }
        system.debug(pg);
        system.debug('@@@@@@'+response.getStatusCode());
        return pg; 
    }
}
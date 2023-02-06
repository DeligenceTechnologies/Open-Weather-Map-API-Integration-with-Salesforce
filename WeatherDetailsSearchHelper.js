({
    getDataHelper : function(component,event,helper){
        console.log('getCity');
        var action = component.get("c.getCity");
        action.setParams({"LeadId":component.get('v.recordId')});
        action.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){
                console.log(response.getReturnValue());
                var result= response.getReturnValue();
                component.set('v.CityName',result.city);
                component.set('v.hasCity',result.hasCity);
                if(component.get('v.hasCity')== false){
                    this.searchHelper(component,event,helper);
                }
            }
            else{
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    searchHelper : function(component,event,helper) {
        console.log('SearchHelper');
        var action = component.get("c.searchWeather");
        action.setParams({"CityName":component.get('v.CityName')});
        action.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){
                console.log(response.getReturnValue());
                component.set('v.weatherData',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})
({
    doInit : function(component, event, helper){
        console.log('init Controller');
        helper.getDataHelper(component, event, helper);
    },
    
    searchController : function(component, event, helper) {
		console.log('Search Controller');
        helper.searchHelper(component,event,helper);
	}
})
({
    performSearch : function(originalArray, searchTerm, startDate, endDate){
        // Let's Try searching with Javascript instead

        // Search Records by Keyword
        let searchTermRecords = [];
        if(searchTerm){
            searchTermRecords = originalArray.filter(o => {   
                return Object.keys(o).some(k => {       	
                    if(typeof o[k] === 'string') 
                        return o[k].toLowerCase().includes(searchTerm.toLowerCase());
                    });
            });
        }

        // Search Records by Date Range

        // We can search on null start date
        let start = new Date(startDate);
        var UTCStart = new Date(start.getUTCFullYear(), start.getUTCMonth(), start.getUTCDate());
    

        // We cannot search on null end date.  If null, default to today
        let end = new Date();
        if(endDate){
            end = new Date(endDate);
        } 

        var UTCEnd = new Date(end.getUTCFullYear(), end.getUTCMonth(), end.getUTCDate(), 23, 59, 59, 999);
        
        let dateRangeRecords = [];
        dateRangeRecords = originalArray.filter(o => {   
            return Object.keys(o).some(k => {
                debugger;	
                if(Date.parse(o[k]) && typeof o[k] === 'string') {
                    debugger;
                    let testDate = new Date(o[k]);
                    return testDate >= UTCStart && testDate <= UTCEnd;
                }
            });
        });
        
        // Let's figure out which results to show
        if(searchTerm && (startDate || endDate)){
            // Find common items between each searched arrays
            let finalResults = searchTermRecords.filter(element => dateRangeRecords.includes(element));

            // This method will combine the individual results to one list
            // concat results from both searches
            //finalResults = this.arrayUnique(searchTermRecords.concat(dateRangeRecords));

            return finalResults;
        } 
        
        if(searchTerm){
            // only search term was used
            return  searchTermRecords;
        }

        // Only Date Range was used
        // which supports null values to essentially reset the search results
        return dateRangeRecords;
    },
})
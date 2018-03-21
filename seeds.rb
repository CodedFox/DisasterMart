require 'csv'
require 'rails'
require 'active_record'
require 'activerecord-import'

def parse_data
    # initiate variables
    disasters = {}
    locations = {}
    startDates = {}
    summaries = {}
    costs = {}
    endDates = {}
    facts = []

    # initiate nil costs entry
    costs[{estTotal:nil, normTotal:nil, federal:nil, provDFAA:nil, provDep:nil, municipal:nil, OGD:nil, insurance:nil, NGO:nil}] = 1

    # read csv
    csv = CSV.foreach('/Users/jonathangratton/OneDrive/University of Ottawa/Winter 2018/CSI 4142 - Introduction to Data Science/DisasterMart/CanadianDisasterDatabase.csv',:headers => true , :encoding => 'ISO-8859-1') do |row|
        
        # create disaster object
        if row[21].nil? or row[21].empty?
            magnitude = 0
        else 
            magnitude = row[21]
        end

        if row[20].nil? or row[20].empty?
            utility = 0
        else 
            utility = row[20]
        end

        disasterKey = disasters[{category:row[0], group:row[1], subgroup:row[2], type:row[3], magnitude:magnitude, utility:utility}]
        if disasterKey.nil?
            disasterKey = disasters.size + 1
            disasters[{category:row[0], group:row[1], subgroup:row[2], type:row[3], magnitude:magnitude, utility:utility}] = disasterKey
        end

        # create location object
        locationKey = locations[row[6]]
        if locationKey.nil?
            locationKey = locations.size + 1
            locations[row[6]] = locationKey
        end

        # create start date object
        startDateTime = DateTime.parse(row[5])
        startDate = startDateTime.to_date

        startDateKey = startDates[startDate]
        if startDateKey.nil?
            startDateKey = startDates.size + 1
            startDates[startDate] = startDateKey
        end

        # create summary
        descriptionKey = summaries[row[6]]
        if descriptionKey.nil?
            descriptionKey = summaries.size + 1
            summaries[row[6]] = descriptionKey
        end

        # create cost object
        costKey = costs[{estTotal:row[10], normTotal:row[11], federal:row[13], provDFAA:row[14], provDep:row[15], municipal:row[16], OGD:row[17], insurance:row[18], NGO:row[19]}]
        if costKey.nil?
            costKey = costs.size + 1
            costs[{estTotal:row[10], normTotal:row[11], federal:row[13], provDFAA:row[14], provDep:row[15], municipal:row[16], OGD:row[17], insurance:row[18], NGO:row[19]}] = costKey
        end

        # create end date object
        endDateTime = DateTime.parse(row[12])
        endDate = endDateTime.to_date

        endDateKey = endDates[endDate]
        if endDateKey.nil?
            endDateKey = endDates.size + 1
            endDates[endDate] = endDateKey
        end

        # extract measures
        fatalities = row[7]
        injured = row[8]
        evacuated = row[9]

        # merge all items into fact table
        facts << {startDateKey: startDateKey, endDateKey: endDateKey, locationKey: locationKey, disasterKey: disasterKey, descriptionKey: descriptionKey, costKey: costKey, fatalities: fatalities, injured: injured, evacuated: evacuated}

    # end loop
    end

    return {disasters: disasters, locations: locations, startDates: startDates, summaries: summaries, costs: costs, endDates: endDates, facts: facts}
    return costs
end

# enter all data into database

data = parse_data

# print data[:facts][0][:evacuated].to_s+ "\n"
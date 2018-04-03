require 'csv'
require 'rails'
require 'active_record'
require 'activerecord-import'
require 'i18n'

def parse_data
    # initiate variables
    disasters = {}
    locations = {}
    dates = {}
    summaries = {}
    costs = {}
    facts = []
    keywords = ['hurricane', 'drought', 'flood', 'fire', 'snow', 'explosion', 'avalanche', 'storm', 'derail', 'pollution', 
                'spill', 'ice', 'water', 'wind', 'tornado', 'earthquake', 'virus', 'crash', 'temperature', 'lightning']

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
        city = "unknown"
        province = "unknown"
        region = "unknown"
        country = "Canada"
        canada = true

        s = I18n.transliterate(row[4])

        # search for Province only
        if (s == "Ontario" || s == "Quebec" || s == "British Columbia" || s == "Alberta" || s == "Manitoba" || s == "Saskatchewan" || 
        s == "Nova Scotia" || s == "New Brunswick" || s == "Newfoundland and Labrador" || s == "Newfoundland" || s == "Labrador" || 
        s == "Prince Edward Island" || s == "Northwest Territories" || s == "Nunavut" || s == "Yukon")
            
            case s
                when "Ontario"
                    province = s
                    region = "Central Canada"
                when "Quebec"
                    province = s
                    region = "Central Canada"
                when "British Columbia"
                    province = s
                    region = "West Coast"
                when "Alberta"
                    province = s
                    region = "Prairie Provinces"
                when "Manitoba"
                    province = s
                    region = "Prairie Provinces"
                when "Saskatchewan"
                    province = s
                    region = "Prairie Provinces"
                when "Nova Scotia"
                    province = s
                    region = "Atlantic Canada"
                when "New Brunswick"
                    province = s
                    region = "Atlantic Canada"
                when "Newfoundland and Labrador"
                    province = s
                    region = "Atlantic Canada"
                when "Newfoundland"
                    province = "Newfoundland and Labrador"
                    region = "Atlantic Canada"
                when "Labrador"
                    province = "Newfoundland and Labrador"
                    region = "Atlantic Canada"
                when "Prince Edward Island"
                    province = s
                    region = "Atlantic Canada"
                when "Northwest Territories"
                    province = s
                    region = "Northern Canada"
                when "Nunavut"
                    province = s
                    region = "Northern Canada"
                when "Yukon"
                    province = s
                    region = "Northern Canada"
            end

        # search for city and provinces
        elsif s[/[A-Z][A-Z]/]
            a = s.gsub(/[()]/, "").split(/\s*,\s*|\s+and\s+/)

            a.each do |item|
                if item[/[A-Z][A-Z]/] && city == "unknown" && province == "unknown"
                    p = item.split(//).last(2).join
                    case p
                        when "ON"
                            province = "Ontario"
                            region = "Central Canada"
                        when "QC"
                            province = "Quebec"
                            region = "Central Canada"
                        when "BC"
                            province = "British Columbia"
                            region = "West Coast"
                        when "AB"
                            province = "Alberta"
                            region = "Prairie Provinces"
                        when "MB"
                            province = "Manitoba"
                            region = "Prairie Provinces"
                        when "SK"
                            province = "Saskatchewan"
                            region = "Prairie Provinces"
                        when "NS"
                            province = "Nova Scotia"
                            region = "Atlantic Canada"
                        when "NB"
                            province = "New Brunswick"
                            region = "Atlantic Canada"
                        when "NL"
                            province = "Newfoundland and Labrador"
                            region = "Atlantic Canada"
                        when "PE"
                            province = "Prince Edward Island"
                            region = "Atlantic Canada"
                        when "NT"
                            province = "Northwest Territories"
                            region = "Northern Canada"
                        when "NU"
                            province = "Nunavut"
                            region = "Northern Canada"
                        when "YT"
                            province = "Yukon"
                            region = "Northern Canada"
                    end

                    item.slice! " "+p
                    city = item

                elsif !item[/[A-Z][A-Z]/] && city == "unknown"
                    city = item

                elsif item[/[A-Z][A-Z]/] && province == "unknown"
                    p = item.split(//).last(2).join
                    case p
                        when "ON"
                            province = "Ontario"
                            region = "Central Canada"
                        when "QC"
                            province = "Quebec"
                            region = "Central Canada"
                        when "BC"
                            province = "British Columbia"
                            region = "West Coast"
                        when "AB"
                            province = "Alberta"
                            region = "Prairie Provinces"
                        when "MB"
                            province = "Manitoba"
                            region = "Prairie Provinces"
                        when "SK"
                            province = "Saskatchewan"
                            region = "Prairie Provinces"
                        when "NS"
                            province = "Nova Scotia"
                            region = "Atlantic Canada"
                        when "NB"
                            province = "New Brunswick"
                            region = "Atlantic Canada"
                        when "NL"
                            province = "Newfoundland and Labrador"
                            region = "Atlantic Canada"
                        when "PE"
                            province = "Prince Edward Island"
                            region = "Atlantic Canada"
                        when "NT"
                            province = "Northwest Territories"
                            region = "Northern Canada"
                        when "NU"
                            province = "Nunavut"
                            region = "Northern Canada"
                        when "YT"
                            province = "Yukon"
                            region = "Northern Canada"
                    end
                end
            end

        # regions with province names, regions, or the word Canada
        elsif (s["Ontario"] || s["Quebec"] || s["British Columbia"] || s["Alberta"] || s["Manitoba"] || s["Saskatchewan"] || 
            s["Nova Scotia"] || s["New Brunswick"] || s["Newfoundland and Labrador"] || s["Newfoundland"] || s["Labrador"] || 
            s["Prince Edward Island"] || s["Northwest Territories"] || s["Nunavut"] || s["Yukon"] || s["Canada"] || s["Province"] ||
            s["province"] || s["Prairies"] || s["prairies"] || s["First Nation"] || s["Lawrence River"])

            region = s

        # if all else fails, it must be another country
        else
            a = s.split(/\s*,\s*/)

            # if the split produces an array of size 1, it must be the country name
            if a.size == 1
                w = a[0].split(/\s/)

                # however, if spliting on spaces is larger than 2, than is probably a region outside Canada, not a country
                if w.size > 2
                    region = a[0]
                    country = "unknown"
                else
                    country = a[0]
                end
            else
                city = a[0]
                country = a[1]
            end

            canada = false
        end

        locationKey = locations[{city: city, province: province, region: region, country: country, canada: canada}]
        if locationKey.nil?
            locationKey = locations.size + 1
            locations[{city: city, province: province, region: region, country: country, canada: canada}] = locationKey
        end

        # create start date object
        dateTime = DateTime.parse(row[5])
        date = dateTime.to_date

        startDateKey = dates[date]
        if startDateKey.nil?
            startDateKey = dates.size + 1
            dates[date] = startDateKey
        end

        # create summary
        description = row[6]
        key = [nil, nil, nil]
        keyCounter = 0

        keywords.each do |k|
            if keyCounter < 2 && description.include?(k)
                key[keyCounter] = k
                keyCounter = keyCounter + 1
            end
        end

        descriptionKey = summaries[{summary:description, keyword1:key[0], keyword2:key[1], keyword3:key[2]}]
        if descriptionKey.nil?
            descriptionKey = summaries.size + 1
            summaries[{summary:description, keyword1:key[0], keyword2:key[1], keyword3:key[2]}] = descriptionKey
        end

        # create cost object
        costKey = costs[{estTotal:row[10], normTotal:row[11], federal:row[13], provDFAA:row[14], provDep:row[15], municipal:row[16], OGD:row[17], insurance:row[18], NGO:row[19]}]
        if costKey.nil?
            costKey = costs.size + 1
            costs[{estTotal:row[10], normTotal:row[11], federal:row[13], provDFAA:row[14], provDep:row[15], municipal:row[16], OGD:row[17], insurance:row[18], NGO:row[19]}] = costKey
        end

        # create end date object
        dateTime = DateTime.parse(row[12])
        date = dateTime.to_date

        endDateKey = dates[date]
        if endDateKey.nil?
            endDateKey = dates.size + 1
            dates[date] = endDateKey
        end

        # extract measures
        fatalities = row[7]
        injured = row[8]
        evacuated = row[9]

        # merge all items into fact table
        facts << {startDateKey: startDateKey, endDateKey: endDateKey, locationKey: locationKey, disasterKey: disasterKey, descriptionKey: descriptionKey, costKey: costKey, fatalities: fatalities, injured: injured, evacuated: evacuated}

    # end loop
    end

    return {disasters: disasters, locations: locations, dates: dates, summaries: summaries, costs: costs, facts: facts}
end

# extension to class Date to calculate canadian and international seasons
class Date

    def season_canada
        # Not sure if there's a neater expression. yday is out due to leap years
        day_hash = month * 100 + mday
        case day_hash
            when 1221..1231
                return "winter"
            when 101..319 
                return "winter"
            when 320..620 
                return "spring"
            when 621..921 
                return "summer"
            when 922..1220 
                return "fall"
        end
    end

    def season_international
        # Not sure if there's a neater expression. yday is out due to leap years
        day_hash = month * 100 + mday
        case day_hash
            when 601..831 
                return "winter"
            when 901..1130
                return "spring"
            when 1201..1231
                return "summer"
            when 101..230
                return "summer"
            when 301..531 
                return "fall"
        end
    end
end

# fetch data
data = parse_data

# extract values to CSV

# date values
CSV.open("dates.csv", "w") do |csv|
    data[:dates].each do |d|
        csv << [d[1], d[0].mday, d[0].cweek, d[0].month, d[0].year, d[0].on_weekend?, d[0].season_canada, d[0].season_international]
    end
end

# location values
CSV.open("locations.csv", "w") do |csv|
    data[:locations].each do |l|
        csv << [l[1], l[0][:city], l[0][:province], l[0][:region], l[0][:country], l[0][:canada]]
    end
end

# disaster values
CSV.open("disasters.csv", "w") do |csv|
    data[:disasters].each do |d|
        csv << [d[1], d[0][:type], d[0][:subgroup], d[0][:group], d[0][:category], d[0][:magnitude], d[0][:utility]]
    end
end

# summary values
CSV.open("summaries.csv", "w") do |csv|
    data[:summaries].each do |s|
        csv << [s[1], s[0][:summary], s[0][:keyword1], s[0][:keyword2], s[0][:keyword3]]
    end
end

# costs values
CSV.open("costs.csv", "w") do |csv|
    data[:costs].each do |c|
        csv << [c[1], c[0][:estTotal], c[0][:normTotal], c[0][:federal], c[0][:provDFAA], c[0][:provDep], c[0][:municipal], c[0][:OGD], c[0][:insurance], c[0][:NGO]]
    end
end

# fact values
CSV.open("facts.csv", "w") do |csv|
    data[:facts].each do |f|
        csv << [f[:startDateKey], f[:endDateKey], f[:locationKey], f[:disasterKey], f[:descriptionKey], f[:costKey], f[:fatalities], f[:injured], f[:evacuated]]
    end
end

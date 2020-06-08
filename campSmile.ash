print("This script tells you what getaway camp smile buff you'll get on any given day on any given path! Type help for info");

string [9] buffOrder;
	buffOrder [0] = "Blender"; // arbitrarily started with Blender
	buffOrder [1] = "Packrat";
	buffOrder [2] = "Mongoose";
	buffOrder [3] = "Wallaby";
	buffOrder [4] = "Vole";
	buffOrder [5] = "Platypus";
	buffOrder [6] = "Opossum";
	buffOrder [7] = "Marmot";
	buffOrder [8] = "Wombat";

boolean isLeapYear(int year) {
	if (year % 400 == 0) return true;
	else if (year % 100 == 0) return false;
	else if (year % 4 == 0) return true;
	else return false;
}

int getOffset(int year) { // made by @Skaazi
    int offset = 5; // for 2020
    for( int i = year; i > 2020; i-- ) {
        if( isLeapYear( i - 1 ) ) { offset += 1; }
        offset += 365;
    }
    return offset % 9;
}

void main(string fullQuery) {

	string dateUnified;
	int pathID = -1;

	string [int] splitQuery = split_string(fullQuery, " ");
	foreach i, query in splitQuery {

		switch (query.to_lower_case()) {
			case "help":
				print("Type your arguments, separated by spaces.");
				print("Type \"today\", \"now\" or \"present\" to get today's smile buff on the path you're on. Otherwise, input a specific date in a yyyyMMdd format.");
				print("To specify a specific path, use \"path:pathnumber\", where pathnumber is... the path's number! (https://kol.coldfront.net/thekolwiki/index.php/Paths_by_number)");
				return;
			case "today":
			case "now":
			case "present":
				dateUnified = today_to_string();
				break;
			default:
				if (query.contains_text("path:")) {
					string [int] pathQuery = split_string(query, ":");
					pathID = pathQuery [1].to_int(); // will there be a way to enter the full name of the path??
				} else {
					print("Argument " + (i+1) + " didn't seem to match any of the keywords, so I assume you input a date");
					dateUnified = query;
				}
				break;
		}
	}
	
	if (pathID < 0) // path given was either invalid or was not given
		pathID = my_path_id();

	int offset = getOffset(format_date_time("yyyyMMdd", dateUnified, "yyyy").to_int());
	int specificDaysArbitraryNumber = format_date_time("yyyyMMdd", dateUnified, "D").to_int() + pathID + offset;
	int specificDaysSeedNumber = specificDaysArbitraryNumber % 9;
	string smileBuff = buffOrder [specificDaysSeedNumber];
	print("Will be: smile of the " + smileBuff);
}
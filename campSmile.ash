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

int getPathID() { // until an option to get this is implemented into mafia, made by @Rinn
	int path = -1;
	buffer page = visit_url("api.php?what=status&for=mafiaScriptTest");
	matcher m = create_matcher('"path"\:"(.*?)"', page);
	if (find(m)) {
		path = group(m, 1).to_int();
	} else print("error, couldn't get your path");
	return(path);
}

int [13] monthLength;
	monthLength [1] = 31; // January
	monthLength [2] = 28; // February
	monthLength [3] = 31; // March
	monthLength [4] = 30; // April
	monthLength [5] = 31; // May
	monthLength [6] = 30; // June
	monthLength [7] = 31; // July
	monthLength [8] = 31; // August
	monthLength [9] = 30; // September
	monthLength [10] = 31; // October
	monthLength [11] = 30; // November
	monthLength [12] = 31; // December

boolean isLeapYear(int year) {
	if (year % 400 == 0) return true;
	else if (year % 100 == 0) return false;
	else if (year % 4 == 0) return true;
	else return false;
}

int dayToInt(int month, int day, int year) {
	//supports any date since 2020
	int offset = 5; // December 31st, 2019 is Platypus (could change buffOrder so that [0] == "Platypus", but won't ¬_¬)
	int yearCount = 2020;
	int monthCount = 1;
	int dayCount = 1;
	year += month / 12; // we now know month => [1,12], though day can still be bigger than the month's day, but it doesn't matter
	monthLength [2] = isLeapYear(yearCount) ? 29 : 28;

	while (yearCount < year || monthCount < month) {
		offset += monthLength [monthCount];
		monthCount++;

		if (monthCount > 12) {
			yearCount++;
			monthCount = 1;
			monthLength [2] = isLeapYear(yearCount) ? 29 : 28;
		}
	}
	if (yearCount > year || monthCount > month) print("Error, overshot " + (yearCount > year ? "year" : "month") );

	offset += day;

	return offset;
}

string getThatDaysBuff(int month, int day, int year, int pathID) {
	int specificDaysArbitraryNumber = dayToInt(month, day, year) + pathID;
	int specificDaysSeedNumber = specificDaysArbitraryNumber % 9;
	return buffOrder [specificDaysSeedNumber];
}

void main(string query) {
	//add inputs

	string dateUnified;
	int month;
	int day;
	int year;
	int pathID;
	boolean pathIDSpecified;

	switch (query.to_lower_case()) { // may want to change this; may want to break up query into multiple words BEFORE this step
		case "help":
			print("Type today, now or present to get today's smile buff on the path you're on.");
			//todo: specify how a date should be entered; how would one also add a path ID?
			print("Doesn't support \"path\" as a string. If included, specify the path by using the path's number (https://kol.coldfront.net/thekolwiki/index.php/Paths_by_number)");
			return;
		case "today":
		case "now":
		case "present":
			dateUnified = format_date_time("yyyyMMdd", today_to_string(), "yyyy MM dd");
			break;
		default:
			print("Didn't seem to match any of the keywords, so I'll assume you input a date");
			// dateUnified = <part of query that represents a date>; // accept multiple formats? leave the possibility of some more keywords to be entered? (i.e. not registering a keyword doesn't mean query == a date in expected format, and nothing else) One example/use would be to input pathID (or make that a 2nd input? left blank if the person wants to use the path he's on? But then what if they type "help"; wouldn't want to bother them with a 2nd input for no reason / before they know what they are doing...)
			break;
	}	

	//todo: turn dateUnified into month, day and year. Also get pathID from query if was included? somehow?

	if (year < 2020) { print("I don't intend this to be a time machine; please query a date post-2020/01/01"); return; }
	if (month < 1) { print("Month needs to be higher than 0 (but can be higher than 12! Just make sure you understand what that means)"); return; }
	if (day < 1) { print("Day needs to be higher than 0 (but can be higher than 31! Just make sure you understand what that means)"); return; }
	
	if (pathIDSpecified){ //move this inside the switch statement??
	//	pathID = ...;
	} else pathID = getPathID();

	string smileBuff = getThatDaysBuff(month, day, year, pathID;
	print("Will be: smile of the " + smileBuff);
}
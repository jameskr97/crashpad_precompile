#include <iostream>

#include <client/settings.h>
#include <client/crashpad_client.h>
#include <client/crash_report_database.h>
#include <client/simulate_crash.h>
#include <util/misc/uuid.h>
#include <filesystem>

std::tuple<base::FilePath, base::FilePath, bool> getCrashpadInfo(){
    base::FilePath handler{"./crashpad_handler"};
    base::FilePath dataDir{"my-crash-data"};
	const bool startHandlerFromBGThread = false; // not available, assert crash if true
    return {handler, dataDir, startHandlerFromBGThread};
}

int main() {
    auto [handler, dataDir, startHandlerFromBGThread] = getCrashpadInfo();
    auto database = crashpad::CrashReportDatabase::Initialize(dataDir);
    if (database == nullptr) return -1;

    auto client = new crashpad::CrashpadClient();
    bool status = client->StartHandler(handler, dataDir, dataDir, "", {}, {}, true, startHandlerFromBGThread);
    CRASHPAD_SIMULATE_CRASH();
    return 0;
}
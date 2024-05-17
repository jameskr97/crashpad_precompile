cmake_minimum_required(VERSION 3.15.0)

project(crashpad)

# Configure CPack
set(CPACK_GENERATOR "ZIP")
set(CPACK_PACKAGE_NAME "crashpad")
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-$ENV{CRASHPAD_HASH}-$ENV{DIST_TYPE}-precompiled")
include(CPack)

list(APPEND CRASHPAD_GENERATED_HEADER_FILES
    $ENV{CRASHPAD_SOURCE_DIR}/out/Default/build/chromeos_buildflags.h
)

list(APPEND CRASHPAD_HEADER_FILES
    $ENV{CRASHPAD_SOURCE_DIR}/client/crash_report_database.h
    $ENV{CRASHPAD_SOURCE_DIR}/client/crashpad_client.h
    $ENV{CRASHPAD_SOURCE_DIR}/client/settings.h
    $ENV{CRASHPAD_SOURCE_DIR}/client/simulate_crash.h
    $ENV{CRASHPAD_SOURCE_DIR}/client/simulate_crash_linux.h
    $ENV{CRASHPAD_SOURCE_DIR}/client/simulate_crash_mac.h
    $ENV{CRASHPAD_SOURCE_DIR}/client/simulate_crash_win.h
    $ENV{CRASHPAD_SOURCE_DIR}/client/simulate_crash_win.h
    # $ENV{CRASHPAD_SOURCE_DIR}/util/misc/scoped_handle.h
    $ENV{CRASHPAD_SOURCE_DIR}/util/misc/initialization_state.h
    $ENV{CRASHPAD_SOURCE_DIR}/util/misc/uuid.h
    $ENV{CRASHPAD_SOURCE_DIR}/util/misc/capture_context.h
    $ENV{CRASHPAD_SOURCE_DIR}/util/misc/metrics.h
    $ENV{CRASHPAD_SOURCE_DIR}/util/file/file_io.h
    $ENV{CRASHPAD_SOURCE_DIR}/util/file/file_reader.h
    $ENV{CRASHPAD_SOURCE_DIR}/util/file/file_writer.h
    $ENV{CRASHPAD_SOURCE_DIR}/util/file/scoped_remove_file.h
    $ENV{CRASHPAD_SOURCE_DIR}/util/file/file_seeker.h
)

list(APPEND MINI_CHROMIUM_HEADER_FILES
    # $ENV{MINI_CHROMIUM_SOURCE_DIR}/build/build_config.h
    # $ENV{MINI_CHROMIUM_SOURCE_DIR}/build/buildflag.h
    $ENV{MINI_CHROMIUM_SOURCE_DIR}/base/apple/scoped_mach_port.h
    $ENV{MINI_CHROMIUM_SOURCE_DIR}/base/strings/string_piece.h
    $ENV{MINI_CHROMIUM_SOURCE_DIR}/base/files/scoped_file.h
    $ENV{MINI_CHROMIUM_SOURCE_DIR}/base/files/file_path.h
    $ENV{MINI_CHROMIUM_SOURCE_DIR}/base/scoped_generic.h
)

# Function to install files preserving directory structure
function(install_files_preserve_structure file_list base_dir install_dir)
    foreach(file IN LISTS ${file_list})
        file(RELATIVE_PATH relative_file ${base_dir} ${file})
        get_filename_component(relative_dir ${relative_file} DIRECTORY)
        install(FILES ${file} DESTINATION ${install_dir}/${relative_dir})
        message(STATUS "Installing ${file} to ${install_dir}/${relative_dir}")
    endforeach()
endfunction()

# Install the header files, preserving their directory structure
install_files_preserve_structure(CRASHPAD_HEADER_FILES $ENV{CRASHPAD_SOURCE_DIR} include/crashpad)
# install_files_preserve_structure(CRASHPAD_GENERATED_HEADER_FILES $ENV{CRASHPAD_SOURCE_DIR}/out/Default include/crashpad)
install_files_preserve_structure(MINI_CHROMIUM_HEADER_FILES $ENV{MINI_CHROMIUM_SOURCE_DIR} include/mini_chromium)

# Set packaging installation paths
install(DIRECTORY ${PROJECT_SOURCE_DIR}/artifacts/lib DESTINATION lib)
install(FILES ${PROJECT_SOURCE_DIR}/DistCMakeLists.cmake DESTINATION . RENAME CMakelists.txt)


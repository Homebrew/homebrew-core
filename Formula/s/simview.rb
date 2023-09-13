class Simview < Formula
  desc "SystemVerilog Pre-processor, parser, elaborator, UHDM compiler"
  homepage "https://github.com/pieter3d/simview"
  url "https://github.com/pieter3d/simview/archive/refs/tags/v0.1.tar.gz"
  sha256 "dc3c837a1b304007783e31b119a24e5a8b21c7d50a6b5715b921a8275a0b8195"
  license "MIT"
  head "https://github.com/pieter3d/simview.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  depends_on "surelog"
  depends_on "uhdm"

  uses_from_macos "ncurses"

  def install
    # mock out deps vendored with git
    (buildpath/"external/abseil-cpp/CMakeLists.txt").write <<~EOS
      find_package(absl CONFIG REQUIRED)
      set_target_properties(absl::flat_hash_map PROPERTIES IMPORTED_GLOBAL True)
      set_target_properties(absl::str_format PROPERTIES IMPORTED_GLOBAL True)
      set_target_properties(absl::time PROPERTIES IMPORTED_GLOBAL True)
    EOS
    (buildpath/"external/googletest/CMakeLists.txt").write <<~EOS
      find_package(GTest CONFIG)
      set_target_properties(GTest::gtest_main PROPERTIES IMPORTED_GLOBAL True)
    EOS

    # mock out tests with newer gtest main cmake
    rm_f buildpath/"macros.cmake"
    (buildpath/"macros.cmake").write <<~EOS
      macro(simview_add_test Name)
        add_executable(${Name} ${ARGN})
        target_link_libraries(${Name} PRIVATE GTest::gtest_main)
        add_test(NAME ${Name} COMMAND ${Name})
      endmacro()
    EOS

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    # workaround installation issue
    bin.install buildpath/"build/simview"
  end

  test do
    output = testpath/"output"
    fork do
      $stdout.reopen(output)
      $stderr.reopen(output)
      exec bin/"simview", "-waves", testpath/"blerg.txt"
    end
    sleep 10
    assert_match "Reading wave file...\nProblem reading wave file.\n", output.read
  end
end

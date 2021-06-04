class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  # TODO: use resource blocks for vendored deps
  url "https://github.com/standardese/standardese.git",
      tag:      "0.5.2",
      revision: "0b23537e235690e01ba7f8362a22d45125e7b675"
  license "MIT"
  head "https://github.com/standardese/standardese.git"

  bottle do
    sha256 arm64_big_sur: "541c269d263b5f362e2717dab9697a9428b5bcb5bb29287f99288d3b9478ad1e"
    sha256 big_sur:       "eb7a0d594647919811f286fa81be6a711540c970d02823faa1fefb5489bf0676"
    sha256 catalina:      "72677bf1b529d0ce4d9d4e2490a90fa6f83b3ad8ef569b062ced1c10d24586d0"
    sha256 mojave:        "1749ef2fcdead436a08b9daaa8207b93611a5b08ca56de9fc5049172e77eb9fb"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cmark-gfm"
  depends_on "llvm" # must be Homebrew LLVM, not system, because of `llvm-config`

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMARK_LIBRARY=#{Formula["cmark-gfm"].opt_lib/shared_library("libcmark-gfm")}",
                    "-DCMARK_INCLUDE_DIR=#{Formula["cmark-gfm"].opt_include}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.install "build/src/#{shared_library("libstandardese")}"
    lib.install "build/external/cppast/external/tpl/#{shared_library("libtiny-process-library")}"
    lib.install "build/external/cppast/src/#{shared_library("libcppast")}"

    include.install "include/standardese"
    (lib/"cmake/standardese").install "standardese-config.cmake"
  end

  test do
    (testpath/"test.hpp").write <<~EOS
      #pragma once

      #include <string>
      using namespace std;

      /// \\brief A namespace.
      ///
      /// Namespaces are cool!
      namespace test {
          //! A class.
          /// \\effects Lots!
          class Test {
          public:
              int foo; //< Something to do with an index into [bar](<> "test::Test::bar").
              wstring bar; //< A [wide string](<> "std::wstring").

              /// \\requires The parameter must be properly constructed.
              explicit Test(const Test &) noexcept;

              ~Test() noexcept;
          };

          /// \\notes Some stuff at the end.
          using Baz = Test;
      };
    EOS
    system "standardese",
           "--compilation.standard", "c++17",
           "--output.format", "xml",
           testpath/"test.hpp"
    assert_includes (testpath/"doc_test.xml").read, "<subdocument output-name=\"doc_test\" title=\"test.hpp\">"
  end
end

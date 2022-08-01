class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  # TODO: use resource blocks for vendored deps
  url "https://github.com/standardese/standardese.git",
      tag:      "0.5.2",
      revision: "0b23537e235690e01ba7f8362a22d45125e7b675"
  license "MIT"
  revision 6
  head "https://github.com/standardese/standardese.git", branch: "master"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256                               arm64_monterey: "20510779aff9169f62e4a59f6660754ec0d6922cd111c815bf69448fc2cb9332"
    sha256                               arm64_big_sur:  "d33f33d4eee420512ffabc9256224944ece9cd0fdcc6927baf3fa673b9ae89d4"
    sha256                               monterey:       "b0532208ae09b3dac683c18d82124889e487e771727a4e9d1435612b4a83368e"
    sha256                               big_sur:        "f20d482991377fd461a1e877d287faa4023a9d969883f782122ea224e6e767e3"
    sha256                               catalina:       "34d139092ee7b1e1792d4576c11e782e25c23214503f60dab7f4cafc1de85432"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cmark-gfm"
  depends_on "llvm" # must be Homebrew LLVM, not system, because of `llvm-config`

  fails_with gcc: "5" # LLVM is built with Homebrew GCC

  def install
    # Don't build shared libraries to avoid having to manually install and relocate
    # libstandardese, libtiny-process-library, and libcppast. These libraries belong
    # to no install targets and are not used elsewhere.
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DCMARK_LIBRARY=#{Formula["cmark-gfm"].opt_lib/shared_library("libcmark-gfm")}",
                    "-DCMARK_INCLUDE_DIR=#{Formula["cmark-gfm"].opt_include}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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

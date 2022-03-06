class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  # TODO: use resource blocks for vendored deps
  url "https://github.com/standardese/standardese.git",
      tag:      "0.5.2",
      revision: "0b23537e235690e01ba7f8362a22d45125e7b675"
  license "MIT"
  revision 4
  head "https://github.com/standardese/standardese.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "2f2630b76ad5dafc35df35e35f966ee5a729ded210053a7bf2f13477f11b3441"
    sha256                               arm64_big_sur:  "1ceba491385026c6a96cebf9b9c86d08d2dc6ac55cbf39b26aae35100196c47e"
    sha256                               monterey:       "a4526615e78ba7361004daae63b0be173e6b942905f3d4f238ef2bbbf0e78bd1"
    sha256                               big_sur:        "e8d20ae0ab2a8aec93368edee0318a1de1add389af915a6fc54bbb0ca3259838"
    sha256                               catalina:       "b9f7ff2a1859d52cd4d621faec96264a0c25b03271b0a75bc47f521329ea604f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17a0edfb39d66170d406445c6ee1522bb1325c34bc395ae3a6464c4839feb1a7"
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

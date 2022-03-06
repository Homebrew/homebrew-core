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
    sha256                               arm64_monterey: "e1fe493b847108a48c5cb4e6e032845c7aed99b3edf48541a49058cd185ac297"
    sha256                               arm64_big_sur:  "f98cef4f60828772102b69e5ad5a42ed491e41ad34e6dd264504fa717e8ac318"
    sha256                               monterey:       "2eda251a6f304c9c65f645a0bbdd401d926a6c87bd53557c146880498a858054"
    sha256                               big_sur:        "c8b5a7fb67afdbc7513a47a6e675119cbbc6b7f8e7e0d8573c05feae3f222e2e"
    sha256                               catalina:       "2d943cbf611d175de619d386510c1577e1cdef483aa4c5b78f506b07263d82ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4deccfc6003f006aaceb6e6ce988e8ca913166049ccc6606ffd80bf1ef0231d7"
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

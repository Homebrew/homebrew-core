class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  # TODO: use resource blocks for vendored deps
  url "https://github.com/standardese/standardese.git",
      tag:      "0.5.2",
      revision: "0b23537e235690e01ba7f8362a22d45125e7b675"
  license "MIT"
  revision 5
  head "https://github.com/standardese/standardese.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "99ba1954ac0703ead1a6bbe8c2222eacb5d1e0296069ea6e6bf284fdf394798f"
    sha256                               arm64_big_sur:  "7230c9e0e0e5fd59c439f1e152b9a386378ee26fb9838b85be4b3c1c29a778e5"
    sha256                               monterey:       "50233f2b0619805516358a350dd24b33d7d2bfefaf27399157f72fcbec8a1212"
    sha256                               big_sur:        "f152f30216d2ffd6e54bbb032fbd117afe7ff618bfb8d77e61a713b714c5f3b7"
    sha256                               catalina:       "45a82a0a1f3e8f4463136f3d6b4ac911689d035016b403d5b6bbcdab027a8f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3e6e0fe41a1825fa40a7adec0095cb2ffb173c39945b90213598506442b67ec"
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

class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  # TODO: use resource blocks for vendored deps
  license "MIT"
  revision 12
  head "https://github.com/standardese/standardese.git", branch: "master"

  # Remove stable block when patch is no longer needed.
  stable do
    url "https://github.com/standardese/standardese.git",
        tag:      "0.5.2",
        revision: "0b23537e235690e01ba7f8362a22d45125e7b675"

    # Fix build with new GCC.
    # https://github.com/standardese/standardese/pull/233
    patch do
      url "https://github.com/standardese/standardese/commit/15e05be2301fe43d1e209b2f749c99a95c356e04.patch?full_index=1"
      sha256 "e5f03ea321572dd52b9241c2a01838dfe7e6df7e363a8d19bfeac5861baf5d3f"
    end
  end

  bottle do
    sha256                               arm64_ventura:  "eed1e35edbb1bfbf262b417e5aab37bec67a4077cc79c1f967163486b207ae1b"
    sha256                               arm64_monterey: "2723cd4c0704b8569c2dabf4c5c860fe0264188f594584b5f6a143d0f37cf328"
    sha256                               arm64_big_sur:  "7001995e73c41472c599e85047ca80ec445bf0364fb08e8da191c6d36f82c5c2"
    sha256                               ventura:        "6006f0128f61000170c22e6d577220cf26d856961f38d04c893be92e3659b401"
    sha256                               monterey:       "f03e71ef92a18a6576c0e7582d2b684392445d0f6345198d10abbc4a522c2b10"
    sha256                               big_sur:        "5b6ab5b58db83a13b1e485be3cf557aec4d3a0df6649f8bb934d5140bcead72b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a5f76d445bd817a56c5c60bcded105096536fe4db4067d851a15479bcafbb95"
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
    # Disable building test objects because they use an outdated vendored version of catch2.
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DCMARK_LIBRARY=#{Formula["cmark-gfm"].opt_lib/shared_library("libcmark-gfm")}",
                    "-DCMARK_INCLUDE_DIR=#{Formula["cmark-gfm"].opt_include}",
                    "-DSTANDARDESE_BUILD_TEST=OFF",
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
    system bin/"standardese", "--compilation.standard", "c++17",
                              "--output.format", "xml",
                              testpath/"test.hpp"
    assert_includes (testpath/"doc_test.xml").read, "<subdocument output-name=\"doc_test\" title=\"test.hpp\">"
  end
end

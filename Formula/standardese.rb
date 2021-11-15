class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  # TODO: use resource blocks for vendored deps
  url "https://github.com/standardese/standardese.git",
      tag:      "0.5.2",
      revision: "0b23537e235690e01ba7f8362a22d45125e7b675"
  license "MIT"
  revision 2
  head "https://github.com/standardese/standardese.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "663a3efb5ce8cc1a65fb8c02367c645f50af660c1ac9ae55f3927bd800df2d24"
    sha256 arm64_big_sur:  "521548ec3aeb1793584f40be44305171edb186cd5574803f647cc3cb8c52798c"
    sha256 monterey:       "ddf33e6b5ce26f15659b2e6000f421a003d30cf38479190e3a930d76aa599b7e"
    sha256 big_sur:        "8a78f106d9698053ba0893682ee1015571a8b045dd0bd67221a85e447096891b"
    sha256 catalina:       "9bdb9f9b5ad83fd207747ca32fdefc6919decabfd72ca43064b8b4c2d0d0f73b"
    sha256 mojave:         "5dcbae4f7f53a6cf2a654c04a0cdd407c4af89a0aada89fe69791f150d04c7f5"
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

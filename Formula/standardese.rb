class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  # TODO: use resource blocks for vendored deps
  url "https://github.com/standardese/standardese.git",
      tag:      "0.5.2",
      revision: "0b23537e235690e01ba7f8362a22d45125e7b675"
  license "MIT"
  revision 1
  head "https://github.com/standardese/standardese.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "dcbd0428ede56003262bcdc1aad10ea18ee72124d058e377d3aa9fdb5d748d4b"
    sha256 big_sur:       "0dd379d8c2a1c79b8a19a1d4de29f37c9e0b737b115ce61086ae5159ade36517"
    sha256 catalina:      "a98d4debd779b1eae894c1db1cd78b0f0b5f263af49ae66525ce0fc516c8ba23"
    sha256 mojave:        "2c97460e5c2fc0c27abd6b28159da88f013e3423dd7fb7f91bd6b0739beec46a"
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

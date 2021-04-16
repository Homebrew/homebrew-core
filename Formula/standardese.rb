class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  url "https://github.com/standardese/standardese.git",
      tag:      "0.5.1",
      revision: "22561bfc6a5d9dd371abc999d5ef3594fcc75b80"
  license "MIT"
  head "https://github.com/standardese/standardese.git"

  bottle do
    sha256 arm64_big_sur: "aace9836b47c276189ea2e575a7f7b069088a71cfad820b9a49b19327dcbe419"
    sha256 big_sur:       "24ca9c472abc6507f5c58a2ab15d3cf7a6b22f17b446eb6597c2f9913374a208"
    sha256 catalina:      "63fd4337cc37346ecd2356a82672f73955241bd80b3c1c60d000a4a240dde1ff"
    sha256 mojave:        "22cac0cf74bfec8ee30342b360a8eb391fbdb8b18516bf204990ecdee880a37e"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cmark-gfm"
  depends_on "llvm" # must be Homebrew LLVM, not system, because of `llvm-config`

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{opt_libexec}/lib",
                    "-DCMARK_LIBRARY=#{Formula["cmark-gfm"].opt_lib/shared_library("libcmark-gfm")}",
                    "-DCMARK_INCLUDE_DIR=#{Formula["cmark-gfm"].opt_include}",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "standardese_tool"
    system "cmake", "--install", "build"

    cd "build" do
      (libexec/"lib").install "src/#{shared_library("libstandardese")}"
      (libexec/"lib").install "external/cppast/#{shared_library("lib_cppast_tiny_process")}"
      (libexec/"lib").install "external/cppast/src/#{shared_library("libcppast")}"
    end
    cd "include" do
      include.install "standardese"
    end
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
    system "fgrep", "-q", "<subdocument output-name=\"doc_test\" title=\"test.hpp\">", testpath/"doc_test.xml"
  end
end

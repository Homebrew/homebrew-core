class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  url "https://github.com/standardese/standardese.git",
      tag:      "0.5.0",
      revision: "e7a7fb8f59ba4b1cf59347ac016ec558e5d72ac3"
  license "MIT"
  head "https://github.com/standardese/standardese.git"

  bottle do
    sha256 arm64_big_sur: "f6bf75faf65362d5c69d5ded72325a028905e5d9b702d027ca4e79a459fb6025"
    sha256 big_sur:       "3979144e637214aa4901c238d01bcfc821035393f11e8e44dc4c66905b87722e"
    sha256 catalina:      "9d7a5ff92c2cea51bcf4c7814710d9585d92ae7525cc932ee02af0f8a866ab86"
    sha256 mojave:        "1408890c67458e000e8b637a7c585a6114f7c0cefbad2e2069f6d9f8a7ae1024"
    sha256 high_sierra:   "b6e6f560abcd8a480e35e2613d971432129c8879d66aa55a37d00f18ca473dc6"
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

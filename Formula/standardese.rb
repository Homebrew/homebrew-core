class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  url "https://github.com/standardese/standardese.git",
      tag:      "0.4.1",
      revision: "93c122b38f3f816be6f8c31e46320570f8879e0a"
  license "MIT"
  head "https://github.com/standardese/standardese.git"

  bottle do
    sha256 "3979144e637214aa4901c238d01bcfc821035393f11e8e44dc4c66905b87722e" => :big_sur
    sha256 "f6bf75faf65362d5c69d5ded72325a028905e5d9b702d027ca4e79a459fb6025" => :arm64_big_sur
    sha256 "9d7a5ff92c2cea51bcf4c7814710d9585d92ae7525cc932ee02af0f8a866ab86" => :catalina
    sha256 "1408890c67458e000e8b637a7c585a6114f7c0cefbad2e2069f6d9f8a7ae1024" => :mojave
    sha256 "b6e6f560abcd8a480e35e2613d971432129c8879d66aa55a37d00f18ca473dc6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "llvm" # must be Homebrew LLVM, not system, because of `llvm-config`

  def install
    mkdir "build" do
      system "cmake", "../", *std_cmake_args
      system "cmake", "--build", ".", "--target", "standardese_tool"
      cd "tool" do
        bin.install "standardese"
      end
    end
    cd "include" do
      include.install "standardese"
    end
    doc.install "README.md", "CHANGELOG.md", "LICENSE"
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

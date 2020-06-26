class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  url "https://github.com/standardese/standardese.git",
      :tag      => "v0.4.0",
      :revision => "dc1e327df74c83ceb476ff3e74920cba021c7cc9"
  license "MIT"
  head "https://github.com/standardese/standardese.git"

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

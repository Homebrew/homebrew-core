class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  url "https://github.com/standardese/standardese.git",
      tag:      "0.5.1",
      revision: "22561bfc6a5d9dd371abc999d5ef3594fcc75b80"
  license "MIT"
  head "https://github.com/standardese/standardese.git"

  bottle do
    sha256 arm64_big_sur: "a95f3ade20f806aa6d68048bd636353cbc3031e95c642907bc7a7f9f0fb12674"
    sha256 big_sur:       "31285e0f92c6c1c81ef37b5b7769b8427c5fc4679201bfacf520d04e7a72e9c5"
    sha256 catalina:      "40af188953816d174b0c181b4bdb99a3d3d903ccd04790a7c631807e333e8a79"
    sha256 mojave:        "d86f50330c0a194de9daedf8eb7e673914c23d423dfa5637bb9f4569ea38c7ac"
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

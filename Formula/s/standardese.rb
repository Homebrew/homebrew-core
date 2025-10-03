class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  # TODO: use resource blocks for vendored deps
  license "MIT"
  revision 22
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

    # Fix build with `boost` 1.85.0. Remove in the next release.
    # PR ref: https://github.com/standardese/standardese/pull/247
    patch do
      url "https://github.com/standardese/standardese/commit/0593c8fbaee48ffac022e2ea95865d808cc149ce.patch?full_index=1"
      sha256 "4b204256b97a4058b88c7b2350941d2c59a6c38aeb91e4112e1d267fdd092d03"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "af802f66466bcebe181168d4f4bc9f6fac04dc1a71092b81234875a47236b304"
    sha256                               arm64_sequoia: "7aac10f0c51eba02e38e87122b0adf550cd56e7092b7f226188b914c3e687967"
    sha256                               arm64_sonoma:  "10cf6e4ea596448dac927b90a4fe4011d1541417c6d30f9720f74e1c8c706772"
    sha256                               arm64_ventura: "1a3a96186e91ca2bf4111324abebf42fcce98b306301f98f4e5a21386def1569"
    sha256                               sonoma:        "931b39b7b6e03abeae83852591f05d85ef475037c72e5c76491eb1a2f8590319"
    sha256                               ventura:       "3821d85d58e252bf2b9dd27bb4263b7d690eeed8756aa276f8ed7f715517daf2"
    sha256                               arm64_linux:   "4dbe69e5a22029c55c323b40d44fd50056136b8ed5bcf2060b7d969a0f3089c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "740d8cecff73da5d7c6d482eaa669a30c55726ff9c7439b10de8c45363de9236"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cmark-gfm"
  depends_on "llvm" # must be Homebrew LLVM, not system, because of `llvm-config`

  # https://github.com/standardese/cppast/blob/main/external/external.cmake#L12
  resource "type_safe" do
    url "https://github.com/foonathan/type_safe/archive/refs/tags/v0.2.4.tar.gz"
    sha256 "a631d03c18c65726b3d1b7d41ac5806e9121367afe10dd2f408a2d75e144b734"

    # Backport fix for newer Clang
    patch do
      url "https://github.com/foonathan/type_safe/commit/cdf334cd8e5fcb5e21ab470decdfcbd190ef7347.patch?full_index=1"
      sha256 "f9ab60828058f133c726f77ce8358714c6aa994c9cce29b703cf7a5fbdb2ae00"
    end
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/standardese/standardese/pull/249
  patch do
    url "https://github.com/standardese/standardese/commit/d0c2073f9f13d26abd1be872b809e089ed20c9f6.patch?full_index=1"
    sha256 "506c3cd1d2654aee37e200c57b9095c9bbad09de1d7a27efc545ea7c092cd4f0"
  end

  def install
    (buildpath/"type_safe").install resource("type_safe")

    # Don't build shared libraries to avoid having to manually install and relocate
    # libstandardese, libtiny-process-library, and libcppast. These libraries belong
    # to no install targets and are not used elsewhere.
    # Disable building test objects because they use an outdated vendored version of catch2.
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DCMARK_LIBRARY=#{Formula["cmark-gfm"].opt_lib/shared_library("libcmark-gfm")}",
                    "-DCMARK_INCLUDE_DIR=#{Formula["cmark-gfm"].opt_include}",
                    "-DFETCHCONTENT_SOURCE_DIR_TYPE_SAFE=#{buildpath}/type_safe",
                    "-DSTANDARDESE_BUILD_TEST=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    include.install "include/standardese"
    (lib/"cmake/standardese").install "standardese-config.cmake"
  end

  test do
    (testpath/"test.hpp").write <<~CPP
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
    CPP
    system bin/"standardese", "--compilation.standard", "c++17",
                              "--output.format", "xml",
                              testpath/"test.hpp"
    assert_includes (testpath/"doc_test.xml").read, "<subdocument output-name=\"doc_test\" title=\"test.hpp\">"
  end
end

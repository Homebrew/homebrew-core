class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  # TODO: use resource blocks for vendored deps
  license "MIT"
  revision 25
  head "https://github.com/standardese/standardese.git", branch: "master"

  # Remove stable block when patch is no longer needed.
  stable do
    url "https://github.com/standardese/standardese.git",
        tag:      "0.5.2",
        revision: "0b23537e235690e01ba7f8362a22d45125e7b675"

    # Fix build with new GCC.
    patch do
      url "https://github.com/standardese/standardese/commit/15e05be2301fe43d1e209b2f749c99a95c356e04.patch?full_index=1"
      sha256 "e5f03ea321572dd52b9241c2a01838dfe7e6df7e363a8d19bfeac5861baf5d3f"
      type :backport
      resolves "https://github.com/standardese/standardese/pull/233"
    end

    # Fix build with `boost` 1.85.0. Remove in the next release.
    patch do
      url "https://github.com/standardese/standardese/commit/0593c8fbaee48ffac022e2ea95865d808cc149ce.patch?full_index=1"
      sha256 "4b204256b97a4058b88c7b2350941d2c59a6c38aeb91e4112e1d267fdd092d03"
      type :backport
      resolves "https://github.com/standardese/standardese/pull/247"
    end

    # Fix build with Boost 1.89.0, pr ref: https://github.com/standardese/standardese/pull/249
    patch do
      url "https://github.com/standardese/standardese/commit/d0c2073f9f13d26abd1be872b809e089ed20c9f6.patch?full_index=1"
      sha256 "506c3cd1d2654aee37e200c57b9095c9bbad09de1d7a27efc545ea7c092cd4f0"
      type :backport
      resolves "https://github.com/standardese/standardese/pull/249"
    end
  end

  bottle do
    manifest_sha256 "6cd7d5c76726d9983ff6e897a3ad478dd6310de0693eb267f4a69dafdb2a5280"
    sha256               arm64_golden_gate: "b08295fabbe51894b8122229f9e3c57bf2eded24960c2566da08e826c04e4d18"
    sha256               arm64_tahoe:       "af60907f8dc7197d4571bc34eb016c23de51f8981b73c83f5754e5aa01778893"
    sha256               arm64_sequoia:     "d04fb151ca1608e9fd5e7fc8601aea6c1699b9c15c7aca714ae2169cf737b308"
    sha256               arm64_linux:       "ea0f203a7bdf21e2f03e17414b2f29d2d4ec0f0874093a79d68a166ca0871e15"
    sha256 cellar: :any, x86_64_linux:      "7790155d4ff1c554e5bcefdffaf1b5b2d7201ca5b76dea0f9b964233d7f88b09"
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
      type :backport
    end
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
                    "-DCMARK_LIBRARY=#{formula_opt_lib("cmark-gfm")}/#{shared_library("libcmark-gfm")}",
                    "-DCMARK_INCLUDE_DIR=#{formula_opt_include("cmark-gfm")}",
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

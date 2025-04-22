class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  # TODO: use resource blocks for vendored deps
  license "MIT"
  revision 21
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
    sha256                               arm64_sequoia: "0c085a6553e072c5de272972f6ac567de96866d7f1f9e1bce5fbca086c0dc41f"
    sha256                               arm64_sonoma:  "3f8eecb4c36f352b2e85f937e39a1ffd10191e4947f97db531d441520cb59963"
    sha256                               arm64_ventura: "2877cca2dec0e5d25a13b0f871f124e6b6f151c820290a3f629b18a6a2fc35e3"
    sha256                               sonoma:        "d7337d180cbf90b86e5def03d8031d26bea1fa8b9a68e09676f47ba2ddf6663f"
    sha256                               ventura:       "d0da799b3b0175478642e0fcc104a11d40757f3da3d0c48f694b7372a4de9ee3"
    sha256                               arm64_linux:   "35dbdc939daa2cc20d576caaa16f4e3a3b60c883f0f641e9c56e953abd6221ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e681ed07036aeb3b06e8be4d6bd6acecbb6b90840ab72c17e5a2a7eabbd2a5"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cmark-gfm"
  depends_on "llvm" # must be Homebrew LLVM, not system, because of `llvm-config`

  # https://github.com/standardese/cppast/blob/main/external/external.cmake#L12
  resource "type_safe" do
    url "https://github.com/foonathan/type_safe/archive/refs/tags/v0.2.4.tar.gz"
    sha256 "a631d03c18c65726b3d1b7d41ac5806e9121367afe10dd2f408a2d75e144b734"
  end

  # Fix build with `boost` 1.85.0 using open PR.
  # PR ref: https://github.com/standardese/standardese/pull/247
  patch do
    url "https://github.com/standardese/standardese/commit/0593c8fbaee48ffac022e2ea95865d808cc149ce.patch?full_index=1"
    sha256 "4b204256b97a4058b88c7b2350941d2c59a6c38aeb91e4112e1d267fdd092d03"
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

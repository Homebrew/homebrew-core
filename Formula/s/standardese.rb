class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  # TODO: use resource blocks for vendored deps
  license "MIT"
  revision 18
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
    sha256                               arm64_sonoma:   "362272beec22bc9b8ffe1cf3d1e139fb2f7b2b5216c53fc047bf02abff981dc5"
    sha256                               arm64_ventura:  "4602636a4276f940a0151df62e52d3e7cf0f5b8b58ae338109095820d51d30d2"
    sha256                               arm64_monterey: "d8c9a2a0650c729c836a36f6922a7c8bda0439aac982853932df0f0235e55a3c"
    sha256                               sonoma:         "06d53bdd40fb8a90a51fcc340d3073d6ac845fb1c9ce550eff9f4cbda9508e83"
    sha256                               ventura:        "3f5d2991596e83b23235378510c02a2e8b7b7f17819ab763b501c3979ca88da5"
    sha256                               monterey:       "5d0c9a7d4defee7b0edddc12fed4d356155f6bb0d735023f9e80fbb72dd18583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a179ebb256a5d21a95cc52a0de2d87528ccef9e139d4f3790a0f6714481c5511"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cmark-gfm"
  depends_on "llvm" # must be Homebrew LLVM, not system, because of `llvm-config`

  fails_with gcc: "5" # LLVM is built with Homebrew GCC

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
    system bin/"standardese", "--compilation.standard", "c++17",
                              "--output.format", "xml",
                              testpath/"test.hpp"
    assert_includes (testpath/"doc_test.xml").read, "<subdocument output-name=\"doc_test\" title=\"test.hpp\">"
  end
end

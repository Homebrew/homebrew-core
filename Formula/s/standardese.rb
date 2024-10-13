class Standardese < Formula
  desc "Next-gen documentation generator for C++"
  homepage "https://standardese.github.io"
  # TODO: use resource blocks for vendored deps
  license "MIT"
  revision 19
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
    sha256                               arm64_sequoia:  "7e22140475b46fb4d0fb944d7a5f67243e1d7e1b1f2ae35c0ec3aca75e5dee79"
    sha256                               arm64_sonoma:   "682acebb5938da5bbd182838a6bd952066bf1a2de960174221a4dd1feba29d6b"
    sha256                               arm64_ventura:  "b57735eb50e862f63e38353150141635957be7b675af90826d985b04f740510e"
    sha256                               arm64_monterey: "116de83b144054bb29715aee81af0f4190e0c37fb7a2836a0a2ff676b9699692"
    sha256                               sonoma:         "0e06c1bb976cbd0d915a324c0d121c107ec20468b3286a05c07ef8ff9b33091e"
    sha256                               ventura:        "02c26b3fdc36cc62bd620dc541008b0ef5f3843965b5e42d3ce0e8133d2848f6"
    sha256                               monterey:       "6a8db8378c6cad0719dd242c9c50649851ef4c97ba969e82cbff93fe0e434f94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b6c685ab4508d15a0b7b9df6bc4bb02241d28be6736b7a0e336fa835b798bde"
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

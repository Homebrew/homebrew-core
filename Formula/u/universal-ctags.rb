class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20260118.0.tar.gz"
  version "p6.2.20260118.0"
  sha256 "111bd34e10e135acab97384dcf63aa6f73330b00a852f9c412331fd9f0cd735c"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2d23b274b8847f8ba0b1db995cc88b2d3d7ae08aba1b96be5a37a124cc30aad"
    sha256 cellar: :any,                 arm64_sequoia: "9d68ab2b6b5afea31d24a41541b2d5960937cbc62b4ec876807e6cfa43c7d015"
    sha256 cellar: :any,                 arm64_sonoma:  "9fd0f1eac2a5d4bb12832b37b55c3d7cc54dd0e2a6a088dd9b40b881dcc2935f"
    sha256 cellar: :any,                 sonoma:        "d91e2486d6a866caaa2850873f7818785a8ca918a3ae8bced99c92de51b842b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "774fcd2e108351fab45ceb1ea5daf88106f2c48448b8588d826ff733e2a7d450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e2d332b54af58d2035b709aa5839d13db15ff0d81d0976c70c580df366d240a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "both install `ctags` binaries"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    C
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end

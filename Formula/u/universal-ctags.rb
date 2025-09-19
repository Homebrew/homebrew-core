class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20250907.0.tar.gz"
  version "p6.2.20250907.0"
  sha256 "0224d53cc2c3d4823b8604f15fae7943165fdac198c4c774794bb25961e228a4"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3fe6d761581c254a501fe5629f4f1dd473ae9c5dc44d989d17d0e4b4b267a8c"
    sha256 cellar: :any,                 arm64_sequoia: "337428bcf565de32e395ea41349b51886a053f919d91dee9fc0199f84e869269"
    sha256 cellar: :any,                 arm64_sonoma:  "6ce2c99bdb26853ffb626792e5448f490032524f140c4286cbfc578e2da2355d"
    sha256 cellar: :any,                 arm64_ventura: "6d98901863157293b693c2854107fcd3925e70656a0dfbf5c275eb5dc2d8104f"
    sha256 cellar: :any,                 sonoma:        "ffd49b5ec38b2c5b7e63bd7ad4e568121e62a69785264353541fb5fba615620b"
    sha256 cellar: :any,                 ventura:       "a8700b79b80a49c89d2ea41aecbc23f4fc4250bfda74fa403082b20ba6b846d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d02f9c007f5df85de34c5c1f1e0a261874863beb0995223902813b4b61637c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "493c41b9659c553e101af7c2a855896d1c6e0fe8236b870c7b6794a59cca620c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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

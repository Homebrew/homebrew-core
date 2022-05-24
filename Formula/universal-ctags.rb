class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220522.0.tar.gz"
  version "p5.9.20220522.0"
  sha256 "f1508159722f6f2eae923d219c5665270327670b06a2b366a7cd7768cd68a288"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1e386f28605cb1b611098008813ca310d504804e2da47adb3cdf1c533eb13893"
    sha256 cellar: :any,                 arm64_big_sur:  "daa9c55f04cbc53317f4f031678107dd3150e9f0650eed41b31c349d3e95c36c"
    sha256 cellar: :any,                 monterey:       "e7e8e7cd0e7cf1a4c2d2b07eaff4287bc815f23bd2b41d9448dc4319b1cf3d13"
    sha256 cellar: :any,                 big_sur:        "00793206f922763b6afdbd1471c794fff1cae48ad89b7f5b6e1a513500da5792"
    sha256 cellar: :any,                 catalina:       "6ebe2b8d1b8c0c93ccf9f5667daf14e184e5400f56d8110d59b56eab24d7f859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0922f859eb48d59bf5fd4b5dac7278973570e62a33f006494afe392e6a98e09"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libyaml"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "this formula installs the same executable as the ctags formula"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end

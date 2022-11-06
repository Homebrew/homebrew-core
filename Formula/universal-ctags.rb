class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20221106.0.tar.gz"
  version "p5.9.20221106.0"
  sha256 "8e647fa314a33088d7e8384a9aca3903ce91dfe8805676d4219051d5353cf0ab"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "51bf369837cf6dcbdd7169341cec17c0157138e1b9b410c529804a74b1789251"
    sha256 cellar: :any,                 arm64_monterey: "498e6efa1f362bdab1c1d55a1d16485c634a302df8ede83c57668ec03ed31b86"
    sha256 cellar: :any,                 arm64_big_sur:  "b08b802932ede66ef282cdd6405d83a52b617885452115a58c3f8e272aee189d"
    sha256 cellar: :any,                 monterey:       "22e36457e3e6ba01a9dba826ada3c8bfc298dca04ffeb99c589e4042a017344a"
    sha256 cellar: :any,                 big_sur:        "6e4283aa16eac1a04e2333e6cec7f2af4fcadc2244949030ea13a0cc9b53b659"
    sha256 cellar: :any,                 catalina:       "446fc75cffa6a31231fcfa7f19a25826f185e594e8def984cbe0b0a94072cef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1be4f44f6b32d14414d7515098b83dbe6359f88d779d5f9729795cfcadf95124"
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

class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220626.0.tar.gz"
  version "p5.9.20220626.0"
  sha256 "dfac3cb29bb2d21944a7edf09de45ea75c70fa15592467bb4138d1e4ca2d0fa4"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "30ad9445a5bad57af19526e6c0b14fcf2a0719bcc74cf4bdc29a5a9cdb4b0b9c"
    sha256 cellar: :any,                 arm64_big_sur:  "dcc1d21d9dce3d5089846e3ae99d72ad7043252e4bfe2243cc595c14ebde2b2b"
    sha256 cellar: :any,                 monterey:       "2c0cd2ed2859a98a54fbd10c0845d4a7e0caefde2cdd155444c326acd0450b36"
    sha256 cellar: :any,                 big_sur:        "adb1a815472e839fa4ce4e004d2c6a7c1eef16163e259d26dabb3410dff1c6d3"
    sha256 cellar: :any,                 catalina:       "2c6993725ea3d788c97672f9916a3264b69328b0ecec452675358a47469c5c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50bc51be45929c86eda6f4447fd1483d20df2004e8b57dad49632b987a7eb079"
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

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
    sha256 cellar: :any,                 arm64_monterey: "5bda7e158114a9fb0363f17f6584b77da9a4b42342fd7d6d6c33599120d8a71e"
    sha256 cellar: :any,                 arm64_big_sur:  "a8c52873acf4bef320187a5dfad030b07c19bee90b9d086ea29d6bad70616049"
    sha256 cellar: :any,                 monterey:       "ff1a78c4d16c890c5d2f09887e6005430e955a61a3a27210d1e70e6d328b385e"
    sha256 cellar: :any,                 big_sur:        "8b61392591a20f6e6aa9e82328db1df39c6510ac5253f2740aa37e1e15fc421f"
    sha256 cellar: :any,                 catalina:       "ec8d7e8006b3270f2ed0a4026f61132ac429c0762b32fa3702a05c3433d2a24f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cc486b8f1e526c412461e22091eda5290cf9e192c88cf58d3489eb31b02f75a"
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

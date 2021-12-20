class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20211219.0.tar.gz"
  version "p5.9.20211219.0"
  sha256 "6623c81984c0e662d50cf21b45def00d1f61ce595d70b2f978b07c28288971dd"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "63e2244ffd445abf04f3179e48ef5699868c1faccff43a7f959c7fbf43380e48"
    sha256 cellar: :any,                 arm64_big_sur:  "033b9aaaed35ebeeef278b1e60df8ed5af410a8051c954cf3e253c5aa45844c1"
    sha256 cellar: :any,                 monterey:       "c177df7e5978e91484a57bfdae88d65019ff40b5a51c1c61d31bb9d3f771dad5"
    sha256 cellar: :any,                 big_sur:        "d18c4eed7edc5e02cd3af2830c5b6295fe5a8fe368a0114dc99c251d6684b4f5"
    sha256 cellar: :any,                 catalina:       "85907eb81cf18615931f920cdcc6993b77572be26ad8b28b75af03656bd99eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d50613923cdc063380ed02bc8972123b9c577e2cdc365be06b54f000c918af4d"
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

class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220123.0.tar.gz"
  version "p5.9.20220123.0"
  sha256 "7dc8eda48aa3cd098f5b981fce950da2cf7fafd938b5b479ab55b474c29b50e9"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "330e42157f619df6653231dc3e0dfb54b435b6714d29b14b74d4d96c75216012"
    sha256 cellar: :any,                 arm64_big_sur:  "fe819e117bc50bef755fede9594a7565b32eeb7fcefb65be85911274024054f8"
    sha256 cellar: :any,                 monterey:       "963cddb4c0719c3b9ef408c0c3095c9468054feae105d1cdfb4f3ce26d84f818"
    sha256 cellar: :any,                 big_sur:        "a52794c188bcdfa7d17ce24b0ddf9f8a59530995e5b6752bdc02adb0b49da914"
    sha256 cellar: :any,                 catalina:       "227b59b162f27578963e8593af6842a361f7b429f366319c2f5144657fdc8683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6f8f5406898387a90ba762e529b554ea5dcbc1c51928dbd73226d5642f8cd0b"
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

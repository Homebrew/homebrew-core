class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20210704.0.tar.gz"
  version "p5.9.20210704.0"
  sha256 "07c01e3ed8163100c9f17d6e74683cdb676a803b43f9ae3c3f2f828c027131d9"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "35e9d2d17d249d990d004e833102d38f1152af5f217f7d4fbafd8c0c3fffe9df"
    sha256 cellar: :any,                 big_sur:       "040ed8e3bd8763935f26d9171fb71ec3e3d9b0eaa4648175c9fa1bbc27f3b5d7"
    sha256 cellar: :any,                 catalina:      "af2708e6e86ce02dc780448affdf42117fcd977e36260119656871b737912418"
    sha256 cellar: :any,                 mojave:        "300fe7c6626914a338bbdd985b9fba389c8abfb245152ac019278104a7181648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e6864d8ff4db823fee7f9be1c8f0800c0cdacbd808beaef2bd46860f71c0a89"
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

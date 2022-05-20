class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220515.0.tar.gz"
  version "p5.9.20220515.0"
  sha256 "0f6de6f2434290304187d03b9816e1a2a322f922d124264f71e0ef7e07e7970c"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9065b5a31266f9d31ad2561f7c424002e109a404878ae26c74c84d3624f4c4bd"
    sha256 cellar: :any,                 arm64_big_sur:  "1373315753e32acbbe5b19f2a7b02a63c9a10bda700ba86fe638d4ba69b54236"
    sha256 cellar: :any,                 monterey:       "6d9a9e514998b7eeab0f5f7c4d5125552f0c8685b237fcf0a35cde52d8eff0f9"
    sha256 cellar: :any,                 big_sur:        "01206c5d898adb02db58199c8af58b24a38d1e01a8d3f6549a869a28955a4c52"
    sha256 cellar: :any,                 catalina:       "d08af7aac9cdb4ffc2b78ebd19b2d1f85f39237fad93db75ca139cfaa2de1a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e83ac412091d2daa4dae9a2a4db9df87ba9e369e7d10cc6855650d66850dac1f"
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

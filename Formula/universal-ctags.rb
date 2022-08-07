class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220807.0.tar.gz"
  version "p5.9.20220807.0"
  sha256 "e130ab33b29ea599a96868e0f57357a165698e1fb688d9ec0e151d44f74470f5"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "79fc6fb7eccc27e5ca5fde54086f1a932617622b906e084018257ff36f498578"
    sha256 cellar: :any,                 arm64_big_sur:  "6aa553c3f9fdd5d60389fc734d3e4c0f17c1c9953c9ae8709bb50485f2e182ef"
    sha256 cellar: :any,                 monterey:       "83af19674ab179e0bc10cb1d712b823f781e017e4358d1dbe920e985608c0606"
    sha256 cellar: :any,                 big_sur:        "5e87935ef030a0bb8a07b72ebece85cfcc4e247f6f4f6e381ef6ed784595a690"
    sha256 cellar: :any,                 catalina:       "3460cef65d37fe0405ed80a09c6e476c9093a77f603cc2c212f10fe750103e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "938a521f4143eb974923c98650435ee3337c67024121afd9d1dda559a5bb8ad8"
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

class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20210822.0.tar.gz"
  version "p5.9.20210822.0"
  sha256 "66066b18b73c94335d511e4fc480489b7432c07cfce737caa379ba0b1d2a4a21"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "18deda2ae909124b629ae176330e662d2b768d1a0a57288881fa9dac0838313e"
    sha256 cellar: :any,                 big_sur:       "e7fa514f671dd09276bceea66405f75897da0de12e927e818bde5eb64e37adc1"
    sha256 cellar: :any,                 catalina:      "2361a3ade9879e66c8621f53e51db8412220dbb7680e4e9ecface9f96fbe83f0"
    sha256 cellar: :any,                 mojave:        "95a6146d5b25ecf6806e64c33fa0afae35db0cecbeb68399d8a7f5d5a0f656db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "755cd99affb4f76bb367366a642347871903978b2c98a5d1c391bae56f134bda"
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

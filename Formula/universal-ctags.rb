class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220313.0.tar.gz"
  version "p5.9.20220313.0"
  sha256 "bd37cef4e072405ca690e0aba650782503953d112c082e0cda43c76ad432d008"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9f2795fff515ea2e510cb2b026fccba87d0e1faca2cf9b691336f4fa0dc2f9c0"
    sha256 cellar: :any,                 arm64_big_sur:  "80c73a5c3b7825979897efdde5f8e47b6da577ce61af1c6c3daee88f95fd72de"
    sha256 cellar: :any,                 monterey:       "c47d5d7c37250c5b47357347d765d7abfb60d877b557d3b885fa9e21a5800740"
    sha256 cellar: :any,                 big_sur:        "6c7a556721c2a4032de1dd45decd0db836d0285572bb66620fbc635c15a9067c"
    sha256 cellar: :any,                 catalina:       "7065ce8d62460d6e25702db1c79d30c2442f1007ca8914688396b5118553551b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27bb1d9cbad7fdfe29e1c46bc06ba64d659ecfd69bb861dd143763dbcd10f420"
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

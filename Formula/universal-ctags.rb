class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20210926.0.tar.gz"
  version "p5.9.20210926.0"
  sha256 "87a19089fe1cf16b4780a24a6ab4e847280182ffba95ab3db76a0ddc0a7b170d"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c589446817aac504079f1254a8a7e5bedafc78fd56631ceaeef5123a389bf83c"
    sha256 cellar: :any,                 big_sur:       "2b5352cf0a743cc2dc98dd6fcc65ce2b5bb09fe3b25bcfbae4bacd4b7a27864f"
    sha256 cellar: :any,                 catalina:      "fd8972db2289c874b8ad1a5e1db6aef61bdefb5c5b3346093d196ab813b114aa"
    sha256 cellar: :any,                 mojave:        "8cbca9015282eb559eb94fcb13461ae6146eb36caee6060e0aa31b099867f37c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e07e9d7cd18fedf05b2a4e809b4215405cbaa269dd69cd79ce9e009b7b8dc25"
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

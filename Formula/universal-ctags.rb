class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20211024.0.tar.gz"
  version "p5.9.20211024.0"
  sha256 "6f81a940744672760f218d2fa52d7acee3ac0d59ad1a37e9746782016deb157b"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c263d1cd88f171bb4c0bf814ee580b8738672a5100b2e48e37861da06182b996"
    sha256 cellar: :any,                 big_sur:       "82864e51b0bce6dc1398a47b796529e564bf2ff61f32098203df61db3d66098c"
    sha256 cellar: :any,                 catalina:      "eafe7bcceecbb7f8ba9f1c6515074c23eb87dc20faa5c96e15b947bd553d35b7"
    sha256 cellar: :any,                 mojave:        "01cccbad23e42ee4e07748a30addd1e1e8e5d0cb70848c939ac8760cc9368ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2de8abbcad062c1a0fd8b7c457ce8794f2e3f9af1255cc1a64b5ac03c3127cb8"
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

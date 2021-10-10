class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20211010.0.tar.gz"
  version "p5.9.20211010.0"
  sha256 "4a847b743629c71e9c4da3b7267cdba83e4a4891064ff33282e67f66360a567e"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3d7269ef004a4890225009f8e31d901689d3d90c3c84bd6f072119d723c6517d"
    sha256 cellar: :any,                 big_sur:       "3d616db43666b429094abee80d87a37b5d5503f9eeba445be695777c6e3c493b"
    sha256 cellar: :any,                 catalina:      "48841a65fe380e74d28b7611ea3672af4a87889f421d427dd364bcf1b0f62aa1"
    sha256 cellar: :any,                 mojave:        "b0b81d861884e00a4602f406e6a6f6d2653238ad8a5f87604a5d535dcd08d49f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffbaf15c244d2eb319e90af55dae930e40dbf32743194470410945e212535f9a"
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

class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220403.0.tar.gz"
  version "p5.9.20220403.0"
  sha256 "df966f73ae6082acb9f4f7fe4e27f53a593782380f28ccf65f0ac38aaf697888"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dd566aa90d78c897c8080a2fc86f5186510dc02fddb384b7ace149d1877c4b0e"
    sha256 cellar: :any,                 arm64_big_sur:  "4efd74641f1427a8251ee8594f66110732da563a2ac7954e67203c6840245c08"
    sha256 cellar: :any,                 monterey:       "03be8267a845bae17a8277e37f7fcc0e8037e726d0e37485e4687fb78722820e"
    sha256 cellar: :any,                 big_sur:        "f0e4702c553d4522756a63981351487c97822d46e00e59392f6d86e89e09026a"
    sha256 cellar: :any,                 catalina:       "464b229b2cf1538427dbe6278dd9abf88f41301dbdb55c3b03945b3954ec27af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12bf6079306b5f9b3cb5a3809c0a13d06071437948fa8df514de598f9aeda5b6"
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

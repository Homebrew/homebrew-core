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
    sha256 cellar: :any,                 arm64_monterey: "eb1b14529d9b7364246d8983db91b2bf2de45b6f54a2570be84fa213f0b0c796"
    sha256 cellar: :any,                 arm64_big_sur:  "3a985ef62c133d78143d9a3fdd97ea528b182cce4d1bb405978db3285e28e6e2"
    sha256 cellar: :any,                 monterey:       "675665e09336ab726756c457d8089007c7423342e2b9a636b8b4179390fbae6c"
    sha256 cellar: :any,                 big_sur:        "739c24c3aa3ba3df42da1ec8942d5f33d44c2d1da55125c379b17c4fdaed154a"
    sha256 cellar: :any,                 catalina:       "f6bbdef53c0e73905e3d6eab2eec9dc61f11ece4820f7aaa72762822d61084d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f79967e23b17f64aeb7ecd07b5c53ce12c7671b518c300657243a5c69afa4e44"
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

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
    sha256 cellar: :any,                 arm64_monterey: "27717e170d64bc0477e27387c8d09d601d908d5743d7309d55ce20f6e5b36883"
    sha256 cellar: :any,                 arm64_big_sur:  "2037532a03d52b0328f18ac2bb4f1abd61093689a8dd940091ea2a4d4829d3b7"
    sha256 cellar: :any,                 monterey:       "c2e3be2b2a7d1ae66c3e266bdcd8b379167000dd54f1fddd65171bbcc9430586"
    sha256 cellar: :any,                 big_sur:        "e76b6f3ebdde0698fda219daa9180190e66e8f416688302a9ecbbb400aeabc84"
    sha256 cellar: :any,                 catalina:       "a636f0c8b28a0782ecd98156e43f5975e574e27ac4fa5f89181c8d4d70eb5abb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ee7849598efe4d73a661c920450e8624bd887466d0303fb7c1fbbfbdced26b3"
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

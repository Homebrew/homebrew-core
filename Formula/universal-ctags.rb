class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220612.0.tar.gz"
  version "p5.9.20220612.0"
  sha256 "a925564b843ea656aecca8db4f538a3e8d69b2544543c4ee190904b8d9e0e99c"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0cd6b98b5df564a149806eccc9446ab75456fbc0d9a240644bb04b4f73e60636"
    sha256 cellar: :any,                 arm64_big_sur:  "06336469065ac3d183feae9b03dd50bbc3deab69b0b7be7d3cff15bee257aa75"
    sha256 cellar: :any,                 monterey:       "170d84a607bf47d47d3a1cc60747bb8a6cb6d98e8a2aca76df176df49eeb0050"
    sha256 cellar: :any,                 big_sur:        "8df244b90d6466ba8197aab0eaf84b4c4d744033e3e37f0fca19b9b21907cf21"
    sha256 cellar: :any,                 catalina:       "f87b4af94e311efe6f1fdadfb2de3e8a1bbffac7e8b0d840cfa8276a9752d876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "771edfef96762e928b4b3a3a1a18798760b8f0454da04f20de812b9499576b33"
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

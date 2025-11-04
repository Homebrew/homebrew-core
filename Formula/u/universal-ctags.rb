class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20251102.0.tar.gz"
  version "p6.2.20251102.0"
  sha256 "a920c411c2da33f7acfc0e53dbfe610080b78330114fbdd435856257a4234be0"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "012dd4be0ec320cb272e2c9f9e7fe8db14ceba515eef61b8c3a0496f68a0c936"
    sha256 cellar: :any,                 arm64_sequoia: "afeb31c2b7324d5490229fa87296ff3ab2de6a5ed118e648108448b76e90302f"
    sha256 cellar: :any,                 arm64_sonoma:  "0c8961ab1a1888cf8a8466de0ce35d1b9245d7c1eb36d0d05a25e7b1bab8ce18"
    sha256 cellar: :any,                 sonoma:        "58ded787f2ae1acae7ae91a1ad0f0c41a472c318531e2a383fb2701af24f54d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "664cd0e44ed35789d1dfb0e916f68e8fb06b5ab7f46748ba7181a0f304b89377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfed90184e56481e5059b02f1972fbb647475b6b97a4f2754343eb9e56b9f53b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "both install `ctags` binaries"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system bin/"ctags", "-R", "."
    assert_match(/func.*test\.c/, File.read("tags"))
  end
end

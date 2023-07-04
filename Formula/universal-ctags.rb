class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230702.0.tar.gz"
  version "p6.0.20230702.0"
  sha256 "e56a62408f2af8562332c4f058b15c36af22cb9ab7e467eea3816aa907657c3a"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7d443fc87745bac941388e4723def954e195294ab2b1397fe45e454652e6f3cd"
    sha256 cellar: :any,                 arm64_monterey: "1cb147a83c9ab6a7139ad41b0513e0c68f371e0df0878c5d7607f45951a747e3"
    sha256 cellar: :any,                 arm64_big_sur:  "e5dc3e5f517e5ce4b520e088ee14366b723e54229bf2df059f03ac3106af152f"
    sha256 cellar: :any,                 ventura:        "a90a0f74534cfdf4b6f11e65b9cbf7d2279067f1bdb7ad575fb54beb7de54a3a"
    sha256 cellar: :any,                 monterey:       "5ed51d144a57e993c6d38741043ce862a8272437108f464a77373c6620c2e15b"
    sha256 cellar: :any,                 big_sur:        "6391e1165699cfe29fc5ad20869d4ca0a47b082305032c28bccb742cfc7ed863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ac663818801e3ba9e8de471d2007d7552f9feb46334e73675ce8a99efe41893"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

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

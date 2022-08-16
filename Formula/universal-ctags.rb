class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220814.0.tar.gz"
  version "p5.9.20220814.0"
  sha256 "6f912726483ba57e1c80468fccd1329a1b40ba03cd5630529bbe09497902a7ef"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "30bccfc01fcc9e68c11e6016cf3aeecae1bf3da66df8ffa63f12bc74a7031142"
    sha256 cellar: :any,                 arm64_big_sur:  "ab1e9313ede6520211ef082a7806fe805dcf3f935088f622dbab49e6e097fcc8"
    sha256 cellar: :any,                 monterey:       "cba36afee73d6ebfd45081da22ae0be3da5c0f3b4cdb3a33778f4a09d7f2a13f"
    sha256 cellar: :any,                 big_sur:        "c0cc98f96ab0f006d8859de10306143b8e5c35b64dceec6c6834f0aaadcd46bb"
    sha256 cellar: :any,                 catalina:       "a1fe32f63722e264ef80b16484ffadac637bce2b23ac7c58939d003d2d5f88af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c16471659a5deef9a4b8acecb14a69af15fb72e1842e790756028e2c03631b13"
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

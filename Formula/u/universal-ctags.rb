class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230827.0.tar.gz"
  version "p6.0.20230827.0"
  sha256 "d7e05a91785c14200496d4fb5573084387f86c09c5b730c19d41681da5fab26b"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d7e4f24f7297de98e4d64535f8b51dd01883c5135cb2f4b7b47a8303270e638"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01bb17d10947e0bf41115e4b5154c9443525469192be23f137da79e8faef5bfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "334624e9bed64126477b61d5a11809f676c858d254762ce1098f054f727f839d"
    sha256 cellar: :any_skip_relocation, ventura:        "97c9a39ff548ccd8243a8d4695903466d51c79e41d244b8cbc02f0827ad7e5c3"
    sha256 cellar: :any_skip_relocation, monterey:       "9c3ef374d5bc82cd9ba1c536129b89e8405fbeff8d600ef56499275c88c9dd37"
    sha256 cellar: :any_skip_relocation, big_sur:        "eeb586a1c0a907333fdf5bb30fdb173fa8ada993b513f79022d7a15f92ed6ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c322ad7238ac1142eb6baeff9976d9b9b0ea39522a4dd4f0f033d9de226d82a"
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

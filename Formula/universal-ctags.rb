class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230101.0.tar.gz"
  version "p6.0.20230101.0"
  sha256 "bf8f3ff4a1ca2a8f27390b65569061570cfb2af9674d4e7b54e3474f8ecf8d25"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "89c869cfccab8fc3e5864136f75f5e492d6dedfdbc812a5be109406645c52105"
    sha256 cellar: :any,                 arm64_monterey: "e97c1dd027433ba01e496ca11b02974f26ff13d0f3f8093a6a401dcf6dedeaf8"
    sha256 cellar: :any,                 arm64_big_sur:  "bf7c7eb60677c222c3cc4ec89ecc7d3caf0db6265efe64aa99b75c3e21c984c3"
    sha256 cellar: :any,                 ventura:        "f6cccd16262e8f27543a96c02fa4018f5fde2b0892723919434784e3d091f2ca"
    sha256 cellar: :any,                 monterey:       "152f69517fc32826862bd6f2556cbf15b41acd4d34588f14b3832fc90ad49f99"
    sha256 cellar: :any,                 big_sur:        "c7ab068e592ca66b646406cbc8e533ddb76ed9c3602418ca66530be677bfa497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "759c49b0208eb5c571389a280cd13699dfb0f538711474e69dea77970aaf61fd"
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

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
    sha256 cellar: :any,                 arm64_ventura:  "dc32798d72dc86f5c65b76c821454f0b93978098f6549dfc927e38497bb7d85e"
    sha256 cellar: :any,                 arm64_monterey: "afaa094fa91be07851b4ae63aaaa7cbcab51a5ae177a3055386a1d4c1fb6fd90"
    sha256 cellar: :any,                 arm64_big_sur:  "38ef1c1ac3de7dedf7b2cf38d324bc36129bf9a3863298e9074457bc191572cf"
    sha256 cellar: :any,                 ventura:        "b373313eb50eeaf858dc10c0b72c5b4e2748884347fd2c906f00702bde4dc167"
    sha256 cellar: :any,                 monterey:       "e555006ce777326ef319e1d6153c34b3ac2cb5fc2f6ea11c8f164735699da665"
    sha256 cellar: :any,                 big_sur:        "371b7ede998edd3bbb3671a31e144f1f6da49446ebb7dc782cc93ddd0bbe3d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b1b4bd85587f11d67dabac29c083d504c208a424e07887445fe57676be9c7d3"
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

class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230305.0.tar.gz"
  version "p6.0.20230305.0"
  sha256 "e687bbe56af1ef8637520662a91edb1ba02dedd58e47caf90852030ae2c08d4e"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1fa60fda0fea5bf5465ba47a73ab31be99697bd242e633355c57c9fd56306273"
    sha256 cellar: :any,                 arm64_monterey: "170f2696fbcbdd47f303d7b006915cbea13df995e4f5bc0a17182a1b29236f62"
    sha256 cellar: :any,                 arm64_big_sur:  "161d9f4c244d4f4c6018fcc1672304ff0a4ad8e1406b55ec72cbcec87af5868b"
    sha256 cellar: :any,                 ventura:        "cf550553d1a3771aed90043e0cd5245cebeb72becb954c2875a768ae4b40f0ff"
    sha256 cellar: :any,                 monterey:       "b8d2a12893109d2ed1dd78bbfcf8b30fb64dfb89002651c736055ab3a481eed8"
    sha256 cellar: :any,                 big_sur:        "8204233eeffa0d996e1634a3f2dd14fcdf19521af22cc357707e89ffe9cb57e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27dbbbf9d6e6939869a716e4a638bba9b4453e16e276a3a11dfe72f74a3e6713"
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

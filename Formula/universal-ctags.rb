class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20221030.0.tar.gz"
  version "p5.9.20221030.0"
  sha256 "e990b78720bd2ae2e6a068d3c63fc3fbb6b7af2bb16fec13805649e2a16e65df"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "35bf69626352e0f831f7dafd3b1079c283ed9ea4a67348b1c893dba2650b2a82"
    sha256 cellar: :any,                 arm64_monterey: "2facbaa6e1dabf281eae78cb07062402f0e90041334c7a54c38ddd0922fe6fe1"
    sha256 cellar: :any,                 arm64_big_sur:  "111c6a64bc76396224a328480a0ca98b6134ac279619f4bfedde2aa1aa923e73"
    sha256 cellar: :any,                 monterey:       "a78dc9d97b16153c899e1779a3475711ddb0ba344f18182fd56178e63a310d2a"
    sha256 cellar: :any,                 big_sur:        "3ac424239505373bc98802469de64c4cb8964c9bca6305ab60a04872cee5918a"
    sha256 cellar: :any,                 catalina:       "87d60f6864f71fddb4327a94904fe6b26cb17beb224187796441acf2d26cb4e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18094b04ca0cf6e14a0740773db15456e752da84ac54cf60394b4c437a8bdb78"
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

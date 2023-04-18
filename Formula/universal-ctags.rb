class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230416.0.tar.gz"
  version "p6.0.20230416.0"
  sha256 "97a495ee5af15e886713ee63057ecc0c7cd0307d5531754f1643d2240a602541"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "60a941d62c12beb51c76bb7a9024980c4c9752b45c33a606f0de26f2f23bec18"
    sha256 cellar: :any,                 arm64_monterey: "3c201a81a2548206b4570b4b98aa819f5a8bf2216021dd95f207049230c83ac2"
    sha256 cellar: :any,                 arm64_big_sur:  "e6d7f19a77dba22627914d9781fe8ae98df70acc941e4976399a39d4c8f973c3"
    sha256 cellar: :any,                 ventura:        "ff425e7bde203310763a3e7da7a92e1860ba682acac508353251f8de772c973b"
    sha256 cellar: :any,                 monterey:       "a027f7baff1467aec9f8a411078013a80e3192ad4eedcb64a013a5c1bba0210a"
    sha256 cellar: :any,                 big_sur:        "3e67667d213394c76fbf94a6d3ec763b3fbc3582c1c6abf32f8bc5598d6a4c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7c5f1456b0a2fe2480a4bd3d87d068eb373ead6a8e2e73e06af0d2c90ff5c36"
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

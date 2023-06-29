class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230625.0.tar.gz"
  version "p6.0.20230625.0"
  sha256 "ea87342807b438f21a7d5bbb9de0130204aebfc5e92dd87df712251a6a189e69"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5e75fe7e9ea2fdd960a0537cb187b11a4d25217f47aa034beed7aa06e6c5d795"
    sha256 cellar: :any,                 arm64_monterey: "b393d0bc469f1e1809271bf92d162e66904615ad52eca494525ff3c70fa61922"
    sha256 cellar: :any,                 arm64_big_sur:  "0d709a13d96139ca411ae0d047172f99a476a627e4f8a80c171ba35d9f659ed6"
    sha256 cellar: :any,                 ventura:        "a714d28a29f35bc70101fbde4a3cdc3dfd6675bd29e662a06f0e0015343d6c9a"
    sha256 cellar: :any,                 monterey:       "2ec58fadd5cce680dfbdc865ffd62d83c2479e8189be386e018c97af65118fc0"
    sha256 cellar: :any,                 big_sur:        "59d50388a82de0f0b0aadd0b36b5e856e5ae50e1195b2ed98ab282672eb9a346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97f75950c3b303259fd023e32de7d0824af5856a937942d66153900e942f3037"
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

class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20250504.0.tar.gz"
  version "p6.1.20250504.0"
  sha256 "c679a89dea4a8a3dbe2cb797bcd545e0893df72fae8560e8f02362637431aec8"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b16d59ef38e624b0ca3ee328b945b272b59c484bf9b267a5e3a87989094e514b"
    sha256 cellar: :any,                 arm64_sonoma:  "ab792eb4b53da1deda249246f72174b27185a0d6205e532441e5249054d725f5"
    sha256 cellar: :any,                 arm64_ventura: "063e85f3c579c83f51142200b42b38f4c5b72a248f2f57b10d9be7f7f65a515c"
    sha256 cellar: :any,                 sonoma:        "d316a70a3930734d8946cb3a9ca54825ebc64a7c4c53d5305cd9354bb15039c1"
    sha256 cellar: :any,                 ventura:       "de36a6188715552f7207ec00445e70957c12ea5c4b951cfebe382851c38e855f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ae4315a9b7e8e0057b4cfe29106547e565303a985b75c5070622535aea09d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d05f78f75e9c48668d1f2c764a72a442cb9473c81f3cf62e3d47d42248449b8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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

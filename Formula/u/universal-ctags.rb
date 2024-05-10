class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20240505.0.tar.gz"
  version "p6.1.20240505.0"
  sha256 "d9329d9d28c8280fcf8626594813958d9f90160ad6c7f10b0341a577d5b53527"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "25e5ac31594e9db9e8c7c46ff167007fd7f7c463f038140d969695c1659a2ba2"
    sha256 cellar: :any,                 arm64_ventura:  "3897a09916b2f3447a9dde6556a5724ddacc320e2c31fb62346844f57ff431e0"
    sha256 cellar: :any,                 arm64_monterey: "bd2c617ca3cdba35438bfb3439a8f457995ccf19f929a3b3fb09db6f67f08113"
    sha256 cellar: :any,                 sonoma:         "0ad2dc540e1cd3b8a612ee5df08e5bcbad16232aa3a1d9dac289ec6983956734"
    sha256 cellar: :any,                 ventura:        "0431906e73ed2d65f7953433c2fbbf8be6ce18adaffb5751d4f59354bba6421e"
    sha256 cellar: :any,                 monterey:       "5d90b5dbe0e4a0d95b3582a6fe7a7e7623d408d599748cf27886867ac5b7cd9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "260b358c9671d4887ee3adda625e90e096dd9343b5138617ef73f59914bb2f86"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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

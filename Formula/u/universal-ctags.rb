class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20240225.0.tar.gz"
  version "p6.1.20240225.0"
  sha256 "2a49ec7d87c2624f76c8845823178605dd7e28f7733bc23d7c7b59522b523967"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a37d45f113b0518a8f1ed186e41e699956d7e889c0690a92758893755c2790e"
    sha256 cellar: :any,                 arm64_ventura:  "9b67feec09c672ac4c7f6eff7ae9f9c5eb5d23b5caa00225765fd8c510b51e98"
    sha256 cellar: :any,                 arm64_monterey: "7e5a7cab39c9387157c28e7f2ed13883506c3f5ec0f9aed6b144f5f58ed482f6"
    sha256 cellar: :any,                 sonoma:         "f53b8388b5e73b04f83cc5a894df9ea0002b595efc64fef982933645450f11c1"
    sha256 cellar: :any,                 ventura:        "ad5891c4f1c09412f0dc7a35aa2a96e99fbcfc5d6d9af15ab0a774d5a2a00d5a"
    sha256 cellar: :any,                 monterey:       "316c437c068f89c98acf30eeec2c034447e3db6c9eb58d28a0cb0b5c774d2d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90ca328449712274d5564a94a3ed45f2bf297af7696242b3c29baa4885b5c02a"
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

class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230924.0.tar.gz"
  version "p6.0.20230924.0"
  sha256 "00010818f8577e803ea86d3fd673d64fd99a3bc940f3c853e1572cdf788ae79a"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd9af7665a43f2d7d72d24197c3055358b7d4c571d4c04c4446bdd4c64aa133e"
    sha256 cellar: :any,                 arm64_ventura:  "359cb48e91bd19be157269c96b4c1119090f433c0d81cea7b155fd8fbde3a971"
    sha256 cellar: :any,                 arm64_monterey: "9d5d4b94ed3ce7bb4a23e325fb4e0e8df36bfe3aaabedcd92698a2062a8bd8d6"
    sha256 cellar: :any,                 arm64_big_sur:  "28bd3e85ccdaa3f166deb4c25bd739da3a1fec2c8903be32d227807ca3d8bb6b"
    sha256 cellar: :any,                 sonoma:         "c20ce159917ad7f157f07b4eb429b1ea567f25913c96feaa74a8375133e331b0"
    sha256 cellar: :any,                 ventura:        "f47a53b8078279c473e373c0dba5e56216ae02edbda96269c0937dd99f8b4cba"
    sha256 cellar: :any,                 monterey:       "6166787e64fdad5bda93eaeec70940698735c45e80bfae26e7e601fbda1dbc55"
    sha256 cellar: :any,                 big_sur:        "003f5a6d68d740b4e598f015c5cc997292c9fbe1e828f9b68ee87555cd5d1941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbe26913d0978cbdafd231d595a36abf6d6a542a794afe3b4484109b4c07768a"
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

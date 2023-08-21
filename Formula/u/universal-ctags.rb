class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230820.0.tar.gz"
  version "p6.0.20230820.0"
  sha256 "33a81a635635d7bb49e44c9f8ac85da63e0417d612d8b196b3099e04a5bbbfdf"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e0c679a0179f60578dd8b7248fd5e733fbd3d61257ec3e9e5d6387c9407113c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d67adb0a6b9c9a8ad0075557ea862ff8d98ff246104e99f6510aaeb6d45e86ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "019ae43cc8afda9e3558131bfb0341c958e171c0b1580dbec20b99383b965fc0"
    sha256 cellar: :any_skip_relocation, ventura:        "3bd8f9594d99297147d360b404fd77335c039e205d90dc1cc54114de8ca23350"
    sha256 cellar: :any_skip_relocation, monterey:       "d054eb8b63e8f2c3f2c07f8ef21ea146229d547ec0ecdb7396a16877bba61091"
    sha256 cellar: :any_skip_relocation, big_sur:        "1683e1c0499625a934185fd5bd4b1621e9a2a5ea4cddd74043663eb22e898f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec9f878d44007919d1f0d05d38c96311a8100fb0be38683966b8f2100e04d132"
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

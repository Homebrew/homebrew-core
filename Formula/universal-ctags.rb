class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20210815.0.tar.gz"
  version "p5.9.20210815.0"
  sha256 "a56de2c39090bbe1baa1fc7fcdb50834503f8b2b02edf304d7ab61c76ad82c0d"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "bbe9c4f677f77eefb187e8b9c601d7bec4810482f4046a9243aad5224b1c4203"
    sha256 cellar: :any,                 big_sur:       "6a433837d045dffe726fd73152ccb775d5b959ac51bb1f9d970fbf510a9df825"
    sha256 cellar: :any,                 catalina:      "b55d8aec84f3369f97261c14b9cff4126276f156c4e38c80964b6315f18f39fc"
    sha256 cellar: :any,                 mojave:        "723c6ee51729649f5d84ba90d26b07f582c81a02bba7287b2d3b08b1db6fb663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5bc0456fe258f2f84b861ee35db498025a92c2d706b616c0856e2e829c578f6"
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

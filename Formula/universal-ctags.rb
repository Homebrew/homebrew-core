class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20221002.0.tar.gz"
  version "p5.9.20221002.0"
  sha256 "d2b2b382f8035d4bdfb73a2f6995e85c744bc8121135e0f77060d2429ec459bd"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5e81d5714ef18a0936c120e3b8015013bda38562f35d4a577a5da05b240d8dea"
    sha256 cellar: :any,                 arm64_big_sur:  "9ccd50b05c4520fea9bd766cdfe92a2a312f544bd210aa820bb74152d5a04197"
    sha256 cellar: :any,                 monterey:       "69779d376892a3882b7c026b96d8682e594038fcdfadae9207f2cd399a489742"
    sha256 cellar: :any,                 big_sur:        "98174569f9b5bab9b4cc255381db4823afb2da1edb2999fd754636a2620c126f"
    sha256 cellar: :any,                 catalina:       "90ee793b0befd5a458b37a83687644136e83b33f039bad877acdc1bd818b6265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "898f3acc19598faa8afc6d0a55b7678bfe75db06d92fcad2276b7d7770254008"
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

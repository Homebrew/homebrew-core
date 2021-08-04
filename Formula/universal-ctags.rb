class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20210801.0.tar.gz"
  version "p5.9.20210801.0"
  sha256 "779248492b86bb8bfaf0b12f4e53c5032e9324f70542378c8863ef5bac2770bf"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8934978ea59ec3d66c5aa1da60184f79320a078f6150a5dbe429b14595368612"
    sha256 cellar: :any,                 big_sur:       "6cb65c4857f709c6cc0e9cfb4dfe7b13c1bf360f1413a18967b88d47914ab506"
    sha256 cellar: :any,                 catalina:      "74f315678cf5c7b79548c4aa66b444b9f051f0045bbb0aa6cb247e9021fe97f8"
    sha256 cellar: :any,                 mojave:        "f9821197853cc7fc8b7f80bec992124e3a3f2b033735942e0590eaf3b9c44421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b17e03083ff3bfb1ce6150bbe2e90d16c20eb976e37e2427884362da8c6e348b"
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

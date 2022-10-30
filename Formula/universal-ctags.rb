class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20221030.0.tar.gz"
  version "p5.9.20221030.0"
  sha256 "e990b78720bd2ae2e6a068d3c63fc3fbb6b7af2bb16fec13805649e2a16e65df"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1a84a536332e5df0f7fdd082618cb302e23544384f30985939cedfa15350f887"
    sha256 cellar: :any,                 arm64_big_sur:  "ab6aab4e154e0b107c1008053c0eab955f7a5ec60af0a272d707f24ac9668e48"
    sha256 cellar: :any,                 monterey:       "6c70a3afc579a92c33eba57063700fb1fedfef86de5f0f0ef4f5f924a722c774"
    sha256 cellar: :any,                 big_sur:        "f9bef79dea79ef29ebf8dda18ed0420afdd624b1ceb52bc813d6d9b0d6500615"
    sha256 cellar: :any,                 catalina:       "aad4807c2b19df52aead2ec8523b679453909c356c298322636db9ab3015d2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "062741c7215c075217439a95a28a9d8ab76c3c0379016048134c527db52311b8"
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

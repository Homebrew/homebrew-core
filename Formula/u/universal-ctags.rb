class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20231231.0.tar.gz"
  version "p6.1.20231231.0"
  sha256 "5bd434f6e6c023d01eab911580331ac58e516d4afee8c78beb3ce2c2cb590291"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4785c18d5287287132f8f329f727451cafb9e69f5602c4614aa8882b090cd9b3"
    sha256 cellar: :any,                 arm64_ventura:  "3f1036827edb559c3aaa0ad23183f676d4e1187447a6bbb3d8c60e4639ca1714"
    sha256 cellar: :any,                 arm64_monterey: "0a3675574f442339e40712ebcb0e391a614ccfb8fb1faf547ee88fbab631ee81"
    sha256 cellar: :any,                 sonoma:         "fcad42835aaeafc51ee2cd82ac41d66cd426071b0623c09fa8010cca019807b5"
    sha256 cellar: :any,                 ventura:        "af38797c390f7b922681438c45339650df423875a481af729928df6851ab70de"
    sha256 cellar: :any,                 monterey:       "04fe9d580008b10c683c9ff3be9b4ed068b4be93fc47060ba2c4a7273bc3bed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c32fa6ca6fd8b368f5275b69456c38cdd2978ad53ee0be566920f7547e8261ca"
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

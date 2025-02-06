class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20250202.0.tar.gz"
  version "p6.1.20250202.0"
  sha256 "d77696ecc35a7a11a7618656a21818ab8f36f7dd9818b816de70a76a9d04e97c"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a504e860e422db8bed033cdd30d0a8202ae35b004273dd510b2758f0a65c3b45"
    sha256 cellar: :any,                 arm64_sonoma:  "3a0b433fce06547869f4f1889fb542514716369de6f0fe8574d2f3f90979b159"
    sha256 cellar: :any,                 arm64_ventura: "d8cc419a34fb6bc80ca0c5bfd40958d38060dd8a2e5692e50d8feeb4b591388a"
    sha256 cellar: :any,                 sonoma:        "a609a0270cbef8782263c37b2c74942e8f3906381d7342972bdd6769eb409fd8"
    sha256 cellar: :any,                 ventura:       "e9cb218ff4f3d3ddb53405399185e6611a3255bac7f7fa8d9c308ef872732150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "030897e83fb443dd3c8f9ce94b850c3f99498a779c497a9fbf390d1738d8fdcf"
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

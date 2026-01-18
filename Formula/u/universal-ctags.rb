class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20260111.0.tar.gz"
  version "p6.2.20260111.0"
  sha256 "e8600e18671729140a798efd433e717e4e01efc92b13eedb16ab3562bfc80e20"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9abe44d37612d68a7fd79cad40ccdebe62101ff4d1c55e675965dfd39bf51aa1"
    sha256 cellar: :any,                 arm64_sequoia: "92d168d3dca8b69bfe41e3fe08a8b33f57e64064f2dc0c49081208512e296b8d"
    sha256 cellar: :any,                 arm64_sonoma:  "2c541c94dedc056cf898066e72e8e5472b3ae3d14715498b2d5ff0e3b8f43bd8"
    sha256 cellar: :any,                 sonoma:        "7882edbbc9593c878ed5717f6b8033a41b24317974ccf00acff8a7bb54d61cf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb69b792eb6d47707a3bd15218068c6d83f24aa13bbc8ff6f7c4600398ceac95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0834110ce5db721e4ea1095ddc3ca56e2b0927b903c2665e86cb1e12f9a6f9b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "both install `ctags` binaries"

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

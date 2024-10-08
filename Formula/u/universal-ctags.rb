class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20241006.0.tar.gz"
  version "p6.1.20241006.0"
  sha256 "4da5cca1db22ddfaad3ed4b819a2bce2c6f2369572ee05d7ad8f98cfef15c264"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9668057502f887d6f3c36de59db60f9572ccd7fe5d6eb9108822af93cf7a7cb"
    sha256 cellar: :any,                 arm64_sonoma:  "2304b9fb2167146b9fec012e9cd04429212beba7cffcf48e1a8f6f0f31af0fb0"
    sha256 cellar: :any,                 arm64_ventura: "fce12fb1b1172420cb5cf3af62313077aa03a3d6c8bc4d67b1b85ba0ce1284e8"
    sha256 cellar: :any,                 sonoma:        "5df30f9640c422c120181deebeeee46cebf88e9c721c4d2b6aac10e9f25307dc"
    sha256 cellar: :any,                 ventura:       "61f8155f60ae61feb11013fddfa0ee4259e9ecd8020f3258347ee3e2c911331b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69df65261aa3823175119a2b784b8fdb46e9e18af6b8cac3c2f6d431c60c9b44"
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

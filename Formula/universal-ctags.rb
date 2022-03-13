class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220313.0.tar.gz"
  version "p5.9.20220313.0"
  sha256 "bd37cef4e072405ca690e0aba650782503953d112c082e0cda43c76ad432d008"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f24e0f691931b798652b26b8e4d75c3b0d0b51caf5a21d35e76a5ec171e1f4da"
    sha256 cellar: :any,                 arm64_big_sur:  "fbfec3cabc566b81536ac17dab1386e90a0ecbb89bb52ca01c01247d55829287"
    sha256 cellar: :any,                 monterey:       "b2026a21180485cb966fc673a50d769081b093f29c92a3e0128d9b0886ed6e8b"
    sha256 cellar: :any,                 big_sur:        "a456403e86fbf9200c8d1921d788478e107f0dd6fc63c19537c0cb3aeca356e0"
    sha256 cellar: :any,                 catalina:       "222bc82156d6d713cfa1ab38f67afd3e897c062ef237ac27dfdcbcef2f4a5541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a2b8638673870207ade74a60e39d700d4da203174afdbfb9136a43437d2de11"
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

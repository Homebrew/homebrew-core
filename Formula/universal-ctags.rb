class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20211226.0.tar.gz"
  version "p5.9.20211226.0"
  sha256 "0942ff7090de8c8c87f85af10583c716136a6660cdeeb815addf2049812ef1cc"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2bc993889b4d16551a966023f493052a8507495fd8c866be3a6aaa141aecb4f7"
    sha256 cellar: :any,                 arm64_big_sur:  "2ed96204c2193dca17911d93ca5dec2b4beacff0276b99c89b4d9420877cd1fb"
    sha256 cellar: :any,                 monterey:       "dc4ffa41339742423a85998ba0d0593d3ab2e0762eb8a2f8d572a8b7ae7e0db2"
    sha256 cellar: :any,                 big_sur:        "95a490f20ddc52ee444d381b5b6c0adb2e01032d24650cf7d2c975da40a5bee8"
    sha256 cellar: :any,                 catalina:       "7ec7b47aecd16235be2c3ff8e37a308965375e6e9e102e9d54dccfc06dedf858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f69fdc9b47f0cba9b5e097f8894315ca3ddc1c8bbfe8325218ce4c7e74a74b9"
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

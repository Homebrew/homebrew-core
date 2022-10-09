class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20221009.0.tar.gz"
  version "p5.9.20221009.0"
  sha256 "58a584cc06a8e347d6c6efc049a78936c7bff1d98cc897f48d27fc3441f293b0"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1f64e5af447ab5abb46d2c2fd09656b8a67438e4317d8aa96b413949b285f62c"
    sha256 cellar: :any,                 arm64_big_sur:  "e221b3aceaf7f102cfaee855e8e48704c9f0d9d2fbf77cb6ad0e6ddb5c9a0a97"
    sha256 cellar: :any,                 monterey:       "c73ee3eb9c98083c09967aa1e82e1ce785ed1400252ab4e54dbcd7ebed544890"
    sha256 cellar: :any,                 big_sur:        "9d1c6b6fd88274b3303ef29e9c4a0c207540865f496dcf4fc0aadccb3825cf6b"
    sha256 cellar: :any,                 catalina:       "c416719292620496e1bddcaa74e165b79f696162d99d12a24b9f2d2e134524dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da0e00bdd8994fa8e85b9be1656ef60a1b43d2dde3c4b801ef6fa48f8923fd0a"
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

class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20210627.0.tar.gz"
  version "p5.9.20210627.0"
  sha256 "a1ac355f4f5d88a58f54bb01298dabdbba0432e0d898df0c71a407ca3a4b65fd"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5632da55343589f261b5bd82581009a54d5a8e53a44c689f1a02f87a3c2251be"
    sha256 cellar: :any, big_sur:       "7b1c55a1b6c7d08c0b965f3c87d12027e8bfb1905f18f3e00ceb53c025cabef6"
    sha256 cellar: :any, catalina:      "b377c06540006c2abea0cea609adee1c5208ec9df29261e910d93ef2707346c6"
    sha256 cellar: :any, mojave:        "8f96d9c527d3a76afae3c08f7da8fb30e7daea27789b270827af0e96f98cd955"
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

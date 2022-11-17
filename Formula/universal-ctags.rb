class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20221113.0.tar.gz"
  version "p5.9.20221113.0"
  sha256 "e9fee42581b7785d54dc631b1aa66b31190d1450199e0119b9e0a74a45da3af6"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "33d6d051f547cabbc7907355761f184fbf75967ad3d2cbc9fafa148ee1c0a3c2"
    sha256 cellar: :any,                 arm64_monterey: "a3ae4c5f2dda33f71f31214c68d1fad19b9d978c97b650f52a8c3a1c693138e5"
    sha256 cellar: :any,                 arm64_big_sur:  "86a8a21b021f000c2af90ee2470520d45329e7ba0fd55351bec9f1975768df7d"
    sha256 cellar: :any,                 ventura:        "4f45ac9491bb420e4c179229c9f089a932f91b0d03e7521f4bfb950896c06d86"
    sha256 cellar: :any,                 monterey:       "b5ab038e369b1163d311f70633cc6136cae39fe06647778335fa987c26992501"
    sha256 cellar: :any,                 big_sur:        "6538618b44def49d69f1d7244638de01fd62991487890d42d9588df919b38438"
    sha256 cellar: :any,                 catalina:       "3b573c377362b131e66c1a421ff6a45514340a35afb56ba5f4f31970273c4624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29fc64b636670ba932c89e5d9177a139f16f46cd0924199f67ff8a28322aee55"
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

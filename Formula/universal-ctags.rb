class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230212.0.tar.gz"
  version "p6.0.20230212.0"
  sha256 "162d6537564dbd6ca900d4dbd83aedc7d3d2f58d52cd0e16b3e554338803081b"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2b7f081026c67296033f5a45af5c88bd476c0816e2e73ca244093a0e186038d4"
    sha256 cellar: :any,                 arm64_monterey: "948900c8a32db2a17dd0f28bcec16e10dd024c3a86b6b434f3fd4e44540c3d05"
    sha256 cellar: :any,                 arm64_big_sur:  "3c8c145b663fba138dccc55afb4a9993db13267a96f70622702c7eedc8856704"
    sha256 cellar: :any,                 ventura:        "ac04c556828a27bc866cb311881af0bf36c7b2550e4993788b5a164eaeb131aa"
    sha256 cellar: :any,                 monterey:       "9be4b4c83a56cc9069d450856d2f6ca731d97cf2abc0146680e42b74c3363080"
    sha256 cellar: :any,                 big_sur:        "b7064cb37bc567eccf9b354f0fee76d76ec235cca35937622a18bd1e421a9a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7dfe333441ef4e4d2d76a13e935296bd347e1d590bcdc093865e15b1024ef72"
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

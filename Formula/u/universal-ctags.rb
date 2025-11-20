class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20251116.0.tar.gz"
  version "p6.2.20251116.0"
  sha256 "0371fe5b3fb65c20e7d0a3d991df21fada00f76fd6b9278848473a5a1b87a2be"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d66726cf51b455b72e88fb49a07002a0fab42bca6f405cc1f9d82330b70a0847"
    sha256 cellar: :any,                 arm64_sequoia: "4d530ca4d70bd5e7285fadca16a8b6bb207b7b84feba66474dd9e9707c48d4a6"
    sha256 cellar: :any,                 arm64_sonoma:  "afc80589b7ad15915fb0c72ba2f22a1a851a3890438577b5621333b52eaabcf7"
    sha256 cellar: :any,                 sonoma:        "fa1bdf7b29104ee6bf452024ef73f145b05adb702a97beb6ded2dda2d360e68c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb24d5a035962a671956abbdd6a605390f483760b032f84f84b4ba91d340fb7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0da16033ac5324028c1df2045cc4d933cd283488e86731b8085d3992448fed4f"
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

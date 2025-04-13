class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20250406.0.tar.gz"
  version "p6.1.20250406.0"
  sha256 "daddca774d5869a5efd232a47bc5ed113d09efbe2e7f4630703e719b330a7302"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb3343753a722335f0a47873e62321a29b4f4598148a08e87f0721e42fe3c405"
    sha256 cellar: :any,                 arm64_sonoma:  "2a9338cd3085ca24872be6101b0f24b440dbc8a978964b6ef911d7ec70fdf3f3"
    sha256 cellar: :any,                 arm64_ventura: "9ff7777c3c8454d199d40fc8b9c653766c5f7f6bbac2bbf4b8623d4becc18754"
    sha256 cellar: :any,                 sonoma:        "2bbbb9c2d9d0a803ecf8d9af84274b90f4b0a5cbc27900035b09543be8168a9b"
    sha256 cellar: :any,                 ventura:       "0b1574ec207bb99896974350b2da44282fe6784279b3d81cc92550bccda3b21e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e684a6cc30f702f97125a47875e712d2ba7a5948b28739e32a3b5fa6f658da0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b211b8eb45e060ff5ffea8e35a18f2c09bdeca05239e02d5a42a1705f124a96d"
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

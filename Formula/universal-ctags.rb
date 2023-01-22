class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230122.0.tar.gz"
  version "p6.0.20230122.0"
  sha256 "649582b13abbea06d779b6031f2f9206d79290005fd5ccded50cbff503831dc1"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "03ba7185118fb36c3e406ecb85f318614440f8fd2beca2a2fcb92bfcf7675a0c"
    sha256 cellar: :any,                 arm64_monterey: "5cd19c298d7eb352835bbcefd3a5a8f8f2713344f82428714ab3255874e99963"
    sha256 cellar: :any,                 arm64_big_sur:  "2fcbf544491ff06b9a0a1ec93387ff8ab17fc1ba53e4e67fec59c76bcd4ee18b"
    sha256 cellar: :any,                 ventura:        "fed1ef74940c84e3abc6cfbf1b0eefd3ddad76d7ba4e58fbf7a1322c29c29e20"
    sha256 cellar: :any,                 monterey:       "f242ab5f3cae16510d2217648ba7621f0a71e7dcacb5a1ecce9d45016585c32e"
    sha256 cellar: :any,                 big_sur:        "8d19d7d9c5ea50737c054af42db27d783148a360de2d638185cac32ea64f9355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce71eebf8925fa311a29ddb5c43e794842596bcb7bb8579112ba496463179d4a"
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

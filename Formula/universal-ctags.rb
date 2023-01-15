class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.0.20230115.0.tar.gz"
  version "p6.0.20230115.0"
  sha256 "3164d8fbb0194663720962f65669d5cf2a3d9bbea554b68c803d35374f6c9744"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5513e8d0977ac80a8e693744e4aa65c78144999eb5e29b67ca358777a8060c8d"
    sha256 cellar: :any,                 arm64_monterey: "63994a17c6c57e09078413f20f432ee02aee5da726daa1b24a236510a397f21d"
    sha256 cellar: :any,                 arm64_big_sur:  "e5387b168890c89dafa5a6e9ad97dcf074bffb8e9753376ee09ed5537805f7cc"
    sha256 cellar: :any,                 ventura:        "e828efcd12f4787771d0b3f97087ace9429cf0377558607c3b1971576c4e20a4"
    sha256 cellar: :any,                 monterey:       "1c97e6b74f3740723ddfb7f675ae28a4693249d8dd1fd6eeb423a0a674f3eb02"
    sha256 cellar: :any,                 big_sur:        "a02f9fb8f3b78c766b4323a6a7f58dc2a6d726e45f04a261c08c304d268773c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83316805d331ce6650ef0d88f4f011c8f983c06323523755ec7f7330c809890b"
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

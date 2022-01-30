class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220130.0.tar.gz"
  version "p5.9.20220130.0"
  sha256 "b793d4e430af19fd94bcb1cd6a24fb94e5f0a1151ef0e936f4e446384dcf96c8"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "064f893a89061ffb6ca0f004fbb451e90c4e1c359867a07f2e8510c1ad1d1221"
    sha256 cellar: :any,                 arm64_big_sur:  "851e53db4bfedfb3a80b939e809460680c49b3eb84a839d70b63b68361fd03b3"
    sha256 cellar: :any,                 monterey:       "a9bda59646afd1f804bb189f2ba3800fac4880b04d5b80dfef80ad59e282e3dd"
    sha256 cellar: :any,                 big_sur:        "34b2954fabf8dc29f6a3d5b95ead375b9f6a51a43dad3d954024bf95a4e68a90"
    sha256 cellar: :any,                 catalina:       "6bb09422d90fc81f1e8bc82a995b578d46e94c3a374e28d7a3f68d133da3a35d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80156e52fd0deef0dc8428d42554724211e930d38899f110abda19e0a333f8b8"
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

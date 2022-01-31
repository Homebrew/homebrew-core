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
    sha256 cellar: :any,                 arm64_monterey: "3cc100d50f7d0099ef88ff28787fa33c0fac4d4df6264c76bff786d220ca5a47"
    sha256 cellar: :any,                 arm64_big_sur:  "d9eadd57b706eb0f80c2bbee560259e438d70f15780c37a4436752b5bab838fb"
    sha256 cellar: :any,                 monterey:       "562b67ba9ffb073e7b335039d19357fab2577ed6cb94b147ff2f0324d8255f2a"
    sha256 cellar: :any,                 big_sur:        "5068329f3023c9f0b602b74f9e563bbaf323e0c4f0687a718c4902d0e3fb0ae1"
    sha256 cellar: :any,                 catalina:       "249a69ff736b05d63dbd7e85efa4b3339123a1359768f7b7236edd9e09a3ff68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44bf37c638bd8503f68f9009c51ffda0902640340b40b1a29518906743ab81c1"
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

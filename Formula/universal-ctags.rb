class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20210905.0.tar.gz"
  version "p5.9.20210905.0"
  sha256 "7740209e10086c0fb7526d9474f446a3e4a5fe4321642119f3f50cf2b2fc49ea"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "139d85f4d8226890d0a59698bb7ac13c03932c40e420c37efb1453e310ce69d7"
    sha256 cellar: :any,                 big_sur:       "b285b8e52ea3d7bca4c6a76675974c220e61d530f0c405ec3d92d07fc40ac60c"
    sha256 cellar: :any,                 catalina:      "373ebe1fb5e4c96ce91986bc45f33569fa886bd96f5696ec18700b2263cb7e85"
    sha256 cellar: :any,                 mojave:        "36a849d245ea60af48e3cdd22e4b3c6f1f60f295cb87d58c558da4e460b7b47d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0542abd64df01b7a73eead13b2931607a40c7e9ec2d43e9e6fb076a594d32a9f"
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

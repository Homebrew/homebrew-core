class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20221023.0.tar.gz"
  version "p5.9.20221023.0"
  sha256 "48a83d013dfc9dd4103b91accc0bda3d5adf9805081d6450c5fbc6b9f71399e4"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "87fb2e5dbc635ed951d5833f956aacb9d3c528bf188556741397f19a9052d818"
    sha256 cellar: :any,                 arm64_big_sur:  "89e187617fe53c4c5b947eadd2dbafec97514ea9adc06d361f2800c28d2096ca"
    sha256 cellar: :any,                 monterey:       "c11df658c94be1cb3574df583146cab5de2b947dc5672f6376b05fe94d570ea5"
    sha256 cellar: :any,                 big_sur:        "966efc2b0c0c28b1f5ebf8e9930118f05691353b0b5880bb6ea9e0b1e23b50ee"
    sha256 cellar: :any,                 catalina:       "37663623e496ba678cd242cb88e473450ea3cc3fd3169a4ece0599c337a21cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9d017b02b66b99914cab1f905ef0c8bdff347eba65bcf798e9cfb8c7f508fb9"
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

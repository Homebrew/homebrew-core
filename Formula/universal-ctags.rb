class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220102.0.tar.gz"
  version "p5.9.20220102.0"
  sha256 "0f795d1d38ac46de843c2b7297f1cfaca72014ba1d5b88d11bd578d869c475bb"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5ce63583f29c75f45bac3c12120647aac01b8dc78e7ce8655c614cbebacdc062"
    sha256 cellar: :any,                 arm64_big_sur:  "76382df52a45a9ac5e9c524d322d46b8e8725e5cf6e5e2e9acd5baef5bfc99de"
    sha256 cellar: :any,                 monterey:       "77242c09bf8837a8101be1764a6fb1c967526d2c94f148fa9fd205c465dd6f08"
    sha256 cellar: :any,                 big_sur:        "fea9d3b9907c9df9ba3aee705a05336a796ea16a3c8817febfec3d4fca17220b"
    sha256 cellar: :any,                 catalina:       "72bdb6e299ec4f4c8eb6014dafc80527d4627db989fce223445673cc62c42c00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63c5f93ddaaa7014a999b8a673cc192fb6dcda852ca1611a05cab42a6a879903"
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

class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.1.20240218.0.tar.gz"
  version "p6.1.20240218.0"
  sha256 "55654a2a6ff189d304673bbe536c5bbd93d0a46eec6583325bb55fb83d4bcbd9"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "98964cf05f2dc42b4e51271beb42728be14bbe4444005f85a3e039faaf0f96f8"
    sha256 cellar: :any,                 arm64_ventura:  "e084276e3681fd24299ae946747d853daf364b1f7fb1531d875fbacad8e8ff0c"
    sha256 cellar: :any,                 arm64_monterey: "60896d3c75db7b40d55c6aa69ca195a26487e2efb9ebe301fa19f7955837e09f"
    sha256 cellar: :any,                 sonoma:         "56abd5009341935807e6a0aee87c745dab1ebf36568d3dac924c951bdd1aac3b"
    sha256 cellar: :any,                 ventura:        "45c1654c9b6cf847b83735d9f3135e66b9bca5e9193b62faf394f949061df65c"
    sha256 cellar: :any,                 monterey:       "7590218ffd451697f4c42f7d5f9da1bd1207acf4c69974332730bc05a3d40652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0ccc65f47a44f29cc385274244d647b4936a6396f247eb0c83980d90a014a50"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
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

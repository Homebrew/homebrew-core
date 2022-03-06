class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220306.0.tar.gz"
  version "p5.9.20220306.0"
  sha256 "54a5d8b5ab986790b020b79b3bb5125f3dd262ca706566a232736eb8dea1c09d"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1575ec219857c69e183b8324c03854cabc6d000c7762decd4d29cdf427f6d60b"
    sha256 cellar: :any,                 arm64_big_sur:  "74f0ecae2da204650029b8de78a4505a29f9fbb1a610f2dfed3e30bef4887be9"
    sha256 cellar: :any,                 monterey:       "43406f1b3687a314de290303090363858325971c9a0cbd30b1279a93dbec4405"
    sha256 cellar: :any,                 big_sur:        "64ffe9def9096962882345217502daca626fa88bd8d9fb8e4445ef6da3fc4643"
    sha256 cellar: :any,                 catalina:       "5be098d5f889fe3223fde9fc69901d8d3831c2416c5e2f7269ccfe7c99783027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46c2f099c9ef28ed8a602b0c1805866275d5a69b780f0cd3f16a7a8375859cb2"
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

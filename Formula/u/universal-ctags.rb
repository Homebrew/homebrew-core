class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://ctags.io/"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p6.2.20251102.0.tar.gz"
  version "p6.2.20251102.0"
  sha256 "a920c411c2da33f7acfc0e53dbfe610080b78330114fbdd435856257a4234be0"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e7a11740fe250ea2d7976caf01a77b053ef119908b1f69e6660ab0e27bcd747"
    sha256 cellar: :any,                 arm64_sequoia: "4f1059e8be111dfc797b0cc30e1310032c4a11401b26498f46761827b5dad13c"
    sha256 cellar: :any,                 arm64_sonoma:  "75d5f8dac8ca4389c80398787df12e49be2a82d94dc7c3d766729553f3da14bf"
    sha256 cellar: :any,                 sonoma:        "4cb5b7c11a7e501dbe63e75680463b9eb8f2e1c3aec863492afe5fd31db7a666"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5765a37d86b1c4b714d5f97e29704634332397e05ac6797887b4bee0ba61f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28546b8f6d383806ab61f335e04cf55849b7636f349bc4c2a37b6b3b37fa8e48"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docutils" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "jansson"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  conflicts_with "ctags", because: "both install `ctags` binaries"

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

class UniversalCtags < Formula
  desc "Maintained ctags implementation"
  homepage "https://github.com/universal-ctags/ctags"
  url "https://github.com/universal-ctags/ctags/archive/refs/tags/p5.9.20220116.0.tar.gz"
  version "p5.9.20220116.0"
  sha256 "22166d076d7972ae1542b8bf8d834b26e47bd5e5c9ad9cb359fe6c8a58118989"
  license "GPL-2.0-only"
  head "https://github.com/universal-ctags/ctags.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(p\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "05293e072e6ca5876328d135c9e86cbf9efd2318b29eca5fe412bbbd589dcb07"
    sha256 cellar: :any,                 arm64_big_sur:  "45c31fc4ebe0c715f331d6595237355d60641229eb8fdaae2115ca02208b4a65"
    sha256 cellar: :any,                 monterey:       "2d74f0b3eb14a3127ed67921b76221978aaa9a95fedd67df623eb8034a027e9c"
    sha256 cellar: :any,                 big_sur:        "ff3376461f19be1c170d1f053c25c020cf569cd90fa75316ab96d93d4f540ff0"
    sha256 cellar: :any,                 catalina:       "9fa169ebc8684a6cd64c6b266126ff70e47ee158e183d885508875e057b84071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6f740d5361d717a887b727681ea3ba3a488f32585c167770abc9969da17a082"
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

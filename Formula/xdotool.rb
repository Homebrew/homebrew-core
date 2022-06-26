class Xdotool < Formula
  desc "Fake keyboard/mouse input and window management for X"
  homepage "https://www.semicomplete.com/projects/xdotool/"
  url "https://github.com/jordansissel/xdotool/releases/download/v3.20211022.1/xdotool-3.20211022.1.tar.gz"
  sha256 "96f0facfde6d78eacad35b91b0f46fecd0b35e474c03e00e30da3fdd345f9ada"
  license "BSD-3-Clause"
  head "https://github.com/jordansissel/xdotool.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2e59d046b4cb7d97f989a022c0775cbf3ab9f5929cd05650d50a9eed62b162c2"
    sha256 cellar: :any,                 arm64_big_sur:  "cdf3234a474044e88dcf18b5cb5e8da2c2af6da4d85eb04e8be737802baeae16"
    sha256 cellar: :any,                 monterey:       "ded3a6fc9f7ddc4e307a48744d2c25f2a60a752311628822c69d9f141d17ee34"
    sha256 cellar: :any,                 big_sur:        "f33aa5be05e49f700d166a13a36ecf5a1f8da3059e36f67e0cc9d7f26c3bf088"
    sha256 cellar: :any,                 catalina:       "21276c0386840d584e70f5425578b5184e56ef7649e6992f191a6c7a3cf8a30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffe41af3fe21135efdee19b3fabf9f459d850946dd592858a50b4cd46035f35e"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxkbcommon"
  depends_on "libxtst"

  # Disable clock_gettime() workaround since the real API is available on macOS >= 10.12
  # Note that the PR from this patch was actually closed originally because of problems
  # caused on pre-10.12 environments, but that is no longer a concern.
  patch do
    url "https://github.com/jordansissel/xdotool/commit/dffc9a1597bd96c522a2b71c20301f97c130b7a8.patch?full_index=1"
    sha256 "447fa42ec274eb7488bb4aeeccfaaba0df5ae747f1a7d818191698035169a5ef"
  end

  def install
    system "make", "PREFIX=#{prefix}", "INSTALLMAN=#{man}", "install"
  end

  def caveats
    <<~EOS
      You will probably want to enable XTEST in your X11 server now by running:
        defaults write org.x.X11 enable_test_extensions -boolean true

      For the source of this useful hint:
        https://stackoverflow.com/questions/1264210/does-mac-x11-have-the-xtest-extension
    EOS
  end

  test do
    system "#{bin}/xdotool", "--version"
  end
end

class Xdotool < Formula
  desc "Fake keyboard/mouse input and window management for X"
  homepage "https://www.semicomplete.com/projects/xdotool/"
  url "https://github.com/jordansissel/xdotool/releases/download/v3.20210903.1/xdotool-3.20210903.1.tar.gz"
  sha256 "9110198702d7549c4eccdab95f276d35a9fa9f540015d2739b62c55618d3b7b6"
  license "BSD-3-Clause"
  head "https://github.com/jordansissel/xdotool.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b5ce445e70ccf9a65310630aede622b216f8cb272b660e9420205b862e01fab7"
    sha256 cellar: :any,                 big_sur:       "f5210972a8352765068add40fd4c3fe77cf4a687cd3c81ddb719e24c739ffae2"
    sha256 cellar: :any,                 catalina:      "fe7c50b395ca8d9b196deb24046e2d433812478f247d44738396c2c2f3745f1a"
    sha256 cellar: :any,                 mojave:        "8d675d9a6391e70da34bcbea738af0a77b6a53a693fe8ed716f9ce6a4633aaff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec125dd2493d3956a23e574283fab5bc60195ef3defd54088fc002a795f1e45"
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

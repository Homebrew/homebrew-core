class Xdotool < Formula
  desc "Fake keyboard/mouse input and window management for X"
  homepage "https://www.semicomplete.com/projects/xdotool/"
  url "https://github.com/jordansissel/xdotool/releases/download/v3.20211022.1/xdotool-3.20211022.1.tar.gz"
  sha256 "96f0facfde6d78eacad35b91b0f46fecd0b35e474c03e00e30da3fdd345f9ada"
  license "BSD-3-Clause"
  head "https://github.com/jordansissel/xdotool.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "53cc99835729d36906840e2c26f1229415781d2cad0d3119982468af1251ceb3"
    sha256 cellar: :any,                 arm64_sonoma:  "51bfd88ef26a8667eafaa54e8f3069ef96c283b453bdced7bbbf2921e35d89cf"
    sha256 cellar: :any,                 arm64_ventura: "be8926b87350891af7a3434138a1971d988ab392f4ba73ec56565ac3a99184db"
    sha256 cellar: :any,                 sonoma:        "402a4980252ac8c70fbc2c50de00b1f094b70ba77922d9e2ac7a723e51882431"
    sha256 cellar: :any,                 ventura:       "fa28d8124531edd29ce76a708b4a73541a414129800321b21c5dd906d2a3dc27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3618c884a204cfc5cf79b020941d59cf0e1eb6dc6e34290fbdadfcdbee4b8f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e68d654dbff76e0681960e10fcc79139cbb39316d29bd5d920c95c6db9e89e3"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxi"
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
    # Work-around for build issue with Xcode 15.3
    ENV.append_to_cflags "-Wno-int-conversion" if DevelopmentTools.clang_build_version >= 1500

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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
    system bin/"xdotool", "--version"
  end
end

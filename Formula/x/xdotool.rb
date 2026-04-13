class Xdotool < Formula
  desc "Fake keyboard/mouse input and window management for X"
  homepage "https://www.semicomplete.com/projects/xdotool/"
  url "https://github.com/jordansissel/xdotool/archive/refs/tags/v4.20260303.1.tar.gz"
  sha256 "c1f971a384da588eb99ca0755fc4300316d49c1e612537e3f1de52215e104fa3"
  license "BSD-3-Clause"
  head "https://github.com/jordansissel/xdotool.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4dc22c5d97fd9b01c11953a9a784f41f4849c4e52e54fa9c816661cf9cb16ae5"
    sha256 cellar: :any,                 arm64_sequoia: "4b72c6fa194946413cfac5a743f148ba85c0be73709e9d41be584c682f27a9dd"
    sha256 cellar: :any,                 arm64_sonoma:  "0b27cc0c712adf4358f349aa4c0a5bca63e0bc11a967858cf7270d62bbf1c9b1"
    sha256 cellar: :any,                 sonoma:        "8526ca0cc8cf13ac5bfe8123e67b1123a4501d7f0c934a636aa1abfd8acd9a4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb904245e32922033e2c12cb49aed5b602e373ba684f5dfb44bc2b70f9f66814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3748e18cd55cf9d22483f03567a37b37b1ae94c7c98d326fe4fbfb738c274f2"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxi"
  depends_on "libxinerama"
  depends_on "libxkbcommon"
  depends_on "libxtst"

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
    system bin/"xdotool", "--version"
  end
end

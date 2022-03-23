class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.36/tio-1.36.tar.xz"
  sha256 "4a73ddfceed9851944e651e21a4f45a0526f15585a26420f2afef0283b7c477c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "63e7b8ea3e5a048c50a0f3ccd4f5f5fec3e1ac174befb5e1a19afabd150c4d8a"
    sha256 cellar: :any, arm64_big_sur:  "d576cc77b1c3d6f451ba75842771f7c3eed3d4889fb960d3c31fad240fb5c3e7"
    sha256 cellar: :any, monterey:       "009fd5020bbe6da3449f4dbb6ac29d5a15b931e0f5268d63b486f5e8c5b3b23d"
    sha256 cellar: :any, big_sur:        "42faad36a60b8f015a4bc9fa3a4f2c5106d637ec1ecdc9183f5e379f60e4d51a"
    sha256 cellar: :any, catalina:       "757a0846d04a608686bc87dcccd6c423519771bba4ab16b6b97ee6190e312630"
    sha256               x86_64_linux:   "2d6e3c212103f85599d3d8cb9b8f4821801eee737cf8b0bc5c8b387a1748800b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "inih"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    # Test that tio emits the correct error output when run with an argument that is not a tty.
    # Use `script` to run tio with its stdio attached to a PTY, otherwise it will complain about that instead.
    test_str = "Error: Not a tty device"
    on_macos do
      assert_match test_str, shell_output("script -q /dev/null #{bin}/tio /dev/null", 1).strip
    end
    on_linux do
      assert_match test_str, shell_output("script -q /dev/null -e -c \"#{bin}/tio /dev/null\"", 1).strip
    end
  end
end

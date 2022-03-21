class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.36/tio-1.36.tar.xz"
  sha256 "4a73ddfceed9851944e651e21a4f45a0526f15585a26420f2afef0283b7c477c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04047da7820a4df22bb71deee9da2e2f9b55195f6321505278c1e37d71c25424"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94faedc8fa192ecff1a76f19d178337ac04feffd1847a8fd183bb6218a2ec410"
    sha256 cellar: :any_skip_relocation, monterey:       "0338511323c35aa48d53230b699c0b87b7cebf3a0dfad4e877a7a9ddd3820b40"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2cf8a642d6cd6a8d24aa5c8067c07e3dcbdf0920222db1feb14c8ff8c2583f8"
    sha256 cellar: :any_skip_relocation, catalina:       "4b8f0ec39609e707a5b73a0b62e8a4ff350a92f6dffb7f7fa3b47d6008992f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a85eb4b9c70f7f6490d4bd4f8eb71fd3133f3dcda2df5d52384671e5ac8f0ceb"
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

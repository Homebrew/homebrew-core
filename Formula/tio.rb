class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.35/tio-1.35.tar.xz"
  sha256 "1309ecde7675f4e97cf363a8ab96ff668e14ab3f2176a15b6d626731251c9d09"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b3ab6cbc1c6ef8a13aa64e4adcfbf02d56451e3981dcb7cd4975286cc94f8e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "516b796261634baa606b8755b7be0b526bcfefae1b34533bc6827a7b1df0a368"
    sha256 cellar: :any_skip_relocation, monterey:       "904cf361a84d7f65822c7be564d1e11efb6c3b26d8d4324af94656a697f0f7e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "89bf7790e90ee884dc6801c819933e41321dc107559fe797382ff3fea4b29d5c"
    sha256 cellar: :any_skip_relocation, catalina:       "4eda9ec8d5786034668b555fceb015f4fcf6a7c21fdfa08e0ad2cd929c22040a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f526b06ccd39b370481f66f3397f6d9614506194a41c451d93fbde9d6421dde7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

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

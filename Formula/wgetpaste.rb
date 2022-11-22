class Wgetpaste < Formula
  desc "Automate pasting to a number of pastebin services"
  homepage "https://wgetpaste.zlin.dk/"
  url "https://github.com/zlin/wgetpaste/releases/download/2.33/wgetpaste-2.33.tar.xz"
  sha256 "e9359d84a3a63bbbd128621535c5302f2e3a85e23a52200e81e8fab9b77e971b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "19e1162aaba99186726c81d52e599888ad597e4d7ec889604dc6f86f3049ddd9"
  end

  depends_on "wget"

  def install
    bin.install "wgetpaste"
    zsh_completion.install "_wgetpaste"
  end

  test do
    system bin/"wgetpaste", "-S"
  end
end

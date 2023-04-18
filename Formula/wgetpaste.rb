class Wgetpaste < Formula
  desc "Automate pasting to a number of pastebin services"
  homepage "https://wgetpaste.zlin.dk/"
  url "https://github.com/zlin/wgetpaste/releases/download/2.33/wgetpaste-2.33.tar.xz"
  sha256 "e9359d84a3a63bbbd128621535c5302f2e3a85e23a52200e81e8fab9b77e971b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e28f46fd5ff5ace39fab378e3e156ada2996420f9db32e78c5679f5b461fee16"
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

class Wgetpaste < Formula
  desc "Automate pasting to a number of pastebin services"
  homepage "https://wgetpaste.zlin.dk/"
  url "https://github.com/zlin/wgetpaste/releases/download/2.32/wgetpaste-2.32.tar.xz"
  sha256 "621dbafbc7bcf5438f11447a325d8974069e3df03ef0c8bb2a2cc3de2c0cdb13"
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

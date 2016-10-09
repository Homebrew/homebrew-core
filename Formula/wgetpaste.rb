class Wgetpaste < Formula
  desc "Automate pasting to a number of pastebin services"
  homepage "http://wgetpaste.zlin.dk/"
  url "http://wgetpaste.zlin.dk/wgetpaste-2.28.tar.bz2"
  sha256 "538d38bab491544bdf6f05f7a38f83d4c3dfee77de7759cb6b9be1ebfdd609c2"

  bottle :unneeded

  depends_on "wget"

  def install
    bin.install "wgetpaste"
    zsh_completion.install "_wgetpaste"
  end

  test do
    system bin/"wgetpaste", "-S"
  end
end

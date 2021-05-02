class Wgetpaste < Formula
  desc "Automate pasting to a number of pastebin services"
  homepage "https://wgetpaste.zlin.dk/"
  url "https://wgetpaste.zlin.dk/wgetpaste-2.30.tar.bz2"
  sha256 "e3ec35f1ff49f2204864e3b4d784f6c032cdddb62cadf69263900c67a4896592"
  license "MIT"

  depends_on "wget"

  def install
    bin.install "wgetpaste"
    zsh_completion.install "_wgetpaste"
  end

  test do
    system bin/"wgetpaste", "-S"
  end
end

class Wgetpaste < Formula
  desc "Automate pasting to a number of pastebin services"
  homepage "https://wgetpaste.zlin.dk/"
  url "https://wgetpaste.zlin.dk/wgetpaste-2.29.tar.bz2"
  sha256 "42e42437f97376c9a2793839344205eff40c9f6b4a7d356e17fef83f72e7e0e6"

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

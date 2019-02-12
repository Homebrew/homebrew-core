class Showqr < Formula
  desc "Show QR code from any selected text on your Mac"
  homepage "https://ricsxn.github.io/ShowQR/"
  url "https://github.com/ricsxn/ShowQR/archive/1.3.1.tar.gz"
  sha256 "6eb4d14dca99b562d994ad8371ab7577443679e4ef8f54e8accaa946db5fd75f"
  depends_on "pipenv"
  depends_on "python@2"

  def install
    system "make", "install"
  end

  test do
    system "make", "test"
  end
end

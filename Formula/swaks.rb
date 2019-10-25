class Swaks < Formula
  desc "SMTP command-line test tool"
  homepage "https://www.jetmore.org/john/code/swaks/"
  url "https://www.jetmore.org/john/code/swaks/files/swaks-20190914.0.tar.gz"
  sha256 "5733a51a5c3f74f62274c17dc825f177c22ed52703c97c3b23a5354d7ec15c89"

  bottle :unneeded

  def install
    bin.install "swaks"
  end

  test do
    system "#{bin}/swaks", "--version"
  end
end

class Swaks < Formula
  desc "SMTP command-line test tool"
  homepage "https://www.jetmore.org/john/code/swaks/"
  url "https://www.jetmore.org/john/code/swaks/files/swaks-20170101.0.tar.gz"
  sha256 "84e62dd0de4a56d5daebe25afd16835bd8d3c7f39caa5e6bc7d86a056925915e"

  bottle :unneeded

  def install
    bin.install "swaks"
  end

  test do
    system "#{bin}/swaks", "--version"
  end
end

class Swaks < Formula
  desc "SMTP command-line test tool"
  homepage "https://www.jetmore.org/john/code/swaks/"
  url "https://www.jetmore.org/john/code/swaks/files/swaks-20181104.0.tar.gz"
  sha256 "023f7f8818ebcd638618327809cf1939c5ffcaf6c3d2572ef56179d68f683e58"

  bottle :unneeded

  def install
    bin.install "swaks"
  end

  test do
    system "#{bin}/swaks", "--version"
  end
end

class Swaks < Formula
  desc "SMTP command-line test tool"
  homepage "https://www.jetmore.org/john/code/swaks/"
  url "https://www.jetmore.org/john/code/swaks/files/swaks-20201010.0.tar.gz"
  sha256 "f6b1423e16ea4001f2b5666043921da020770de5e4cf3a2bc14315643a9be462"

  livecheck do
    url "https://www.jetmore.org/john/code/swaks/versions.html"
    regex(/href=.*?swaks[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle :unneeded

  def install
    bin.install "swaks"
  end

  test do
    system "#{bin}/swaks", "--version"
  end
end

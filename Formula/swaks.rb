class Swaks < Formula
  desc "SMTP command-line test tool"
  homepage "https://www.jetmore.org/john/code/swaks/"
  url "https://www.jetmore.org/john/code/swaks/files/swaks-20201014.0.tar.gz"
  sha256 "fb0a3b7d487a15b124ba6690f7b01a56617f1af2aa54233fd69013982de95a30"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.jetmore.org/john/code/swaks/versions.html"
    regex(/href=.*?swaks[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d4baaa4d56b279d495b708a878b6e41f25c6278a3d214be0736178ff0cc35104"
  end

  def install
    bin.install "swaks"
  end

  test do
    system "#{bin}/swaks", "--version"
  end
end

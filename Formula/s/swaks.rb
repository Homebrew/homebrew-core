class Swaks < Formula
  desc "SMTP command-line test tool"
  homepage "https://www.jetmore.org/john/code/swaks/"
  url "https://www.jetmore.org/john/code/swaks/files/swaks-20240103.0.tar.gz"
  sha256 "0e531b4d164058802e7266b14f4dc1897099d096f930820de2f9b5eb08dcdbe8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.jetmore.org/john/code/swaks/versions.html"
    regex(/href=.*?swaks[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c306783b36231b83d1c0935e526206911e61c3e1d58a011ea97b9132113e9f06"
  end

  def install
    bin.install "swaks"
  end

  test do
    system bin/"swaks", "--version"
  end
end

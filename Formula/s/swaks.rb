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

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4680f9c22f57ee86564e8a405ca115c2e1ab3aaa07453c7244479c7128e98c95"
  end

  def install
    bin.install "swaks"
  end

  test do
    system "#{bin}/swaks", "--version"
  end
end

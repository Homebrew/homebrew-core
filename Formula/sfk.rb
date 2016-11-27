class Sfk < Formula
  desc "Command Line Tools Collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.8.0/sfk-1.8.0.tar.gz"
  sha256 "933e0ce2b870a0d5ea2104064f664ada95a709e5685ba3c79d4b2a16ac65da4a"

  bottle do
    cellar :any_skip_relocation
    sha256 "485b91b860e40819398fd6cc8058bcc0b13f0280b365935c804bdcbaaa3b1791" => :sierra
    sha256 "9c9f7a323e1406b2ea7190d4f9dba91563e491f86dc4097c444cee2d6e822f7f" => :el_capitan
    sha256 "5876fa19b37c2bd4062837ee17e66eb516a6fc75b2fba476d5bd334932859c04" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    # permission issue fixed in version 1.8.1 (HEAD)
    chmod 0755, "install-sh"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end

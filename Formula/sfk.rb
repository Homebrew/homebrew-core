class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.7.0/sfk-1.9.7.tar.gz"
  version "1.9.7.0"
  sha256 "67009fd73d53c800302de58067dee2ceb64c5a43c10d32de30ab886efdd59399"

  bottle do
    cellar :any_skip_relocation
    sha256 "008d880b4b2a3d06e60fb28bc9950d2774de8e1430c99922779ea3f81b8b3fd9" => :catalina
    sha256 "b4e4dfaf137db0eb4f759e707be3be8e2f8cf3bba2c98452e53d16006a3de5ee" => :mojave
    sha256 "708df4b05628a36d80a818ad487cce07b2ff6de924b7106df7dd31877a7354f1" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end

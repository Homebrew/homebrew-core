class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.8.1.tar.gz"
  sha256 "95f43a18efbdfaa088acf0e2d6ce0fc4f4fc33a7486cd536d327a6ba71de30e7"
  license "Apache-2.0"
  head "https://github.com/shekyan/slowhttptest.git"

  bottle do
    cellar :any
    sha256 "579f26294a1ed9ddf40957b71df0c5663951229264e38d040d705aafdc202cee" => :catalina
    sha256 "8049b768fa761db677a06931d0ed19676be4783afa67950e498fa2136a175990" => :mojave
    sha256 "52b9a275cc949a58917c33aa839dbeb7f0c4b932e5b432ac1b3e05ed445141af" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/slowhttptest", "-u", "https://google.com",
                                  "-p", "1", "-r", "1", "-l", "1", "-i", "1"
  end
end

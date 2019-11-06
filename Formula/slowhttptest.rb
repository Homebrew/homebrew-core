class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.8.tar.gz"
  sha256 "31f7f1779c3d8e6f095ab19559ea515b5397b5c021573ade9cdba2ee31aaef11"
  head "https://github.com/shekyan/slowhttptest.git"

  bottle do
    cellar :any
    sha256 "ae6bf1d79b73492cf552f1c070f66c8589596ca68cb1dfd0fbacb1aec703d77a" => :catalina
    sha256 "f9911a5ba4c428db816eed4e97a15f5163fecbb018e66fa6c95f45a0f61e8db2" => :mojave
    sha256 "9df930c2bcfc3b447cfde2b4f106e6ecb2adb7ddc33c73b484f997395bdb45f0" => :high_sierra
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

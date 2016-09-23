class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.7.tar.gz"
  sha256 "9fd3ce4b0a7dda2e96210b1e438c0c8ec924a13e6699410ac8530224b29cfb8e"
  head "https://github.com/shekyan/slowhttptest.git"

  bottle do
    cellar :any
    sha256 "34cf5108ef284fcc23d91d0ee83358623935ffce718f0783912e7b5af05eab8e" => :el_capitan
    sha256 "bb7b09c1ac0489afab54737925d869bb67d2754bdec08969879be4d8ed2ee4aa" => :yosemite
    sha256 "45bad60bd26ee4d81a0888658bbc86890331b76a2e8fa071f63e4da8062599fe" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/slowhttptest", "-u", "https://google.com",
                                  "-p", "1", "-r", "1", "-l", "1", "-i", "1"
  end
end

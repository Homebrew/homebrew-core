class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.7.tar.gz"
  sha256 "9fd3ce4b0a7dda2e96210b1e438c0c8ec924a13e6699410ac8530224b29cfb8e"
  head "https://github.com/shekyan/slowhttptest.git"

  bottle do
    cellar :any
    sha256 "3843a8f52b50da1fe95a0772f260a904416ad4678fa03d4918f1bc0bbb18e990" => :mojave
    sha256 "8444fd4b1d9504ed908dc5049af4c3ed5f0a271db15d1de5f42b2413413d74bc" => :high_sierra
    sha256 "3d196594ae9da5c8852b2010d6c6e581896f973e06d7f5f2bd48a9ae36b63141" => :sierra
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

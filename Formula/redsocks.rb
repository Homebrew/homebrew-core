class Redsocks < Formula
  desc "Transparent socks redirector"
  homepage "http://darkk.net.ru/redsocks"
  url "https://github.com/darkk/redsocks/archive/release-0.4.tar.gz"
  sha256 "618cf9e8cd98082db31f4fde6450eace656fba8cd6b87aa4565512640d341045"
  revision 1

  bottle do
    cellar :any
    sha256 "ccfba64129d3e3a01b1bba7d18564e7b1ac174ce4b7a1c41424e2985d7a97523" => :sierra
    sha256 "5d9e3f0dcc812146c27c7916052605be3f08b4be45682ccda27a9ab0dc97f574" => :el_capitan
    sha256 "5d017a684dd4810da302823e4122ac8f43808a87c618fd24667b5b89d6b812b3" => :yosemite
  end

  depends_on "libevent"

  def install
    system "make"
    bin.install "redsocks"
  end
end

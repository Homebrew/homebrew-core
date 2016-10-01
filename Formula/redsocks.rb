class Redsocks < Formula
  desc "Transparent socks redirector"
  homepage "http://darkk.net.ru/redsocks"
  url "https://github.com/darkk/redsocks/archive/release-0.4.tar.gz"
  sha256 "618cf9e8cd98082db31f4fde6450eace656fba8cd6b87aa4565512640d341045"

  bottle do
    cellar :any
    sha256 "20fdde6819d44b7034a1af7ed8e30ba4ae42abfe5c70e8c067908de3c9bdcfed" => :sierra
    sha256 "ad3df81c5bd45efce293e229c77ff0687141646024a41a0c7cae3b3da34dcdcc" => :el_capitan
    sha256 "d59f7cd44ed44e76a1d03d83fdd7385330425d42913b4bab36e180c9b082d601" => :yosemite
    sha256 "a6b82407933ada8111fe21b0491b051aa05f31cdb769840f50e6af5cc4f2c96e" => :mavericks
  end

  depends_on "libevent"

  def install
    system "make"
    bin.install "redsocks"
  end
end

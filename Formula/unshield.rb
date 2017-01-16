class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.4.1.tar.gz"
  sha256 "f84c0f29028f7162fe6e97c2b1e7f2886eedbda76f94f357fa2ab0362ebfe635"
  head "https://github.com/twogood/unshield.git"

  bottle do
    sha256 "b3bfe30e3dc96edfcda3be347e9d3101d1de741c33b5d6ca2aafa07449d37d59" => :sierra
    sha256 "e4da5b388cc3133e231e8c34dcf244a2934b470fcd26123acb88e29b99400e19" => :el_capitan
    sha256 "64004268bba853ce5e89da772961757c8d57f40af6690dd997af5ca109670650" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"unshield", "-V"
  end
end

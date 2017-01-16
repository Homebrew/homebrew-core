class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.4.2.tar.gz"
  sha256 "5dd4ea0c7e97ad8e3677ff3a254b116df08a5d041c2df8859aad5c4f88d1f774"
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

class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.4.3.tar.gz"
  sha256 "aa8c978dc0eb1158d266eaddcd1852d6d71620ddfc82807fe4bf2e19022b7bab"
  revision 1
  head "https://github.com/twogood/unshield.git"

  bottle do
    sha256 "d64e0c93743d7d50858bd5c46c76b8fa79183b5ee4643361202f53378a88cc05" => :catalina
    sha256 "ec5db176e7f9557645cfdb63062802d37a8e516f39f1e53037e37ed398992b3b" => :mojave
    sha256 "c68a5391b55e5101979c69d174160564d88edc7263afa140fd69ce289c6662ed" => :high_sierra
    sha256 "96cc0aa68d191d1bc98d09a48abaa44b58b4e979bfcec3b2abc384c30d56684d" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"unshield", "-V"
  end
end

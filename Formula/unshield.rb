class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.4.1.tar.gz"
  sha256 "f84c0f29028f7162fe6e97c2b1e7f2886eedbda76f94f357fa2ab0362ebfe635"
  head "https://github.com/twogood/unshield.git"

  bottle do
    sha256 "e0ce716312845cd1598b853162d50bbb09db26c5b759ff98dba45a91d584a2b6" => :sierra
    sha256 "d8d77887ab6bdb1346eb3ff4049bfc0febc00c6b6acd9f868e86aef8b724c2a8" => :el_capitan
    sha256 "cfba17ecf917cf98f367c214134e5a38b461793a43951856ed9fd2b1ec7c2a83" => :yosemite
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

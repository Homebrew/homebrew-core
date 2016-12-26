class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.4.tar.gz"
  sha256 "8ae91961212193a7d3d7973c1c9464f3cd1967c179d6099feb1bb193912f8231"
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
    assert_match version.to_s, shell_output("#{bin}/unshield -V")
  end
end

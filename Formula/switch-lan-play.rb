class SwitchLanPlay < Formula
  desc "Make you and your friends play games like in a LAN"
  homepage "https://github.com/spacemeowx2/switch-lan-play"
  url "https://github.com/spacemeowx2/switch-lan-play/archive/v0.0.7.tar.gz"
  sha256 "0b645fa8bbff18b4b2d1dfd8d975790c6597bc0520c0ab1368387d08f8c2c900"

  bottle do
    cellar :any
    sha256 "378a55da07264e83e58925d3205a0cdb0916e2afd4e8b4c387dd46de3748a897" => :mojave
    sha256 "c4a6f2655ec51819c5ea197c3d30899e4c0208dd836e09c912e012dd275f8d2e" => :high_sierra
    sha256 "3f20bf2ec6ce400d56b4bcffe1c7a362ea50cb7ef9c2a55bffd04864254d071f" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libuv"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lan-play --version")
    assert_match "1.", shell_output("#{bin}/lan-play --list-if")
  end
end

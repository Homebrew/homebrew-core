class SwitchLanPlay < Formula
  desc "Make you and your friends play games like in a LAN"
  homepage "https://github.com/spacemeowx2/switch-lan-play"
  url "https://github.com/spacemeowx2/switch-lan-play/archive/v0.0.7.tar.gz"
  sha256 "0b645fa8bbff18b4b2d1dfd8d975790c6597bc0520c0ab1368387d08f8c2c900"

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

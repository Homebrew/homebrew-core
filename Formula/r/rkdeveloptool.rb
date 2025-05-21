class Rkdeveloptool < Formula
  desc "Tool for flashing and debugging Rockchip devices over USB"
  homepage "https://github.com/rockchip-linux/rkdeveloptool"
  url "https://github.com/rockchip-linux/rkdeveloptool/archive/304f073752fd25c854e1bcf05d8e7f925b1f4e14.tar.gz"
  version "1.32"
  sha256 "389ba41af6986c16f1eeebdc1febcb0bf4b8acb7abd694d3d652e78504215843"
  license "GPL-2.0-only"
  head "https://github.com/rockchip-linux/rkdeveloptool.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "rkdeveloptool"
  end

  test do
    assert_equal "rkdeveloptool ver 1.32", shell_output("#{bin}/rkdeveloptool -v").strip
  end
end

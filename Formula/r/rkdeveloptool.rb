class Rkdeveloptool < Formula
  desc "Tool for flashing and debugging Rockchip devices over USB"
  homepage "https://github.com/rockchip-linux/rkdeveloptool"
  # The commit hash corresponds to the version 1.32,
  # as unfortunately it has no tags and authors don't want to install them.
  # The commit hash is used to ensure reproducibility.
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
    system "./configure", *std_configure_args
    system "make"
    bin.install "rkdeveloptool"
  end

  # The test will check if the tool can be executed and
  # if it returns the expected error message when no devices are connected.
  # It will also check if the version is correctly displayed.
  test do
    assert_match "not found any devices!", shell_output("#{bin}/rkdeveloptool ld", 1)
    assert_match version.to_s, shell_output("#{bin}/rkdeveloptool -v")
  end
end

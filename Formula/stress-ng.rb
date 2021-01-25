class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.12.02.tar.xz"
  sha256 "f847be115f60d3ad7d37c806fd1bfb1412aa3c631fca581d6dc233322f50d6a5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "879f99e97af9b9f06b00d96d653ab685fa53e74f1f413eb2d22a3b6431f83297" => :big_sur
    sha256 "312a05b9ce3a3516ed3d0f74389e5903364a746d5ceb73aa01c40baef3727e2d" => :arm64_big_sur
    sha256 "3d7b6c7cef170967a0f7cb55ba1bd20f6fd39774442a27351cc6396969df663f" => :catalina
    sha256 "b0b3a384f412f4e34a32632b446eda2617f74214a85218dd059d0ab2de40c4cb" => :mojave
  end

  depends_on macos: :sierra

  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "/usr", prefix
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end

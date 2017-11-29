class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "http://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://github.com/ColinIanKing/stress-ng/archive/V0.09.04.tar.gz"
  sha256 "83bb1f11e66df753f16dd924c36fea9df20281ca85d49d07c15d970fe902baa4"

  def install
    system "make"
    bin.install "stress-ng"
  end

  test do
    system "#{bin}/stress-ng", "-c 1", "-t 1"
  end
end

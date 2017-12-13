class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "http://kernel.ubuntu.com/~cking/stress-ng/"
  url "http://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.09.06.tar.xz"
  sha256 "59c09c7cccb34222dc124ce8622a0ac73fe9391ba16a4a561267ca55c02f2520"

  def install
    system "make"
    bin.install "stress-ng"
  end

  test do
    system "#{bin}/stress-ng", "-c 1", "-t 1"
  end
end

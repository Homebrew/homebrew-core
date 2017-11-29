class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "http://kernel.ubuntu.com/~cking/stress-ng/"
  url "http://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.09.06.tar.xz"
  sha256 "59c09c7cccb34222dc124ce8622a0ac73fe9391ba16a4a561267ca55c02f2520"

  depends_on :macos => :sierra

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

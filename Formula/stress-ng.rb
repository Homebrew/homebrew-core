class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.14.tar.xz"
  sha256 "b21436fdbd9dc482a3fd95ae27cccf0097d0f226361ea3785215f7a4ad50136b"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a770ad23d8ea44676d36920a511707fc8a2696d978a8911370e1ef04ffdd7c25" => :catalina
    sha256 "880650bca21eefa4a8e903b9b1fc0ffc3454449ab5927e6993a430e950efafba" => :mojave
    sha256 "77f19860f13cc93aef0bc28471a402bf491e745b89285d8949eebf07d3498e85" => :high_sierra
  end

  depends_on :macos => :sierra

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

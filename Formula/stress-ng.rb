class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.00.tar.xz"
  sha256 "a41a6a4a7ea4e50aab7331e5594af7d1b3b6e5815751d137a78a6e166295294e"

  bottle do
    cellar :any_skip_relocation
    sha256 "901865f8c6e717a6c12868149d0ced06ed8112053ebf5c2ff6e57e5af116aae6" => :catalina
    sha256 "f43bf829019c40c326ae5c417adcd2f686748cdf018fe2df6958715332ae99a8" => :mojave
    sha256 "4ab0752bc4e68c923b03108eb35d6db68f3e357b5b465414d4cb979605dc3c89" => :high_sierra
  end

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

class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.02.tar.xz"
  sha256 "35eead6070401d725ce2c71fb3fe913860ee76454761eb6e851220097e570d80"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc432f05ed930464fcee30ed23ed3c3d70f2a1624ff464e59223720ff590fa77" => :mojave
    sha256 "039683ac6ce8a5cb515bf8dbc0100486d37f3ac6f9307a678619a58a2be5bee6" => :high_sierra
    sha256 "c49ab4a6899bc7531b970d3989ffc2edc148050961e1fc1b18c6773906186a65" => :sierra
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

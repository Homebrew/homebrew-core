class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "http://kernel.ubuntu.com/~cking/stress-ng/"
  url "http://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.09.14.tar.xz"
  sha256 "02cac34a5cb041197af60c1867844c6cbb089a6d10a38cdcf7b8f27bfaa6ef8f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5c642bf25ad5bac9c364a87015af26b7626b620f8901517c61a5917e59b2db3" => :high_sierra
    sha256 "9eeaf3c7a5c10809dadf29a73157ada42aef355f44b078e81dbe6f2f269371db" => :sierra
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

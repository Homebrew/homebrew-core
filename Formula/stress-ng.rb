class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.15.tar.xz"
  sha256 "1d0ca8a2f287e13c2d36c01e874d16d67bcb368d8d26563324c9aaf0ddb100c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "d21d756399b121a80c892c5206df690baf883535ef162b8e96d83b55f046d187" => :catalina
    sha256 "ecb9034b1dee524a05d8d98fdf1ae855ca2496281157787339ece6eb866afb00" => :mojave
    sha256 "90701c539a910d95c13dc419e2bcfbdd4ecdf1908cbce9cf41c11deb87923558" => :high_sierra
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

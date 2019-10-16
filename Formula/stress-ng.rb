class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.07.tar.xz"
  sha256 "85ae86587f605225cc736e1ddba6cc5fd129dfbba0f7d94df755e2e6ac5230e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "4aa3466269e15ba958968ea466fcf4799a2830184a177c7f01732026dfa9ffbb" => :catalina
    sha256 "1c23393a140dc53f06b0fadadb47e549bb384d852185f0926bb2a7c8e0a0bf62" => :mojave
    sha256 "a469a01408dfc811c782bad58a912e4d4674d5529a9ecc72fdfbde750fd02753" => :high_sierra
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

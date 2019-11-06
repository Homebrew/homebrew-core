class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.08.tar.xz"
  sha256 "4addeaabcfcb709581cbc4c61182317b8d91bcf31f529bfa899d170facfd75ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "06f283cbda55c309b5e3ca4a1aa9d1f2bb0a838db335b5663024e0b08db35f50" => :catalina
    sha256 "2ac616d46aa6e94d0c92b9788065b48883e59eaaaccc504bbab19745f6ba212d" => :mojave
    sha256 "09a4c542a341581d32c5e2a59cce9fa247a43aff6d6e88a6ac1d60bcf21adae1" => :high_sierra
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

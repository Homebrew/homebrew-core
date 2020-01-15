class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.16.tar.xz"
  sha256 "eabfffcffcf53e67765181280456c204ad00214339cfdb3ee2769d58b4a7e304"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fc32fc01bd6f0390da3ca0e0a42758856f00b660f16c68c2d54a95858b6cdcc" => :catalina
    sha256 "8bf4bdd2c12612fbdd8b30343a893946158e53928657ca6070b3eb54d974a3df" => :mojave
    sha256 "359be0c823d223a32519f3f42445acd252d43700eb7e54a62aa9fbcf648676f0" => :high_sierra
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

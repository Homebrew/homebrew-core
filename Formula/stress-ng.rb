class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.07.tar.xz"
  sha256 "85ae86587f605225cc736e1ddba6cc5fd129dfbba0f7d94df755e2e6ac5230e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0053cbd350e01133d5e21a01cf12f3e497a47b58f3bfcf1c0e450f246e31e7d" => :catalina
    sha256 "54aec853bd28c448dc5f8e7716738511eec68be3cc1f56c3512defbafd9499bf" => :mojave
    sha256 "a15489e47c388a27ef9f3fe8015992f51aa4785562fcec7a8d374cbcd0ac4f29" => :high_sierra
    sha256 "de809c73d89811f7a2f777865d8c4b918545bf824a18b6e387bfc2249f2dae44" => :sierra
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

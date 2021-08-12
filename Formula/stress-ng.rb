class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.13.00.tar.xz"
  sha256 "1cefe4a3057c1522b146e62f61b80ce6e2e99da2d85ebe25bc03fc45228e58cd"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84e99dd2e6a804212a693a0f7cdfb0bab75dea066fdd25dd6fbe636ca9f7b48f"
    sha256 cellar: :any_skip_relocation, big_sur:       "00601ac528531438395e3eb8b5d2826d9d7e9c659fbc268278f314d549fd4b7f"
    sha256 cellar: :any_skip_relocation, catalina:      "4b4b3f2a4824793759616af489196fc85f8f3af5d72dfd7fe4cee4c24b4083f6"
    sha256 cellar: :any_skip_relocation, mojave:        "8da4fe05d73115aa540fc332c40c2a4b086f4f4f67a603c23b6693572101d85b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee6cae0184b86b20a752fc89b51ee1f2c937fd5d43252725ec510218f37de9ff"
  end

  depends_on macos: :sierra

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

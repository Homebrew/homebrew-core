class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.12.07.tar.xz"
  sha256 "cf73e3a4c7d95afa46aa27fb9283a8a988f3971de4ce6ffe9f651ca341731ead"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3393fac681d3e207f3501d1bfe278ca88af1e96d911c82b55f226b8d567f8b73"
    sha256 cellar: :any_skip_relocation, big_sur:       "233ca336ef2f202b2da62c9f9e6999146d2b6bbadc35c8aedf2897cf957f4a7c"
    sha256 cellar: :any_skip_relocation, catalina:      "1fde6bc70377ee67de4bdc5655367577d5949996f53cb73a13da945a34c48885"
    sha256 cellar: :any_skip_relocation, mojave:        "f063261505af555fb22ab067ebb1bd47833a4a6decd641595918cfbb9fd18cfb"
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

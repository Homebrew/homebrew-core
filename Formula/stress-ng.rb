class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.12.12.tar.xz"
  sha256 "f27af50f6f2308e707fef927674bdd209a046b116734281b792aeca35a4e4499"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6cdc63e20568390e55b970875160606d904f44cb96560d6d1e124de35aaa07e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c61087c98b2ec616f686e45fe59d6d10d44b44ed35ea2819ffa47d5c1413c36"
    sha256 cellar: :any_skip_relocation, catalina:      "7ee83d56e587c1355ff25ca00b7f0aaf8c82aa7b14792e89c5dadae182198166"
    sha256 cellar: :any_skip_relocation, mojave:        "91b4092ccaeeb1c5d27dec03f23f64994dfd29afea7b96520bd6374b35b79f8e"
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

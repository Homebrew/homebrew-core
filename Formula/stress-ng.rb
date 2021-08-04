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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "887a059ac792b16b65e24481d476305173cbb5020b5ee12632b7bd336a0f6450"
    sha256 cellar: :any_skip_relocation, big_sur:       "f43d0d4e111ae2fc6ed724577d0cf1dac6a317077a7642e280489721b6bf826c"
    sha256 cellar: :any_skip_relocation, catalina:      "38467912fc8a91f31470bb98b77d87ccc415bbc5c7c858090a4d88e572723464"
    sha256 cellar: :any_skip_relocation, mojave:        "77f4ae0c4bdc843802c80055f4ea348a1d61220764f77903ed5d003a9908c6c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "920a12dd14a64304209f6586a48be874d50c4e9fad8e1efa8b113749e895a685"
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

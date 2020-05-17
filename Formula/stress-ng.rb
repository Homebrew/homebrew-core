class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.10.tar.xz"
  sha256 "110519ac10cc46cd99a29909543e74f6f58a95903bc8beae9d6553ca2dd48674"

  bottle do
    cellar :any_skip_relocation
    sha256 "98d93b44c1eb08ebe3a1c934185ca6fc67f038f7b12087c9879eefac39fbbb9d" => :catalina
    sha256 "0f3fc8656decc12bd0c7913ccdfa9e660d582246c8f6c50eaa956af9e5204a9c" => :mojave
    sha256 "0c024d58a41430fdc4141fa2ef1d2a3e1d31c9dec4714e58a13aa25d4dc1cc05" => :high_sierra
  end

  depends_on :macos => :sierra

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

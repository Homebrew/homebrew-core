class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "http://kernel.ubuntu.com/~cking/stress-ng/"
  url "http://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.09.07.tar.xz"
  sha256 "e4dc07e127e23de7c55f69687ef5f55ee718c386a45ba53f3560e01819a3205e"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c96e19eb4058c9d747491cf17c835535fd7b43576bbf193a3f9eff9c57dc4ee" => :high_sierra
    sha256 "c61f2abbeee7fcf2c3e41395b7a7af7c79788ab755659ed7fd673776f5256060" => :sierra
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

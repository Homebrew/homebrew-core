class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "http://kernel.ubuntu.com/~cking/stress-ng/"
  url "http://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.09.07.tar.xz"
  sha256 "e4dc07e127e23de7c55f69687ef5f55ee718c386a45ba53f3560e01819a3205e"

  bottle do
    cellar :any_skip_relocation
    sha256 "d12df90843e3e9280cea73363a34e2d1aa05e068cacaf6468b16496678509646" => :high_sierra
    sha256 "db2810739690804afa23f0df40233271352a792ffbdf0e4ead7f9be8ed636bf2" => :sierra
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

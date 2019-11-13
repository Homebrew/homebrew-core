class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.10.tar.xz"
  sha256 "031de5ebc44b49992c11633f10aae96da05a85b326aebdffd88ba8c445d23cf4"

  bottle do
    cellar :any_skip_relocation
    sha256 "80621905ab2acb16c64ca0a5e317c9f0318e359e8ef829cc1fbc828846f6dbd6" => :catalina
    sha256 "d74b340a03070a8d671ec68e6da62fbb9f6825dd00421abd47d29a8a1b5c36da" => :mojave
    sha256 "f180c3a0c6045a956e700a6498492c9a2dcfbd06eba6d1e721a1fec975fb9773" => :high_sierra
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

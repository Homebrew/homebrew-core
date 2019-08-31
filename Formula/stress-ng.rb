class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.02.tar.xz"
  sha256 "35eead6070401d725ce2c71fb3fe913860ee76454761eb6e851220097e570d80"

  bottle do
    cellar :any_skip_relocation
    sha256 "868d44fc214c55f6d8b08bd46549622af7e3fb894c6b5c69db10609f2b80a8b4" => :mojave
    sha256 "2761be83935dc3df6c8732ec4e06c36b13a702920816d51cc1aea9b879ae9260" => :high_sierra
    sha256 "cd8f7598b445aaac18f4aa9e15579ffc76105ab5f611660afa730077feea1d87" => :sierra
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

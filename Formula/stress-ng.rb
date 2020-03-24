class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.03.tar.xz"
  sha256 "3c6d0e8077f5d55251e247cc761eaec527413fba4aa89a02856b432dfb5e9443"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad7679daf420b96c50f4425fa0cf00843c4233744ba73467bab53d9d97224992" => :catalina
    sha256 "e74131e6074c707a6880431e30030fc460a8c4c220ba097105a661169f845ecb" => :mojave
    sha256 "10e4a812d0bcd08f57440b4ca1c127a4f45c5a15de3840cfde06f1a93c46c4e6" => :high_sierra
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

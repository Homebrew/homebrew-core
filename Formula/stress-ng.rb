class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.03.tar.xz"
  sha256 "3c6d0e8077f5d55251e247cc761eaec527413fba4aa89a02856b432dfb5e9443"

  bottle do
    cellar :any_skip_relocation
    sha256 "9de61e6f6de9f9d4d997ecd7af419c2843919b3af46c36db925c66dc7591a762" => :catalina
    sha256 "3969d73e13a8516f35cc3133a02ae65830c2bbaea16b85b78c18cf768c069d79" => :mojave
    sha256 "3dac7e4972c99d22e63756abb56bf72b0ee3f9914bce600e0ab9f57e800af5e4" => :high_sierra
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

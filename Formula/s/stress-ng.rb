class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.18.00.tar.gz"
  sha256 "9ee2fa2c2cd7732db3a600b77a75aef0d457008aa812e36adc7ebb029aeff6bc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40bc9e0ffd2c536774818c481570a837d97cfe90cc8d95ab198a1446752fe835"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7210582f57888cc340d5ccb384a7e636dafc7dd41ae8fbdc3cb50f2644d40f23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4385d6b40ebb342adb2d7b77ec50e2d9f27f930fa4e5dc35983ca6848544b541"
    sha256 cellar: :any_skip_relocation, sonoma:         "d99f6b6ec62ae6f8fa57becb8d77d84839a75ad873038973145194bf0e3b6406"
    sha256 cellar: :any_skip_relocation, ventura:        "9fb6904d46cda8e45d3dfb1d67ec0b6d8015f14dbdc8bb950e85d922299b2f21"
    sha256 cellar: :any_skip_relocation, monterey:       "ab14f4e42fd39f54e90348caa9d4ec8e8a9ce96926e466322406dc30402feb45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "065827b73917a2377f52a9eb9f17637a367e31657d1cb04655fbe133bdf6a165"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end

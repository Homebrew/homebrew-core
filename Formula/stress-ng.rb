class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.15.06.tar.gz"
  sha256 "c38cefcf0a83f6c65aed7c36e57a9a1ee8373418ef71cf089a75b0661dcd4623"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecbf94e82dbf2a28285d630dc8c36bc97a0da08cd1901f13795846f9dad9a894"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f6b35b15f88acc1bc2df4e08b90def52d5e7df73354d4c93c4663f887649f73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7c96188317e5d6abf81e7548b2755618bb9f0c663a5d6def8b01bba60ab88ff"
    sha256 cellar: :any_skip_relocation, ventura:        "a9ffa3058095a8e835dc7b3bb1b29da5f6e2cd6a11893e8f30445e69e13e9fff"
    sha256 cellar: :any_skip_relocation, monterey:       "86f420bd5912736c5897bbb3512043b970090d69616535350fcc569fdd3692ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "b527843c1fa1750fad8a971127157ccedd05b59527eed27d4e1ea9e40887ea9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a190d4203745ed0acf97ddb08b267b2574b4baafb55f109fc1fc0b86720ff8f0"
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

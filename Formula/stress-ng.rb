class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.15.02.tar.gz"
  sha256 "97021dc822f01758f050249f5d12ca49b9df282461c01414f630fa8ca1e915f8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34fb254ca79ff2d9dc6d398f87165409fa7bf05a0ae3bbd722c62f88427cc15e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cdb1a3f403d356f70dad581c0858a0fa7ebca073be1443dc9055605ed8dd1c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53149c9820459c5af1a237a8880ff5d40ec84f411afa502a68b5c1ef60306aeb"
    sha256 cellar: :any_skip_relocation, ventura:        "df68363c71ea60a996b9bbb8ccf4e2f22a30850307e02b40b3a31ef446e49f5e"
    sha256 cellar: :any_skip_relocation, monterey:       "42811eeb27a9f83065c54e0f29a77254e3e3673ab77a19a6a8ad1a38ae930e6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "837e4b001b87338b4178309b9d4a5fd4e0b44d1e0354c58d837e7cfddeac0755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fa55f4f5958ed9866cfd76f82aba02de4fe80c8ef833cdd08a35df8b52d8961"
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

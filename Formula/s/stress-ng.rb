class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.19.02.tar.gz"
  sha256 "15a07030a14bbfd5991e9ba3fbfbc24ed3ae72a2c946b033c06b820bc16f41c4"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80dd24c26a7174d3f36432b327ffe5a1ffba65ad2e7365b2866ab42ad300e54c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d33ca3d8759c2d3df691aea9d25d4fd0f2f982dcc3e20634ceefd963f43f56a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fce6eeab8b9f1ee6b4d66cfddbd0f4a4699f63401f8e95b47ad2f49d101949c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3ccc28a90b584e052e608091fcc931d77f2ed1ce8d6c714102b07ec0df96a83"
    sha256 cellar: :any_skip_relocation, ventura:       "f4e5d7cf6be62268b944d3440f7c3d9e8c28b27009d3640a6f4e804155f7d16d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faab8bf7e6eeaed7704bc978e93ee021d22430282b3d9ab0f5d693bc9186070e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93d8b924b6e176a5c22c72f7105cac3ca246824447f8e9a0937aaf270b4b12c0"
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

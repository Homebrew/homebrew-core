class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.14.06.tar.gz"
  sha256 "54f6c3f84b20efedafd3394ec168e53632a685cfdd76f24270653e898d9ede08"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "823e23ddc74a4fdfb8a0e63f17504d20cf0595487ff5e09b7cc27502941ba0d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fba4fc67d3934e0c77beb2a86b908f9c8072f319f603e472a0367f7cda0c8ed"
    sha256 cellar: :any_skip_relocation, monterey:       "39fc73ee02c34f01d147e2e5ca373e43b8841aeaab8aee6f5a3612090791c429"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cd5c7a2f88791a181875b74bbe50b59f08478e5add583ba37cb252aae9532dc"
    sha256 cellar: :any_skip_relocation, catalina:       "478371725f5eed896e1d5690887d4d318cef0bff5b01ebf63e30e29344bbcc59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0020774bb2edbd94ac20720106b45625c1e893e45de005d74d25cb3f3595542"
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

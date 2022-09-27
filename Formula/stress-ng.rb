class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.14.06.tar.gz"
  sha256 "54f6c3f84b20efedafd3394ec168e53632a685cfdd76f24270653e898d9ede08"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44400b7a983b62df04973d92c261b74795e554ad86749b830983e18d97f413d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9ab13708da22ddbe36344dfe91a81090c674c522f3cf4e5df36068a9eee808b"
    sha256 cellar: :any_skip_relocation, monterey:       "a18edcbf0eb0361a03f3bdf0eb9cec879abdcbd0bd1eec31bffbedd73056a669"
    sha256 cellar: :any_skip_relocation, big_sur:        "075d66725792ceff5da2c221fd66819b388d9da54d3b993bdf01a980d3068bdb"
    sha256 cellar: :any_skip_relocation, catalina:       "70b045f8083a8c680eca66337345934e6b32a3efd9c294b42f16b689ce0e136a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36b825d81bc3622d9840a3ac7e8d78d5095b949f8323b594e908f345863e7f99"
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

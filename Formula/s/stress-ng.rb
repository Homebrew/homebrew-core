class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.17.07.tar.gz"
  sha256 "b0bc1495adce6c7a1f82d53f363682b243d6d7e93a06be7f94c9559c0a311a6f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b3cc632e90f078c6e38317daaa57948562bf1291411c221f3f94061a112bcaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "243198acc306253387c1962ae81523189c7df4989f38a892ec2d404d43b1f078"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f92675649c979ee07074dca738bdf36a87dd1604ec9e0be70388d2ede6c43377"
    sha256 cellar: :any_skip_relocation, sonoma:         "31e24090f70ed6e2b7c4557595f584aef2110eb8101d501f1cd378934bf6f911"
    sha256 cellar: :any_skip_relocation, ventura:        "7595b7581923589520bbd3cb2bf58301f897ae30dd58f5a851ba7e0b2b10a235"
    sha256 cellar: :any_skip_relocation, monterey:       "e94c2d10b0aea8a7eca65acfeaab298f733b971b53f330cbcea734c051b5f340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdafc416d771655998809f0a951c0b600099e756e61995012ece6065469444b9"
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

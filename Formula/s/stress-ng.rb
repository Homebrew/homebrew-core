class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.16.04.tar.gz"
  sha256 "3453719508e9e02c57a736c154408538372d078be7dcf8e0165d37a821cdba45"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87249ae964c966f1d474762e2396c334b20065002033907710281dc9990ee256"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b11d7c0130d469d7173cbb85183d881a177cfee4d97bd6c92e80f628cf2bcf01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5515b7a3e3c34e68160b090ae933ebf72e01a484b9af00ad30ed34e8a421fae"
    sha256 cellar: :any_skip_relocation, ventura:        "9d538c68c7d81e6c2fbf4765ac1903e480a611e9fd189c0182689c9779fe323a"
    sha256 cellar: :any_skip_relocation, monterey:       "0feb16384dd72c29fc14e9e997ef914078c32fe8c38a7d1fe8e5ebbb0560d155"
    sha256 cellar: :any_skip_relocation, big_sur:        "036c06af1e06e3c6537813f86f4ce61b462dd5a044f8ce1345d920bb498d8e47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5631b004c69a9fccc525dcae178f7be79a055da6d89a269a59ffcb6e6920cb63"
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

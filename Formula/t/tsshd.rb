class Tsshd < Formula
  desc "UDP-based SSH server with roaming support"
  homepage "https://trzsz.github.io/tsshd"
  url "https://github.com/trzsz/tsshd/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "1d19f99a95f19933d8058df1209b421400eaca8c2bf2e045747c8f6c68887d56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f5be597f86f01b03876a95c9a3fb96225bfff5d3bee624b4e0d2ecda4df79a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f5be597f86f01b03876a95c9a3fb96225bfff5d3bee624b4e0d2ecda4df79a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f5be597f86f01b03876a95c9a3fb96225bfff5d3bee624b4e0d2ecda4df79a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca646b2423f59e9288f9218286c941f14462f2af80a11a8a25d7572a398040c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a5ebc66805178c28e62c2dd2fcf45c6b8c13d55d7cb09052d92d18b0b3e1964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0b89897053dac6610ad70656272742242c88d1851db6e5a69310ddba404f316"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tsshd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tsshd -v")

    assert_match "KCP", shell_output("#{bin}/tsshd --kcp")
    assert_match "TCP", shell_output("#{bin}/tsshd --tcp")
    assert_match "QUIC", shell_output("#{bin}/tsshd --mtu 1200")
  end
end

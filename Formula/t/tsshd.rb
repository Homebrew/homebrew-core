class Tsshd < Formula
  desc "UDP-based SSH server with roaming support"
  homepage "https://trzsz.github.io/tsshd"
  url "https://github.com/trzsz/tsshd/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "32b4026724acb076514fe00ab380ab8f3167af6ab3568787a6c4db57be0fced0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07588d25973700906e01641c9937f8d64cee275dfba9c24cbe4a410808125c0a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07588d25973700906e01641c9937f8d64cee275dfba9c24cbe4a410808125c0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07588d25973700906e01641c9937f8d64cee275dfba9c24cbe4a410808125c0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "267e7d703d641b39bf7c39696de06eca84a7ea3aa0bdb0c5263f7af87035fe97"
    sha256 cellar: :any,                 x86_64_linux:      "bfa9fce01c8c4140205da76bf82d7436198bcbbed55d0e92a4f0ba7cd03bb2d2"
  end

  depends_on "go" => :build

  # `test do` block binds a local port
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/tsshd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tsshd -v")

    assert_match "KCP", shell_output("#{bin}/tsshd --kcp")
    assert_match "TCP", shell_output("#{bin}/tsshd --tcp")
    assert_match "QUIC", shell_output("#{bin}/tsshd --mtu 1200")
  end
end

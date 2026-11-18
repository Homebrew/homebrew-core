class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.13.1.tar.gz"
  sha256 "53c1b7afa44f74490afbfd2b9493ad229889b710efeb7229d245d229f544c9fe"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14b412ade9daf73124d9fe52d509f3f8e0fc78d891cbf9c9a0f7b46f9eacf583"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c6f5e4f005b73e389a8bb5a295e85f69935f47ba452715d85e42b27e01280b39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2c98c05613bf3f5a5a84d3e9ed742830eadbdba230b3a8eab3c038584417443"
    sha256 cellar: :any,                 arm64_linux:       "8ac860801da76c08fb919bbbe143d5920d1aa11a8163d797e1612cb62d770c78"
    sha256 cellar: :any,                 x86_64_linux:      "c4f9d65af950aab32fb2ae6ac373f0f9e2f74c5b4d2e6c32526ea7d4a9c55c0f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end

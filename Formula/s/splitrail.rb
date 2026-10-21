class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "2fc82c7e44f60ad331b50a153366d8634ed63d982198657e33524b76c0513557"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "506162343f3bb5a315cb65fd6bb9840403ef20cb39b856e27e63ba8928760dba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a58dec00393e22997ac1b8375d470352f3813fe6d1255d098f94683aa4bde7bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a583a4eab88fcb013448e1b38a819ca5fa2236f78a9f3d559c4c206924d3c6b"
    sha256 cellar: :any,                 arm64_linux:       "8106d85af0bda911c8e954a52d2291ee91fa1f14c250c69c877536e21f2fc0fa"
    sha256 cellar: :any,                 x86_64_linux:      "ec5ecd0dd688872caab62eea16ffa9b592d7c574ea8a3c6f30b5181b69dc863a"
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

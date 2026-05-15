class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "90112634553659c4e422906a526b1ca9e8e1bddbfb8dbddff799041f71aef6b3"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "760e10847d3a9726acb9ce04b2da4b69570dccd06c35f937fdd12686e91a9eab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d67befa844d0b899a9aba665aed16b88ce93c65fdfdc2e3d220f99cdfe3ad6d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c8deed6525a644356724949c0bfd737d933d8d57b629d001971c782eef0857d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0207930b555eb691017cda11cf0040f96588f5985ce2acea7c773cbb76525fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3055fc762448b49feb87d04fa53e39cd727f0caabba93b7da73a8784b2ac061a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e9bf3349abf6d209f7fc4944426c6b99e23bcd4bb482ce758a9084c2176fef7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ralph-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ralph --version")

    system bin/"ralph", "init", "--backend", "claude"
    assert_path_exists testpath/"ralph.yml"
  end
end

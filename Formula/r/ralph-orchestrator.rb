class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "6ad8ec4669e94ccd59d8b329938725ca89c7ed0ae15eab28aba0b9eaad0d1671"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41cdcf516882387f7adb63aafe3071438f85c932f1980a067f931177cc53a0ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0b0a033f171d0160ac483db13ce112042b4a414ac930b432fdf483e1949fe6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "137704c7e6ed3db629aaace8c2b6adba1cb32ef61c5b38cafd3ff5c6191ba8f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc84035917820a7763f8c84a9f719f2bf2aa772b385f926318b3a61173ad5ae8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b0d0f550fbad09db09aab6946a3a90ccddb3dddc8b5bb0b109084c744f9c7a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0349a4756e795c1c7634d3ff796be52ab72b8342f8cf559c35d29aad66aa8be0"
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

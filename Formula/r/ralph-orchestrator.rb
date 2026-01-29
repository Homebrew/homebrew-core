class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "b0234452276a764c1601b237bb27d3b6205cbfa5fb8e727d616c8d6b52e9c59a"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d983ee40587e91b3be75b14871b450825d2d4468dace863af4f22c43a158b9c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26675beb05cb736d8132d6a5863eb425a4e9f71e9360dc1e8e949c6dac5cc84c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcdd245a175c214e6ae2f2f329b97addf22feb03711824fc0e22bf35168eb9ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "43ffea443ce5c867273c8ffe824c94303ae6f4eee1d61e5f5ef41d6edd4c2bcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f969ca7618ff76c9692a8e2797452edd64785d801a4d5cc848b831bc372b0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48ad7c83b185567eb96e03023742b86d2fbfd68afa12f210a6f858c4867090c8"
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

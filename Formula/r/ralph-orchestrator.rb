class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "fcf8c4f6e034c9a60353066cd45a3894218bcee78c015cf5f1caafe1e67d07cd"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "148422a64ab8350f53da9caa5d2531073871efbe241bfab44794e98995c8fdc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "460b867715b86a015936330179ade4277de366cfa3f8a00765802078a0a1e09d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca7b605b55c399dccc5282a362a284ea14ec6a19427c1fdf884897990c2eeb22"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4a2362ca5a82225b2e819f5c392b504dcd1fa1c43f66d7b0ce9db9a5d1e15cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02494fd12d19180b54590e208386a3ffe0bd8231917cc10a49eaf45995b05c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebb2c6129c4bdcaa694b9ab6d5a35d34db39e9a541c87f9e0f0c254e9caac7eb"
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

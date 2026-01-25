class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "d6d16ae936cd8490442b0c41526ef6ea0a70fd06fa62aa007a97ce6a94a7dcce"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6242a24b20a220a588579cf21cc8d3d34e8d6fe53caef247152613f7f234f6b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c111e3262074ad35c3304e15c040ec25fb6fe8213945012d7123856014e3861"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e4a2f10b511927e80b4e2459d533b9baae7de1c362e498d7af6eea9fed976a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "934e5bb8619b96e0d0b9e7dc17f305851c216d8795f4fd0db1fdb1cf18496c0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b96ce7311c6b7ccf007f0177aa0a0d8e73f647554caa5725b42eee8f70576821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf8544f4ee9aa742df4ca22df0bc8daa89bf06184697503fb0e164d874bb5758"
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

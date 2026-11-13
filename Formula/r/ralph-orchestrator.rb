class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "347eae359b3f9ba8cb177aa2b14a8c40f1781224b13b123c7b01d09493d32003"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e013558228c364931972e6ddebef6f65c0427081082ec7dde95dd17f3124e0e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e05566f71807db7c66eb6e252651383699183e806af7af703b5a1729bef5e258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd88cf67388c4cbf00ba1d9d6ec08c1b680b843a502155bcc3de123aa7f8dfc3"
    sha256 cellar: :any,                 arm64_linux:       "2d0ecbabf6392341b7aed7ef15ce424d201180ad0070b8437f41b26814cd81b1"
    sha256 cellar: :any,                 x86_64_linux:      "9f75e135a8ea7432f921e1dd5572b874916f0dbc66977c61b4d8392f26290042"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ralph-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ralph --version")

    system bin/"ralph", "init", "--backend", "claude"
    assert_path_exists testpath/"ralph.yml"
  end
end

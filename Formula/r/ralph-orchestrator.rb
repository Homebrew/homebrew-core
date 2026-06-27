class RalphOrchestrator < Formula
  desc "Multi-agent orchestration framework for autonomous AI task completion"
  homepage "https://github.com/mikeyobrien/ralph-orchestrator"
  url "https://github.com/mikeyobrien/ralph-orchestrator/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "10e7a99e87a30709a154bdb8ff3ea315164801e6d76e4fe90c4a4c34a02a9163"
  license "MIT"
  head "https://github.com/mikeyobrien/ralph-orchestrator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "107c3ce7ce402c38fbf40725985a4c87d0014d81eb0ba1e2165e537e049afef4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "117b7fff70a243cfd173c6eb81af3e36f9acea87bcc773542c9d118b13aa8cfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cdce3e76b8abe0cbf49a120364e4071bffb305c16dd96c836ee935e4113f320"
    sha256 cellar: :any_skip_relocation, sonoma:        "47ea5b183c8e3903fc97acfed356d66a58059d94a88a013b65bd72d5494c19dc"
    sha256 cellar: :any,                 arm64_linux:   "2b43f03210e1cd98b08b9c77f783d89d059e0a81318db860641d2c2b6156f3b8"
    sha256 cellar: :any,                 x86_64_linux:  "db66a85e1cdbc99db729fba22e4d31c71a4312f71ac618ff5b8bdf823626d57b"
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

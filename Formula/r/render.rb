class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "29a68480e29e8f6293b7915c92bce79cc83abb63823e75e0b02300f99836de06"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7df0258cebedd82b03950fba515f1393ebce787aad27d0fdd747e679779beef3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7df0258cebedd82b03950fba515f1393ebce787aad27d0fdd747e679779beef3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7df0258cebedd82b03950fba515f1393ebce787aad27d0fdd747e679779beef3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7057fb36c259194ab54a74c1e12b730bba96bb94507dbc4326cf071e959c2ff7"
    sha256 cellar: :any,                 x86_64_linux:      "10cd4f866e08f0b4344da0ca27f11fb72bdea07f680cd01ec9287393f309f36c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/render-oss/cli/pkg/cfg.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end

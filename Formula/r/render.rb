class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "dff9390e52de81a9ba3b045c239ad5ee16cb7c332c9af495cbbd3e0c34111a2f"
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

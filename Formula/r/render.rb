class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "dff9390e52de81a9ba3b045c239ad5ee16cb7c332c9af495cbbd3e0c34111a2f"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b17cc4a02f528210f883eaf1280bdac16b3d59dfc9c994347a5fdb14dddfa90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b17cc4a02f528210f883eaf1280bdac16b3d59dfc9c994347a5fdb14dddfa90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b17cc4a02f528210f883eaf1280bdac16b3d59dfc9c994347a5fdb14dddfa90"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "273e1b8685f9de5969e083aeaa6e3d55cf8959d10b3ce7049740b3f60f265251"
    sha256 cellar: :any,                 x86_64_linux:      "d9f31be7921782c5cfa7dc5eab963dd57b06c619157b32bf8cbcb2a9b624d403"
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

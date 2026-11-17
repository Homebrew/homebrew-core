class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "61e39916f512dbce9d3daadb6a5f25f67cd49fa56ffa02e3b0604027a7d949a5"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e20e491b42250a4fb3b829ba935ecb3a28909fdcd7dbbc8801cab6d5809d0c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e20e491b42250a4fb3b829ba935ecb3a28909fdcd7dbbc8801cab6d5809d0c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e20e491b42250a4fb3b829ba935ecb3a28909fdcd7dbbc8801cab6d5809d0c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1cccac4ba7bd45087651b83ecab248ce395736d8e92c3c3cd64f29b40c2e7f17"
    sha256 cellar: :any,                 x86_64_linux:      "8bc08f6c0c2dcd84287aa790019ca5067bb47fa2a4cfe59fb31751632b0b5092"
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

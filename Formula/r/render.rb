class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "fc24738c41644dd9dc16608020eac83139e4f14703bc94b6cf3ef53a5de64c31"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b02ae5e4972fd242347a0c2c1aaaef2c1f2197a37845ac951796e50565fd8de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b02ae5e4972fd242347a0c2c1aaaef2c1f2197a37845ac951796e50565fd8de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b02ae5e4972fd242347a0c2c1aaaef2c1f2197a37845ac951796e50565fd8de"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0516f9980df6bf4c10aab896b8345202851465a3e958040153035def402afdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f9d3985ebd30cf61106efe2f99ab19c405d9e5c3fe05df958c1d3291736026e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7d4448d1a8b5ad72e9dc1dfbf53a947824399d68b7cae942cc9901262cd1ff9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/render-oss/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end

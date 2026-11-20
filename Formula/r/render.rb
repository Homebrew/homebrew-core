class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "8fa8e77e7118124d12fc2d6a7fb54b9552f0242aa71eaa0ebc686f9176aad203"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ead4a6245c5004be21756be0dd4aaeea6c31871296bb9133be248e1c6e5d09bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ead4a6245c5004be21756be0dd4aaeea6c31871296bb9133be248e1c6e5d09bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ead4a6245c5004be21756be0dd4aaeea6c31871296bb9133be248e1c6e5d09bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e0777d38459bb62cab6db8c06e5ce611fb309feb0c9662049d9bfdba8a679900"
    sha256 cellar: :any,                 x86_64_linux:      "71f31c8ef0d7ddf983f5edf2d4f6918c34809e804e42b48bbadeb9658aef0d6c"
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

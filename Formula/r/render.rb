class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "29a68480e29e8f6293b7915c92bce79cc83abb63823e75e0b02300f99836de06"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99ab56f809b54d0327185a9a3835d4d6e7c15f3cee65303ace21449c6ea965c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "99ab56f809b54d0327185a9a3835d4d6e7c15f3cee65303ace21449c6ea965c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99ab56f809b54d0327185a9a3835d4d6e7c15f3cee65303ace21449c6ea965c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ac6f38b04518531fd4c4cfcdca70bd7bb3e15c5c24794faff778f28ccad9f524"
    sha256 cellar: :any,                 x86_64_linux:      "b8fb8d83e02125ba2a4239d628198c7acb5306c8e58cb810f0569f164a2abd64"
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

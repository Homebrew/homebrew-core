class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.39.0.tar.gz"
  sha256 "76c7df59a364f56f9c9a2997996dc229eea127a00928812d75f014164cf2bd0f"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    manifest_sha256 "f69d22ed7558a545a876a5033c9e914fa0d31a6103136e15a74a31d9ddb7091e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "912479fd6cf95628202e2fe4d871628bb044d5f728591803ded702f21fdd0d2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "912479fd6cf95628202e2fe4d871628bb044d5f728591803ded702f21fdd0d2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "912479fd6cf95628202e2fe4d871628bb044d5f728591803ded702f21fdd0d2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8f09d6836a0c9438bf0c28bfc84df1cfb3bfc3bbc5f6e8d5eb121f464a56a066"
    sha256 cellar: :any,                 x86_64_linux:      "5b995bdd2690522db4162340be47115d96d1ce5581b671033b7b2b34fe861491"
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

class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "7d42408ba73fcc2d3d68f86cff340950b926b9d9a39036cf53338d7f26853637"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "89a8a7e77ccc262daff2d1cafd0b240c4dd9257cda014a884343c7bc1732bc83"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "89a8a7e77ccc262daff2d1cafd0b240c4dd9257cda014a884343c7bc1732bc83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89a8a7e77ccc262daff2d1cafd0b240c4dd9257cda014a884343c7bc1732bc83"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1c2fb6f8c3196450b53d7d288abdf51786e546248c05595afc17b101ccc0181b"
    sha256 cellar: :any,                 x86_64_linux:      "e22522bf81ca7f128f16fd9f5578b0800f3d1f38c88d141c110479e618a00e38"
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

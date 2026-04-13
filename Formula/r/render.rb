class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.15.1.tar.gz"
  sha256 "5a4df37603d66879a03cf733ea250d8f3470eaf2bd2d25c6c82a15d4e60ee0e8"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "229088bed1a32adba3703173f60d6d809d2f085971d81de62a8f0ce60d6e8d7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "229088bed1a32adba3703173f60d6d809d2f085971d81de62a8f0ce60d6e8d7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "229088bed1a32adba3703173f60d6d809d2f085971d81de62a8f0ce60d6e8d7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0acf025eff4974ad729f1ae573fd76a63e81cfd52658ff48cc5b819d73c28d52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11f1a3fa3d9d7eca68c27b4725901e613d31a6cc41a17f79828dc1a01c64fc9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14721e2d19c9004ad38600862864993989fdb33be45a958abdbfcfb0a2d634d7"
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

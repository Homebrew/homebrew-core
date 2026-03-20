class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "af1ef3b26b4e07c56c357f642a3a07510263efce594dbffac6bf6299edea2e7d"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ef8f9bc699f3d354b41bcb2a650d49285162da0cb8c1d630f02ab4ea3e0ae4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ef8f9bc699f3d354b41bcb2a650d49285162da0cb8c1d630f02ab4ea3e0ae4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ef8f9bc699f3d354b41bcb2a650d49285162da0cb8c1d630f02ab4ea3e0ae4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ba4155fd37f3d7e1a24f3c0a13125b2958978c5f7c0913c573888254a504470"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dca246d42a36980c1d5cd951fb3dca5fce0e14ce2eeeedad7e2803b20c2c2b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cfe6cb6d70859dec257d7ef56dc69aee0afe486c79d266bf31bd4d3e0692bf8"
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

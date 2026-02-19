class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.10.tar.gz"
  sha256 "4630bcc296f86d7f41b916989cad51538fa43843bab53359bee3ab74b7322d01"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35d397484de4f931d5ba6e5817c46ccc9710efbc190b92b63db47647ef8f9646"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35d397484de4f931d5ba6e5817c46ccc9710efbc190b92b63db47647ef8f9646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35d397484de4f931d5ba6e5817c46ccc9710efbc190b92b63db47647ef8f9646"
    sha256 cellar: :any_skip_relocation, sonoma:        "81a58c30d8f60d2a917801862fdbc70b7fdec9c55b8c4b4a2d91e0dbf0b844d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eceba88b7680f1a1223afb82896e9a5de058b5f7b8bd9c921ea9899101de6e90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51f56cbc94afde7150d6d6265367feb067f0e5aeafe204fb54da4abd71a18ac0"
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

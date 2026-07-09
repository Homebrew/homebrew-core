class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "547495a75736f768739a0084b4eac75111d3189acb76b3ac53f21348fb81a74f"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bda6a6613df2b0efe701ef6b8e8deb7aab2f59757321059e1ca59fdf68f5aa8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bda6a6613df2b0efe701ef6b8e8deb7aab2f59757321059e1ca59fdf68f5aa8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bda6a6613df2b0efe701ef6b8e8deb7aab2f59757321059e1ca59fdf68f5aa8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e1b2df9bb5cbda22b6a62233ead190446d142c9a809e4c8df0532d90213e3b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adc46f0997133d2db5129a68239b5b8780461f207d080442f8b23780e11d2c03"
    sha256 cellar: :any,                 x86_64_linux:  "1008c872c50f9caea5901f1a59cb08bcdeea10e79e52181b748a5deb7a7fae07"
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

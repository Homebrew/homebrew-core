class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "acf647ac56ac48033213eb192cceee2ca330513f81667a879c2da1ecf03e0145"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b917682544926b65f8bc58229a2b76303c73768e0dc9a2ed7749dfb4c4a6f249"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b917682544926b65f8bc58229a2b76303c73768e0dc9a2ed7749dfb4c4a6f249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b917682544926b65f8bc58229a2b76303c73768e0dc9a2ed7749dfb4c4a6f249"
    sha256 cellar: :any_skip_relocation, sonoma:        "b46ad525207ece7036e5e358023a8d836080eeceefb890b022de09042b09a7fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1468ab22e0072a43e793404382af22964b728d4142b35a30c56963ebf8b01ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9a147e1cd0c2ad1ce91b2207b059768536f6b3ec4af017def2412fdae7cf98f"
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

class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "f8085d00495e1191c4aea972d9927d5ea12d81df51da7c988cb73481496c99a8"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96f5570d002e0d95ed7edaeacbfc5f11c514b9cfdc9c638ee3c55a87bb961f3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96f5570d002e0d95ed7edaeacbfc5f11c514b9cfdc9c638ee3c55a87bb961f3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96f5570d002e0d95ed7edaeacbfc5f11c514b9cfdc9c638ee3c55a87bb961f3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "20b143e4c1877e2ec341eb692dc2ca6aa8fbb1d516265a413588c3be5f55699d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09532d3931bcb9ea4bac4e3974ba6adac48d553db32809c5aa5987a5fe34e0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02a912ed60e3cbc7aeb009b87db2d1edb54b655662716327db6e1423c3efcfec"
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

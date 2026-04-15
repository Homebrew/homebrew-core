class Snip < Formula
  desc "CLI proxy that reduces LLM token consumption by filtering shell output"
  homepage "https://github.com/edouard-claude/snip"
  url "https://github.com/edouard-claude/snip/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "64726fede5d51d1f1a6705c2d4a6c83be27c8a4872623136898d631f64107928"
  license "MIT"
  head "https://github.com/edouard-claude/snip.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/edouard-claude/snip/internal/cli.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/snip"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snip --version")
    assert_match "filter", shell_output("#{bin}/snip --help")
  end
end

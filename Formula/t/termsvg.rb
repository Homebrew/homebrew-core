class Termsvg < Formula
  desc "Record, share and export your terminal as a animated SVG image"
  homepage "https://github.com/MrMarble/termsvg"
  url "https://github.com/MrMarble/termsvg/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "b7b75b27507c7be0e23df074782a0901a2cb6844da14a89622c3f787397b3862"
  license "GPL-3.0-only"
  head "https://github.com/MrMarble/termsvg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58d2141772e1fdad264d888d8a48e3318969286012f3137d29c563b4def46326"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58d2141772e1fdad264d888d8a48e3318969286012f3137d29c563b4def46326"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58d2141772e1fdad264d888d8a48e3318969286012f3137d29c563b4def46326"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9d6b47ab7e91f63f972b2b428696fa660a55889f51c3e69003ee8f17d01eef5d"
    sha256 cellar: :any,                 x86_64_linux:      "b9bd47c6392438b73166f4489fbdd8a90592c6cf604739a90330b80debf01468"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/termsvg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termsvg --version")

    output = shell_output("#{bin}/termsvg play nonexist 2>&1", 1)
    assert_match "no such file or directory", output
  end
end

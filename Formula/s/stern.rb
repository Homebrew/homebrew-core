class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "c75ba288b84379a39cffd2e4d27d5cb1d46643f9f7810a391670844727051006"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2fe74cbba15cc2c937963f741bb5a1d128d5a7575e4481d0ef9df0a88aa5eba4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d06b2477251a8f9d547f36205b615585c1eefa08a9a373800c3ad7ec325b0dae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36829a090fbd50a32d63a47e73a438358c3040d8ed050c25352cc78cff7bf90f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b12aaf51669d1cd3f33b645fcab6687e88028b8fca069c005460e01584819859"
    sha256 cellar: :any,                 x86_64_linux:      "1a5e0c15ff08bc9d6a30849b2a9b125380c479b9452efd269be29ffa410fd782"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end

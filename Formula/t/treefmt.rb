class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://treefmt.com/latest/"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "2b67a03045e8d31c6018d2149438d544c1c9dae7db44510cdd596030a13b38fd"
  license "MIT"
  head "https://github.com/numtide/treefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb28440bb5687c47285d3eda1deb2afbca41b8ec9e90734489bb9ad1e357d33d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb28440bb5687c47285d3eda1deb2afbca41b8ec9e90734489bb9ad1e357d33d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb28440bb5687c47285d3eda1deb2afbca41b8ec9e90734489bb9ad1e357d33d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e0b3d5ee9295e23ed72fd76594e5c54fd46660c40521a02c4303f38da39687a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e024ffde13c8cc821c8eea234f9a86cfa24c3d2907bfbc03565f8d3558d67b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f560c64d79a0d230c5ba5d8f41376ff022eb22a97fee928e18959a44adb9f713"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/numtide/treefmt/v2/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/treefmt 2>&1", 1)
    assert_match "failed to find treefmt config file: could not find [treefmt.toml .treefmt.toml]", output
    assert_match version.to_s, shell_output("#{bin}/treefmt --version")
  end
end

class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "c24caf4ba2842dd6dfb349f8f2facb248571ecd371f75b38a62b278786e87729"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "947ec9adf0f0a9659dfd318be348ffd3eb3930d219e118694006d79835d5de20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "947ec9adf0f0a9659dfd318be348ffd3eb3930d219e118694006d79835d5de20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "947ec9adf0f0a9659dfd318be348ffd3eb3930d219e118694006d79835d5de20"
    sha256 cellar: :any_skip_relocation, sonoma:        "243c213cf6e688d72f828f58346b22d5c35e6b8805d2bdabe86be9130da274a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86aef3668409a7a678bb55fb1a8611b35257121753bf2b4737ec2003f371ba97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98b0132b861cbeb49e57b3b3ffc8bc41a660c7d5d3ab866abe7808e2aae03b39"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end

class Scrutineer < Formula
  desc "Security through scrutiny"
  homepage "https://github.com/alpha-omega-security/scrutineer"
  url "https://github.com/alpha-omega-security/scrutineer/archive/refs/tags/v2026.11.07.1.tar.gz"
  sha256 "fecbff809dab7d3b8bd6f0f1588cf8fda4922bba6f6f642bafc71f5fc2b427f6"
  license "MIT"
  head "https://github.com/alpha-omega-security/scrutineer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39a5d75418f1aed021935ec272a862bd5c4203a6354793d890572534b0001c68"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "39a5d75418f1aed021935ec272a862bd5c4203a6354793d890572534b0001c68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39a5d75418f1aed021935ec272a862bd5c4203a6354793d890572534b0001c68"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9a5a5d0e035651844b39d7e513cd44a053f63b2263ffcfe61af405271944c72d"
    sha256 cellar: :any,                 x86_64_linux:      "3611d4b1b23845351cea5a5dbe7bbf543736c0a3a0232ba92a945db9ef4f3f07"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/scrutineer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrutineer version")

    output = shell_output("#{bin}/scrutineer -runtime brew 2>&1", 1)
    assert_match "runtime: must be \\\"docker\\\", \\\"podman\\\", or \\\"apple\\\"", output
  end
end

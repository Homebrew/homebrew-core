class Scrutineer < Formula
  desc "Security through scrutiny"
  homepage "https://github.com/alpha-omega-security/scrutineer"
  url "https://github.com/alpha-omega-security/scrutineer/archive/refs/tags/v2026.11.21.1.tar.gz"
  sha256 "1e36a9bfc12fd4a115e8c9fd8b2b14ac43d74b0b5ff35c9e98cae6f4ce07530c"
  license "MIT"
  head "https://github.com/alpha-omega-security/scrutineer.git", branch: "main"

  bottle do
    manifest_sha256 "e432ccb696c8561f092bccd163ebe75fcf785cd158e8cf487b9f5e90b371f8fc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fbfbfd651c3f0113d348f9ee8d5d472bc620af3b225dcfdb48a8268493bc6123"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fbfbfd651c3f0113d348f9ee8d5d472bc620af3b225dcfdb48a8268493bc6123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fbfbfd651c3f0113d348f9ee8d5d472bc620af3b225dcfdb48a8268493bc6123"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "80e0f225a6ba029140057f70c945d8e895d81c5af3add7def0478de664c2dfe4"
    sha256 cellar: :any,                 x86_64_linux:      "30cdd52cf8bf450f8f6579f33496ec22dc3fde17317fa746e4776c39d332de30"
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

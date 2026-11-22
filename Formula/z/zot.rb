class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.88.tar.gz"
  sha256 "52bff4913438773991854aaddf62991e16c99b02cfcdbdba8d00a1af51bd2a88"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a184dcaaac4e234d9836fabec5339d76afff2e06c50f8a7dd71f5f801a06e04f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a184dcaaac4e234d9836fabec5339d76afff2e06c50f8a7dd71f5f801a06e04f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a184dcaaac4e234d9836fabec5339d76afff2e06c50f8a7dd71f5f801a06e04f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eceab9a2d3dd9d2040202507fb7753e51413c750147356e39c978e03b5288b39"
    sha256 cellar: :any,                 x86_64_linux:      "07a2c9cf2fa76943d600337d1ecb8774c235fbbe9859989625c63f0e9929afd3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end

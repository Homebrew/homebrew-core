class SpiffeHelper < Formula
  desc "Tool that can be used to retrieve and manage SVIDs on behalf of a workload"
  homepage "https://github.com/spiffe/spiffe-helper"
  url "https://github.com/spiffe/spiffe-helper/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "ccfcce0ae20ab613fb73048189931f52deb996f999561cb1f1681f65fb0705cb"
  license "Apache-2.0"
  head "https://github.com/spiffe/spiffe-helper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "89866bcf98dce82fad6212650073811f5058c4a42885acd23eaec1e2e2f01e44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "89866bcf98dce82fad6212650073811f5058c4a42885acd23eaec1e2e2f01e44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89866bcf98dce82fad6212650073811f5058c4a42885acd23eaec1e2e2f01e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "008d7736797ed3991143d3f2dcf8b152602ce47beda50fa8f3ed4eedc45d449e"
    sha256 cellar: :any,                 x86_64_linux:      "b6b872fe25d09fa9b78c5bda24c1dfd511c7ac6054d859c432fbe3a063d2a5af"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/spiffe/spiffe-helper/pkg/version.gittag=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/spiffe-helper"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spiffe-helper -version")

    output = shell_output("#{bin}/spiffe-helper 2>&1", 1)
    assert_match "helper.conf: no such file or directory", output
  end
end

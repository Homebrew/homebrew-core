class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.77.tar.gz"
  sha256 "3d765952e0526233fecc7e02ebfa32cbb29b05728db5fe79ab2e5c57023b8e32"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c198d773a5482bc06fd17cc8039ba409e224fdec93b8238963261c889cad646"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c198d773a5482bc06fd17cc8039ba409e224fdec93b8238963261c889cad646"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c198d773a5482bc06fd17cc8039ba409e224fdec93b8238963261c889cad646"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "457822e958c9ede77c01745f3134aca1554dd1a9b7157023ff8cab522cbd082d"
    sha256 cellar: :any,                 x86_64_linux:      "289e10a45620905a274cd5468c7ce3ad4ad7f8fac79f8970f954f6a71bc64470"
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

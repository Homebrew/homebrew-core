class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.84.tar.gz"
  sha256 "923eb1831d58ab9be82852717b103102c1ccc4e2e48beb7f0f45ad5de6f51039"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43f4ced5a781ff90f87040746a76437b739875083645403ad44cc32b8b8cfc07"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43f4ced5a781ff90f87040746a76437b739875083645403ad44cc32b8b8cfc07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43f4ced5a781ff90f87040746a76437b739875083645403ad44cc32b8b8cfc07"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b87c83d7c9cd34a5a742def2285d4c03b5785971db2c480a29d8a2a299c980d8"
    sha256 cellar: :any,                 x86_64_linux:      "6225cd2cda62986761e33aa1d2f22bdea4c0b73745c0cc62f0151c971c36d7e0"
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

class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.88.tar.gz"
  sha256 "52bff4913438773991854aaddf62991e16c99b02cfcdbdba8d00a1af51bd2a88"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    manifest_sha256 "c34522acdbea55ad36c262732d465bc8deeee0e48a2373147d56da17c3716611"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "161417dbe142f71e5be0ef66ccf37dea075c6e468af3768dc0cab38bbcc3413b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "161417dbe142f71e5be0ef66ccf37dea075c6e468af3768dc0cab38bbcc3413b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "161417dbe142f71e5be0ef66ccf37dea075c6e468af3768dc0cab38bbcc3413b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "401081aa52189b0c47c0d157cf3467c8e271b91fb3224fbd5f5e2221799b01f3"
    sha256 cellar: :any,                 x86_64_linux:      "c96559f6fa03a268a7c26a3cbaddf01e5a6174764f6c790ef52fe32e87fbdff2"
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

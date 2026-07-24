class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "770c51203be70779d62d836d901df9cc6d5d6b59115b9dd2f1b834202dccacbc"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "094b9a9fa02a5a86ee1b069f46f3fab97765b8155ae1500347e05f392ce0aa58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "094b9a9fa02a5a86ee1b069f46f3fab97765b8155ae1500347e05f392ce0aa58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "094b9a9fa02a5a86ee1b069f46f3fab97765b8155ae1500347e05f392ce0aa58"
    sha256 cellar: :any_skip_relocation, sonoma:        "1480fc8e7bd6418ab02da48c6c56b24cafa2529034e13c3dfde66cbdc686a577"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec4ad2852e93c1a7a8dc64f4e713b1be7ee13677e8fbfa9823ced11fe6786832"
    sha256 cellar: :any,                 x86_64_linux:  "83eb9cc6ee2cfcc6d4c4c1f2260e1838281f8e397eeca0c510172033021b7517"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end

class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.61.tar.gz"
  sha256 "b8035b3a251f4a2a6a7c4aa10503071dd008ac84d990f5196bbf26e780409b13"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4df6072e42fd1c8be9644b01758473d8cdeb32635461fcf67628ca1fb9dfae75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4df6072e42fd1c8be9644b01758473d8cdeb32635461fcf67628ca1fb9dfae75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4df6072e42fd1c8be9644b01758473d8cdeb32635461fcf67628ca1fb9dfae75"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "88bb002c4fcf90d15ae7fafb6ee528eab5b0ff374c444a1473ec0cec12ede4b6"
    sha256 cellar: :any,                 x86_64_linux:      "1addb978d44e805dbddc8729d56aeaa91a47ffedb18f8dbf02d623b08715b5fd"
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

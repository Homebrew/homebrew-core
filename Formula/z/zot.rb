class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.76.tar.gz"
  sha256 "aa44d31c15533a872837abc7114d4e3eba68033614091bc4164d26948a67575a"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59b949539280cd6e14c332ae0fd521cf052337ba1c9717880b5f28cb4229a67a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "59b949539280cd6e14c332ae0fd521cf052337ba1c9717880b5f28cb4229a67a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59b949539280cd6e14c332ae0fd521cf052337ba1c9717880b5f28cb4229a67a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d1a56c084ab378b59511406df33c50bd25305545849a9ce41144e0fa59f5eaf8"
    sha256 cellar: :any,                 x86_64_linux:      "dfccbe79b1b3e07e755fb8c717a04ba7d09dddf332ff63876822326c934e0d83"
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

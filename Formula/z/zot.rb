class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.64.tar.gz"
  sha256 "981acc4af7916f80c49f81b140a40b1333e31cb1b24864e8aa1c36590f478858"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0bd512f28054038d34de272b7431f05e3c154454cd72943c02861e31a71ced69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0bd512f28054038d34de272b7431f05e3c154454cd72943c02861e31a71ced69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bd512f28054038d34de272b7431f05e3c154454cd72943c02861e31a71ced69"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd7781848a65f6fe41ac04acbe204266bd0363c7214924a0181bcf5520cacfda"
    sha256 cellar: :any,                 x86_64_linux:      "d863543adeb17d1a80cce608d630f342b843a9e66a7e84fb7a279e08105589a4"
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

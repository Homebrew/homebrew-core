class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.61.tar.gz"
  sha256 "b8035b3a251f4a2a6a7c4aa10503071dd008ac84d990f5196bbf26e780409b13"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e4fed25240536ba2c177f525fc03dceb6c636257b21a03075d5ea03afc30a5d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e4fed25240536ba2c177f525fc03dceb6c636257b21a03075d5ea03afc30a5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e4fed25240536ba2c177f525fc03dceb6c636257b21a03075d5ea03afc30a5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ef5b46ebbc9a30c6da409fb04c04f686614d9bcb7afcd9000ca9120db070d05f"
    sha256 cellar: :any,                 x86_64_linux:      "40cc1cb6dd04be3e6953497b6af1802de061878e110285164be0fdce9951c4d5"
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

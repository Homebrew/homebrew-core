class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.27.tar.gz"
  sha256 "eb19d580c32cd5fea096a073934f4071cb57c26ddbd2893107da70e597f2f1f8"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8e1eba4b449d423531558d8bb8dee16e85f8b258a619b807a3b775acef26933"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8e1eba4b449d423531558d8bb8dee16e85f8b258a619b807a3b775acef26933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8e1eba4b449d423531558d8bb8dee16e85f8b258a619b807a3b775acef26933"
    sha256 cellar: :any_skip_relocation, sonoma:        "c15e0cebacfc06a7d899a093c938abdbfbdc71aa9431ab73362cb8b070c94953"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "783dd60b1d7a7ec8d6e9f55385a77962378a37c8bebdf9d28bf652bf3d3b5514"
    sha256 cellar: :any,                 x86_64_linux:  "418afa20e316f76178359d7bae8390089c24fb0be02daed02fc482db212f79f8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end

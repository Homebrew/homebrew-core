class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.61.tar.gz"
  sha256 "bdfc39dc37e91096aa17e85bed2749a1738d4be6ea8d2edc0e44e99078dce65e"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0f0e186a6ab2dce23c69936c54a5b0ea0e78f50b6d1a6b5cef4cbeac5fbba79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0f0e186a6ab2dce23c69936c54a5b0ea0e78f50b6d1a6b5cef4cbeac5fbba79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0f0e186a6ab2dce23c69936c54a5b0ea0e78f50b6d1a6b5cef4cbeac5fbba79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea717b51e63854b49a8331dbab275e07eed6aea169dfc33adc7d8d54af2e7e33"
    sha256 cellar: :any,                 x86_64_linux:  "0bf5a1ab6ebf4783009586398252935a5bc1d3d3795ec946900ba8cc6709dd86"
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

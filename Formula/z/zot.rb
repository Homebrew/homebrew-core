class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.81.tar.gz"
  sha256 "27ead9fe792ca4ba59965465955c25708da4239438544e8b7668e4d2d4b3365b"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7964adc5796acc3529198cf2acc303333982af3aa182f0ceb9fa6eb22b5e6557"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7964adc5796acc3529198cf2acc303333982af3aa182f0ceb9fa6eb22b5e6557"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7964adc5796acc3529198cf2acc303333982af3aa182f0ceb9fa6eb22b5e6557"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "645269879ab8fafb0c89e9f7257653e83550129c1a79ab4a0a288a85294fc766"
    sha256 cellar: :any,                 x86_64_linux:      "c7073a17b852cbc9f62106c4a5c064f134b37ac9e975e116b3214860111a2536"
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

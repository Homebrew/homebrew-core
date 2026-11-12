class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.73.tar.gz"
  sha256 "70642c9f084b18a3f9db567a3167baab955badb3aa64483316427d0b85fab88e"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eae33a38e32719509d063004c505eeb6fc70a0c9f7d5d64b7d0c8f2afe835f99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eae33a38e32719509d063004c505eeb6fc70a0c9f7d5d64b7d0c8f2afe835f99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eae33a38e32719509d063004c505eeb6fc70a0c9f7d5d64b7d0c8f2afe835f99"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a9127cf056ab667d351715cea8ba3c455f0fa3921b1a12a592629ab9fc3eb335"
    sha256 cellar: :any,                 x86_64_linux:      "d9266516be2bb1bf2aa18fb986bff6ee518cc09ca92695ccb0fad62e0a2b9fdf"
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

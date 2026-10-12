class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.29.tar.gz"
  sha256 "f760566615016bccf76f201e8c4cef51c7fec3b8fdb1a4b5f6a9e19a4d7007f8"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a6298fb44e95627af03a1f91d7cb2787f5814ae520207adc49ef3874d9361b0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a6298fb44e95627af03a1f91d7cb2787f5814ae520207adc49ef3874d9361b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a6298fb44e95627af03a1f91d7cb2787f5814ae520207adc49ef3874d9361b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0fa405e62ddd2bba3c68444abbf9109528128b02313e6c9fe758304d966477df"
    sha256 cellar: :any,                 x86_64_linux:      "a902cf191caa0b112a3ac59c2eddb9f03b55abc9a43f4c1bd1423673074bd197"
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

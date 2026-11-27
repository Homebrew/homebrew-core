class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.90.tar.gz"
  sha256 "18f9ec812f5e64d78e1fdc03d65bf1aa3a5f5269bf57ffa50645601d100d8d6e"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    manifest_sha256 "bcf052a3dea23989077c4339df527e68f6360c57930db6a7d3e459b02e80bc8c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19735d224e2a3f7ec49f16a04f284ecd28c59e0c60846a7b5a924ecb7024f11f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19735d224e2a3f7ec49f16a04f284ecd28c59e0c60846a7b5a924ecb7024f11f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19735d224e2a3f7ec49f16a04f284ecd28c59e0c60846a7b5a924ecb7024f11f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b5600714fac8d8293601c82063516144cdf6967a12da7eeeffdb23e0c76f7038"
    sha256 cellar: :any,                 x86_64_linux:      "2e9ef2c54db239f7cc66c30ab770c24e665f062c533cd46286941a98bd2e0947"
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

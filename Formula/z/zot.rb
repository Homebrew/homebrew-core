class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.87.tar.gz"
  sha256 "e3a906c697543b6f4960d498c0ac6d781555cab28ff3678c7bff6defec6e09ca"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3eaa987ef8124d057f26cd5ec2e2525c8ae8fb18be037c147977506839efac7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3eaa987ef8124d057f26cd5ec2e2525c8ae8fb18be037c147977506839efac7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3eaa987ef8124d057f26cd5ec2e2525c8ae8fb18be037c147977506839efac7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "027ced08f2f31a6ca12870e63b4f8d86655cb38ec36015552309b4081d4ffc0c"
    sha256 cellar: :any,                 x86_64_linux:      "887f1d7c4d27582c6d4c3acd21d851bcaaf8011ebc1917cde12a523a50bacde3"
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

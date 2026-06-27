class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.2.47.tar.gz"
  sha256 "5e82ce88f63b4061b66bbf0baa641bfb6edbc5892ad733895c7f415eab9e4974"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3b7529c0b08660b5cee1f20c30d6df14d0134b3125b9c56c6c65fc7d4365b9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3b7529c0b08660b5cee1f20c30d6df14d0134b3125b9c56c6c65fc7d4365b9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3b7529c0b08660b5cee1f20c30d6df14d0134b3125b9c56c6c65fc7d4365b9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c220d7cfee0241c0c7841c14dd180875ed020e315c188fa8bd02c867edd02027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7670033e2d644a0663e9a616413f73cae67bce4f90efb2b2de9b825ed0286b9f"
    sha256 cellar: :any,                 x86_64_linux:  "fa5d85e83da2819ebff134b774f74e58e771e51b88981a5c2e31583a32df5d7b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end

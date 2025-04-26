class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.85.1.tar.gz"
  sha256 "f07cfc0b154328133eb2de5a8167256a173c94b08f1a5d1e01610b97372321d5"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f443fd69bbf13388c05922cb6b0472b5f5cd9da685fc41c6ed5f7ae944dc0aec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "712de6bf2b61c813af1929179114bbee7cd01f9aec200a9e136511dd90304c0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1b7b060c5006212bcbaa5ad50711da3e2dda5e394dff6ac70f95dc35ffea8b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "16eadda7d42989a27d5d1972d614379ad3bf011f8c7879164f55c4fcf02ff39b"
    sha256 cellar: :any_skip_relocation, ventura:       "0e08180da0057b088c2c3f153fe6a41615379d3bde156a7d0c04a08eb415c28a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15be33ca7454e71499f5d7c757f0f205c85ffaad6670214ee4e8c15783893c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581c6b48d2acbfee0d235ce368fed960c1cb34f99045c1fc329b5818ed7a0527"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end

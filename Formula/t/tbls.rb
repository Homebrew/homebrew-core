class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.95.0.tar.gz"
  sha256 "2133a6a7586e0f96189d6e06c90b3ac80457c42a3fbd59f9ca7896afdd39c4f3"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0d027c7e72021fa5e981bf8029430eb03032c0ceeb3d5a3b61c2f41f7d9f233"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8009aaeaa9c106e29eeb534083fa8047b5f2bbe855ad4feebc495b7475fe091"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4931c4fbcbf1236618348e17409b786e9c0a761f5ffab5618698091ff414b7ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd85b6b1e596ad65bcff3c8f6b38fed6648d97b2b6a35cd1cf3ca03fa642b34c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e05767187850f8f45bcdb9a66c1c6cc4ccd6a0c673151ef26151c492a11c634"
    sha256 cellar: :any,                 x86_64_linux:  "2e907c6429b767b0b1960454f60fa70a4ac598fa0363684e88382c990534337c"
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

    generate_completions_from_executable(bin/"tbls", shell_parameter_format: :cobra)
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end

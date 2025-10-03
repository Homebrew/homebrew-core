class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.88.0.tar.gz"
  sha256 "5a74ee8651da871b8dbd0cbe8c91d4aa715c70715ec976c6e89b15189b50100e"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d9f76f3d024f868acf12c533dec4fbc278dee97924d5ab01c6d9f0afbec6ca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a981487619c91c775ae85cbd9603d45d3df0c03d113f266d6751a6067a66c09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b9302045cd046aa078ff0b754eb9b4f80ca0f02467bb90661d0569184e768dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "16e1d676e1a2d4013e61ce824f6f3af6c6aa8fb1d587510752016f8e63ed63d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a132123ab855906ad3fc95821a04d88b63d317867f324e810f59af95dceb1de2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b32c61b90d97e49a5323408b3412c7d4f40a0c812b4804ffeb4bdbd438703bc"
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
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end

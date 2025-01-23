class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.80.0.tar.gz"
  sha256 "d28301c1ffe05a1b72bf61b21e052178380b2c7ec923303ee3bcce3ce3b0a991"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c79eed4ee838c6a5e0e2c561e3e3b27c799207ea27a0246ba4e0b448dac35882"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20a753cb22bc2128b88b8a1672bd3191e497624334b3bef1abe574cea5dca1b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81cf2ab204d945f74f1ee73a728d742f8b771806aa76ca9c5911ddff98dd1a84"
    sha256 cellar: :any_skip_relocation, sonoma:        "f78c6df53a25b00999cb1118dd167911fe5e0ecfc9736f7280509ffc70c3e1bc"
    sha256 cellar: :any_skip_relocation, ventura:       "89d62db41813e4c82023018c515a12d5a63f10d74aeb7bff1892db4d55864750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c81b7523bfaad0cd5f0098702b95f2a5f85a85d1a0fb07dea9708b4c33dcf5"
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
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end

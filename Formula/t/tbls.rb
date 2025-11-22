class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.91.3.tar.gz"
  sha256 "daf07d08d1e0b33e3ef741c685fc05763879f9b1ab3e8b92b22d086d868f666e"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56caab71cefb10f2903be478953997979c76ef919c9a80c7c49e97045eb419b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfdc60056fcbc8505c16ff15130afd536530b2233c6676e03266cd8395814b49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78952b41f1f4cd97097ff2f232d833bc5e8ce4cd48046d1a0619509831886fe3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b13fa28ef85e6ac7412a5401f70bbe6eb52a201899b2f5444856c8fa7ed456f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "698822876325785aacd3aa2586df228665fedb36a7605b64e5cf7f54486dc51a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fe5629f1d6b2ad41b80e24aae9d003b9f53ab8136d192fb0b78bf988a472979"
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

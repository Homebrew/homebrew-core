class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.68.2.tar.gz"
  sha256 "610f2f45e2a9b99177e988523f89674dc7e324326cf1830add126f32426c6062"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c56a8ba10f2a181b74f119ebb0b4507c68bb7fad5ae6dc47d8349aa68bfcd740"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10be288417048321596555db738a10bddc7ca6c05d57fdd610369a31c5cfee44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38121e28cfe6ff074acdba1db4a3618cd11ebea855137c944ea31b5cd7bc42c3"
    sha256 cellar: :any_skip_relocation, ventura:        "710412942cb3f06090b3e525c2f63c33e2a76802be6c6883a27777b372ec5a14"
    sha256 cellar: :any_skip_relocation, monterey:       "7b6e6cb45aade8c17b5075bd9475cf9054e64aba3b5fdad4a1f23df25cce8f02"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d45a12533c7aba7be6d786041953edb32a003a0c7891491ba681cae33259473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af8a91007482969b286c63a4b6ff6f192aac57c4ec010680f6541cb2efb0c357"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end

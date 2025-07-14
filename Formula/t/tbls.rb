class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.86.1.tar.gz"
  sha256 "82d5dbab4000c18754f928b48d328a151a9bb3bbb85d8b6a8c5dfcfdd0d51fd3"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48c01c437f02dfd029525151dedf2d2135ed1ac97b9a0fc7c0102eb27e8ecc81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d695d9c4bc6a8e2b3cb5d039a4474f0439c43929ba276a368d8c4b3321f2342"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d25ef103bde30954c76ee7407e34cbf3e66787cdbf6b28632cd669ba124d16e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c15185eea6e6222f14d99cc4465aa14a47c4c00d5a343b459b4002e240cf560e"
    sha256 cellar: :any_skip_relocation, ventura:       "73eb1c17328485d41d3d0fec00447e81bc807c8950f44a0c01caa1b43c57f628"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35f26a20529d9227b05b540a0446cacee166564fdd21812632be80d5738c3de2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1297d498283357ec454546c0f7ada3d51153dc58da77006b4ca6e4b4380b46c9"
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

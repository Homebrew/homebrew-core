class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.70.0.tar.gz"
  sha256 "d7a21f2f78c2ece1123f32471e4433e2497c010653ea263aac150c3e74ef8e99"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34cb88c34898a0b25a8febc88c32bfc9822e47bf67ffa0b659d760c18db44f49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f77fde1bc06947273b8a4058e193b9a7642623d3fbe09b1c30de5621117c25be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4d78347a584f7ac14fae08c69104ca94f7a324b7533ca0db0152c57fbded3d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "317214583a30a5641fdc3883d2a295dec583a1eb4770aca3182e318ee985ebed"
    sha256 cellar: :any_skip_relocation, ventura:        "3251c3d9ffa6e6250bc2c5fa267b0860b4112e70e3f6816478629d1b08458fcd"
    sha256 cellar: :any_skip_relocation, monterey:       "f665ab1ce598d0b48cc39b6184d85ee6fc3b4db88721653c643297e5d74b6912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "855de22a91424e4f410779cd34c927a150ff24567a7f94021f5effca8e2e4f16"
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

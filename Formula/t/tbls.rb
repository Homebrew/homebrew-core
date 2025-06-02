class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.85.4.tar.gz"
  sha256 "fe6c735fc46c990950f5a1bdca0c783e7b80129c7bfc3597b76e60c0025ab52e"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1215a6878cf0d72f6873a0201d60729db7c01fd6973c81c7bb5e102a0ce669d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0de4651a1d1e7d691c291248d99b4812160a1f4bdcf79a6efe6a91411c4f56ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8caeab63795e64ddbb08ffda840fda03ec601c49999e840a05f995538a62e1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "10d29650e8d9a12327beed40828a06d7def8c88c00ccaba344d5815f7ae67b69"
    sha256 cellar: :any_skip_relocation, ventura:       "1f82e9312e3e0b347e0415b432ec0ff2c576dfec636fc043ff441e94439db02b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4127055bd3a2f787ac84f23c456b9183666e154b3d2e1a3161a8467a4a33b472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60f25053ddcf37442862b2e65cce93ec4cc03d8d3538023b2f8cfb9dce8dd92"
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

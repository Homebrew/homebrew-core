class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.68.0.tar.gz"
  sha256 "65832f5bcb1498834043b8d5b8564e0eef604c3f5df7e2a9ff429d2b0ceec75f"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a7bf5dd830a28bf5b705215ecb0b0cb0e88bf9c2cd988b51914b7c8aa0aee6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4836ce379718d0b85ba2497c0212fccad4e44f37197938670029750ed2c2936a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ea381ab1698caff68d8d3fb347b9c8127740a21d7ee823f2fac094cf24c6e0f"
    sha256 cellar: :any_skip_relocation, ventura:        "6de27f58bc1f9a36561f5dd1f785f8893cdbc54ed492a8f77e40c40e2c6cece4"
    sha256 cellar: :any_skip_relocation, monterey:       "392b0b99dfffbf35822adaf7444909123949caa10ecf1f2160014109ae6f0b44"
    sha256 cellar: :any_skip_relocation, big_sur:        "06223bb74c81ef3c49d33e1f2f0f15eb2d7fe1917338406a1964e6fb40d151dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c04a9cf0d156f96890834540e19011bd813eb263c93d568e863c8a6ba47f990"
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

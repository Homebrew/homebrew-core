class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.65.3.tar.gz"
  sha256 "ceaaf51e583630047a8195137f48bdec4f99e30a78c56932eb7f482144140684"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "613ad052cba279149e288afb6f1dbfe0645909edab13451dc365614218bf321a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4de7eda653747d70e1f375a28d1acd9e23e1135459b21df7871abf5663ea7ca2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bb22207b3988d365d8a10ebad32b467baae2a7ab70b97e43675bc02f896c5f4"
    sha256 cellar: :any_skip_relocation, ventura:        "ac85cfdae51ba76547fe4710df363aa2639ccec46de2ba2ddaa39d6cf8b3add4"
    sha256 cellar: :any_skip_relocation, monterey:       "16ec5388783de0c5b4dfea263fa4d88a449e51e3f0ae4aa5f8008c0e9423a8bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec575cdcaa57dbc3a5d0f34d128e11dda36e56961afb1cc8c8cd1650bf9b5c3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23c8901ab032afe8db39e8b109778ef3e8f8444edc2c3790f62ff50d2e6efc7f"
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

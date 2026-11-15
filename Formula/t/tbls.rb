class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.96.1.tar.gz"
  sha256 "84dd9ec88c6803be57df27f92a27a91d03e4e79437242caa4b7b52eef48e9979"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c9781b6e624d7aef360535c4fbf6197a0f31768206644da46a155cee6205e6d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6768f07d3113c7cdfbd544e3bf12f14ce3a962b0a31654f925ae145fd5f0735"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7fc47e8c22e3642652a59bd2813395fa83e7d55039246d15ce03f3bb943eb74a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "49bef732dd47bcf665085fa18c6232ee8c070a0bf2ee0907f0fd3de6bb61e379"
    sha256 cellar: :any,                 x86_64_linux:      "6fedbad4fa2c435fa20fc3ef318590549edf1f043232a00cb8094950f818fd81"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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

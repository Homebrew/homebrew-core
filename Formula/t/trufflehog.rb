class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.97.5.tar.gz"
  sha256 "5c4fce6fe81bcd7f175852af433ad5146d2f21ce8b2ae268c85be0166b69192a"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1226ab964b5c6ed9bd676825aa3955fad6875bff7a164a1ff3754971bbcb07e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4dff40ad829afcd9963540745aff3bc77ebf4cae862a10e1f244999a0c2cb53c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9c16a075cbffb10c1d643f652f32ca4678aadad825543bd24bd01eb9217cb202"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a5ad8a93941b9bef3a29d7d2ddb18de372525d4172af49211db9bb6be86c09f"
    sha256 cellar: :any,                 x86_64_linux:      "efbb68dcfa6920ee201a212e9532d2e93a4be4c0aac238adca6ec7bca8267470"
  end

  depends_on "go" => :build

  # `test do` block scans a GitHub repository
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/man/trufflehog.1"
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end

class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.97.4.tar.gz"
  sha256 "b1346ded49f6283005284c56b98b5c3603c0f5077c0d4fcd083beda9dfba3268"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eae552c0189c38e9706d34fec388a9e12b1965542585034234d6e0c0a814429e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "834f68895f107a6e938704b29bb2c3ecd446ca968714dd40ee104c2c9de224bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85e206fe3c775c457288e8eeee93b1668e253dd51e7ef7aad65e59812439a4bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ab47da29cf094b57cd3fd3af1ad38f1b33c253f2c36195431790059f05ed9a0"
    sha256 cellar: :any,                 x86_64_linux:  "f5964bd67d1d867e1703f1591a7f47047cd7497174cdc0f8944e27f39e5bc711"
  end

  depends_on "go" => :build

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

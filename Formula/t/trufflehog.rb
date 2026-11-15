class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.99.9.tar.gz"
  sha256 "4709b07e25d7b637df3ba692cebb2b3a46e896cbebaa7b80bc4a81b77f2509cb"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8cf2277e119e74c923d57104254152f89484f8b90bdd484133fb93d2e018ba95"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "973b760d22480a044ac5265e2372f3c6a074104e217b1554aae64a268fbea15c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c3a2c1f7aa6dbdd86f9b01c604e156144127ab147cd6149de134376aed9fdcf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c74489e27121ae0178d2acda52eb7cf9682179d2bb78574751a7777da89510f8"
    sha256 cellar: :any,                 x86_64_linux:      "d85c5a20a390cd7a43116908a6206fd9d70861fd98c12ec5109938802393f191"
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

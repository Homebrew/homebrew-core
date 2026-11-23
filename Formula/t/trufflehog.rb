class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.100.1.tar.gz"
  sha256 "a993cf42408e6cb44b2931d7b170516ed7a9b58e1b4ab9269784ac7ae0940278"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    manifest_sha256 "7a36fcbb1127d4af572046353be0f5cc7b0aaf40849569dde4429718bdd262f4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5eaf8f0673d13cad638c89547167f024fb50f4c103dcec237c69295c3be24688"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f7d61bab12ed70aac4611228b504b4451bef0faef752ab2e404779093e626e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1cef9dedcb8c333470364e614dd6da71f211a7816f814a3661135bad68661ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d40739d638e515b0ff17141e044516b7e39ea42a700d5beb1e74039aa50dae84"
    sha256 cellar: :any,                 x86_64_linux:      "3405b6da916c448ab1754453de8102fa611ae7bc504d1f415f814b1a33299d2b"
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

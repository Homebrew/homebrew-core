class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.99.3.tar.gz"
  sha256 "b981b6e08f487de94e72aa498bc2af18049bcc9a3db7f5ebebb647aaf8c9c873"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2897f5f6fb8c47491c76e17d81603557b6e5025737b44291d9b42008fd551e9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9d55af0cb5dad7847d9dcd884d7362a9350e5bbd25d09bd35727f0ce964e0fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d786a133aadb5c67a09b3fc77c5651f81c02c7a2d668b12199b44d9f63de8698"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "13af9559dbb641273b76580dcac4413dbcc7fb1cbee37964c6b57bf65295b9d5"
    sha256 cellar: :any,                 x86_64_linux:      "151394c222ccbc377fc8fd81f55e3b3df6c96a959357986b11acba1a90d4f12f"
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

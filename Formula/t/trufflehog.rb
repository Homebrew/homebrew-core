class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.99.8.tar.gz"
  sha256 "c6b7ca37d8ce7fe03baeb129b2ab75021c44ab65a80241860a2872e0f232ccfe"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb64ca821570b2b888cfbe22b776537dd339b1897d582d2968516f29b4c53c98"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "307c761f8fd4e893fce85b47de638081f2505d146336a8ac547f01bc266d8a42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f7641638e6304ecdc849dabc88d7abbda9c4bfe1be69bfc1684bc3c7e838a657"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ee47c27a4a7ef962d90d4f6bf056d409c1f79361b1410513fb65b6cd0bedc4f"
    sha256 cellar: :any,                 x86_64_linux:      "a88b2f2376efc2cc15435aec704e59769c97ec7380fd536b19a9a691d22ef6b6"
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

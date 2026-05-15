class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.95.3.tar.gz"
  sha256 "99d88bb86e4ad33c5399e057ad091cda771b66f3b2ea60e23784049e7deca442"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e53f6cf8cdaefaf31a665e0956496ee94ca3dd4dd78ac5496d9924fe46d9be47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af073cd3ba01481b2c2e747e6dbe1a0e0b1a75afbbd29f4b83313bc6552f1132"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52ef9952828a31893704d330fa81123f25d64c7c3b955cd426c101b0d5ae8c75"
    sha256 cellar: :any_skip_relocation, sonoma:        "764a721560a553f6565ef6ccf6a9085366c985ed14d74e3ca822198a2b8caaa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6387c0d3e0303f57af2cc9b6c1e45c43d1d8874a9e487f3babb2324ff83b1c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b138e5c688065252720727dd261c1e5dadd5bb9e6fd6cd52f926e3ec14ada676"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
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

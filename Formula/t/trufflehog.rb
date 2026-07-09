class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.95.8.tar.gz"
  sha256 "274ad44b514061239ff4e22dc74f33ceb25b3db842e8bd7d59a7a1a3e22d3b71"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "750c1e2df8d6f7f9726e9ce2d313a3c73e95c83dd0e3cbf7b823c0b4eea171bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "776ddac145e246d39c773e12372e31d7f843be6f9c76bac5657118afb003b90a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5622cf3b225ebf647c0cc458d02726403e63b6fcbe2cb7608530e1d916d46a96"
    sha256 cellar: :any_skip_relocation, sonoma:        "d411f8a65f4fa1919aa682a434e95fefeb031c0af1dc2d4b90767efb813342b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ede54a8e9c43866b4964e1f0862c8e4ac8e84e6f41d8b77f0848dac1d5a17173"
    sha256 cellar: :any,                 x86_64_linux:  "bdeaaba9d9ba172e83c0cc3c0bf3198e217e77495fddcb423ab2f269710dbcc2"
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

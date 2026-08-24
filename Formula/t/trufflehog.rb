class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.97.0.tar.gz"
  sha256 "719397b158e4fc9bfe3a777c68fca4b64bb89363caa3ce3013dc28a9e70251de"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d56767957f63392c5187e66637ff195296b3e2b9e7c4de4f3bbc886356e9a80c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5b68b261fac32b8157b1e93a3549c333968bc9c2deab441b7619d384f669d51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75f8387f2ca69029da2c0caced7f929a57b1be0be4a0aef0616e5bb432ec2e92"
    sha256 cellar: :any_skip_relocation, sonoma:        "c706c053bfc2114b639b99003c9c203e9def037f6908e8b9007d7aa5ec456321"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32ad748b5f56244817f289180e54c2498f0b294417aae27daafc1aba342b96b2"
    sha256 cellar: :any,                 x86_64_linux:  "7d1b186b0b8449a7b6ed234a7bb15d04b8e53013c1ed1c8926a9d1c3eaf1c8f6"
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

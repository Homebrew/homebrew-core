class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.93.8.tar.gz"
  sha256 "5ede8393977eac38f634228aaa434135a2d51b868d1ea92037ccf4e039c702e5"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22c0eb66b9040bd5d36570b7f4e0c3891d002f78240e684e149612c1f99a61fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3c28b38dd67b7e3efa5e8f77005bbdf825fe0cf70955d399c9d98fe205a30a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37b48d9eb3f9b5949f1c11a82a1366130cbdeeab191aeaf6dd9961c08f41d09f"
    sha256 cellar: :any_skip_relocation, sonoma:        "717a731b6048e46712ee4e772faf28c6357fb5abee06e0b28d1008e593bd5e46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48cbc7a26cd96d068742a66993fed55f9bb7a8d5d992bdab3a74d693e0774a12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edcbee87a7f1869146ccac107f71a0e0fe7e7646984992968a46aceb29cf92e0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end

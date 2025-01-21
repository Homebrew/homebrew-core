class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.88.2.tar.gz"
  sha256 "33b3ea2423016af3af7a4c98a0e9cf299416553726d35f29726abc4ddbbb3e57"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be0c41edf6db07ca74131c484fc1df4f18adbe00d72bd4faef983926f630ab80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bba3aec18ac5c394215fb93b19ff702ce26a74e62b78f4ee22ff4eb0332bc97f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec8c077c391cae0b2c25dadee0e4c0111a7218c4211818e53dccf0e4d298249b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f28e3ebd4d3a05d768ff82676324f48ed6e15044b476ee53940bff36280b2b73"
    sha256 cellar: :any_skip_relocation, ventura:       "c38510057578bc457d1b8d3673959519c2484c563f4277f2d3567b7dc1caf0ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aec0894222ad905d149034259f09fc98e2c841f8038716c74fa3dcb3b7665f9"
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

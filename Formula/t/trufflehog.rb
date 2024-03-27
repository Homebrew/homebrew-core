class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.71.1.tar.gz"
  sha256 "a105ff5bff78f14249281cf88e793127bcb76798455e38a63df07d4b58d723f1"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bb56c4059075d7854e60e9779b09086c992f8645ca35050fd143c1643da73be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6a13f655844debadc33ad9a8571ac65782ae4c9a4239e044e5846123b61219a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e231396441c012afbf70b646e06b01164e624fe2309e05a189dc09c4036bcd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9eb0da118a98e07ec43dd47bd447677870da38eba944c00443aad222cfd0661a"
    sha256 cellar: :any_skip_relocation, ventura:        "da8f0fd5766f9887f69c5c4be4a4fea3295be1b01491ed8d5830534e4bc4edc6"
    sha256 cellar: :any_skip_relocation, monterey:       "bb5023da8830e233bccae8682925fa195c9af42462892ceb5e755a8fd26c91d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed79d3611d6bd8a8df677f2f0d2c8ad25197effe5c972ed3c3cfdf0c569c7087"
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

class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.59.0.tar.gz"
  sha256 "9f332476a97845e9baeaacffdd907979e3da15084d08f7c4dab207cabcd789d5"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5598de6bf6de5818383f9b717fecbc531d5c7c8dea8303cbb994b684bffa370"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "218a3667ac4f612b4ee6d95fffd3a5140ee72e3bbccb618e3724e6689b6545af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0625786694238d0b708e5a04522bae42ca40d74bc31aea94166fb7663e1818d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "641bc7f2f1870d060c1744f0f39537f8b837d578c9b92d23f8cf08533f0aedfc"
    sha256 cellar: :any_skip_relocation, ventura:        "9bc1cdeb6a4fc99f9f0a83a569583e70482c88d2199212551720303579d4302c"
    sha256 cellar: :any_skip_relocation, monterey:       "1aeb9280c4d4aac59a2c7d57c08fd776df6b3a746418acef3bed27ce146d77c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54d9c8311b4d5a64115bd3b69347065808d8200228d9b02353c35920faa4479f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end

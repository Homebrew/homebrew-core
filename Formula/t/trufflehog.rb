class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.91.1.tar.gz"
  sha256 "9a08be4db31b4887653e7594066ec6478383bdf15c18875049c821cb1cfb8a75"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f07e2c36b71cf8001114b482923c0ede2d460e6f0e3200a7239d0b1c8828739e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c625ebe081ef230eca0af9682c033733f1ddb77c2dfd3c7a8ead397bdd7e673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "091e9afcbcf025a942a2aff6709ae342c3b007246c1700cd1a18916beee21e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d4d855364cc308ee757f7366e19d05f653d5b755a3f6f35062769a40626fba7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a7478fa50b7937ac6de2a51eca5f70cb6e5c7a7b42bf5d7952183f2649d95cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65d47c8df9fbcd769285e414e360810d6cd0279e675909e4990aa507d7600e09"
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

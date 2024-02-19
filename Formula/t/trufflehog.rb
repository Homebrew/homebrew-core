class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.67.6.tar.gz"
  sha256 "a51cbda51fb940a51589a808d0865454a7453fcb7deeb89b822f1f982bc12ab2"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e1d5225a75529dc0068e3f89dfa553878a03610a049d3ca41ff33c7e257d857"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f2fc8f5d34bb41563ddc3f974bed40b1dd4b0c55de1a79978f0d7e8fc7b9552"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f25ecc80829f24244afcf1d1138e95404337208a3cb399f2767d6c311bbd2ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "60c205abf22fe046fab82173e06efd2104826e5549ad9fe3602a7e0911c71e95"
    sha256 cellar: :any_skip_relocation, ventura:        "9165035b79a7705df65bd7717eda015907611d15a3ebda9253e311b4e20f8922"
    sha256 cellar: :any_skip_relocation, monterey:       "ab203aac68ccba4b82df6e650e178f1a362564a5e465f44bd268769874a276c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0bcb8a4d675e4c6e7c46793634249bc33ca92ae918e3853c9bc9adc846dadf7"
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

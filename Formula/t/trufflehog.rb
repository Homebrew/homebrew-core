class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.92.5.tar.gz"
  sha256 "2e88d1eee6abc019737cff5704e2beb0d2e85f1dbb13774c8e7c3af0af66291d"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a076dea9e7392fb09b955dae7c70d47d38be3a064a67ee7b930f9205d31c6590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24148bebc8612b5fd8470d5400fdb1dee41d2544ed5b3478ebf42adc3ea209a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d005d27bd38c6cd6f7ada78f5a5fee61af841cd6f642090bec0ca6b25df1cff"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb5a6c1746bbb14c67103169185fb10da6194df291d021f6114108f4f8663380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "394b3bbb6500666386deecf5000475612ce5cc0a33bdecc7892ab585e1528ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8cd5c649b92eea58bb211db2e37a825c0f39dd2370f930dcc7822d9011bdc84"
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

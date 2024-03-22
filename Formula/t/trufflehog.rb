class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.70.3.tar.gz"
  sha256 "fdf77ab4c2ee068a1cdbd816d22d0ee2477aaac97db4ea44ed82b2eec155f46d"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "834c748e63698ecf6ad72c30c54ed479f80e68d4062ca3355687372385b84968"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b07ed3cbc2854bdc40e01b005a51251091c216a5a37d5b7d6f35d70fd512233e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29227cfe9247cb79341d8dacc5839b7ff7509c6b64f42950264f853a8ac8b255"
    sha256 cellar: :any_skip_relocation, sonoma:         "305143392061c33b6ac842459f7c5b8613d84f741c8d2312fdd5053089beb52c"
    sha256 cellar: :any_skip_relocation, ventura:        "5cc2975818a1cf0d3d1ae8c0ce1d928b4ee4c89b6aefdb22a0f5150432d09ff3"
    sha256 cellar: :any_skip_relocation, monterey:       "c8e9490e1c0f695c4248b84a258c52fd96ed83272114af73879390bdbc77b1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d605fdd282d82ea14b33ce6572119175558bd1269ee08b608a345cf673e9121"
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

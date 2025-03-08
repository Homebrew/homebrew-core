class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.88.15.tar.gz"
  sha256 "240aa463d294d512696d7120e432d7b8acf0a04a425630feb090dd552d4d464b"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf7c91b7b70c3da5115619315ce4b0c5c912a946461644065c4c97189d70f5ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30d13ab2a1299ce151f609ea3769f6e753ebd8ad0a40bd1dc256912d540bb5e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cdc1d4e6c2164dc2061d70d5690163319d29b26587a02c86542638cbc017e4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "674cc5e6942543546233ff750ee786b4fac00cbb531a1514cd10388ea6a3bc7b"
    sha256 cellar: :any_skip_relocation, ventura:       "ab02da0f91538061b54609bd194301253e27808f245fe7fec8039c08404cec7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a73e8818da5ebcc6edee003bf7550bc938ea9f29e6b2a8da1018fc1130c6445a"
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

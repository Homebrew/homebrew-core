class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.88.5.tar.gz"
  sha256 "58bf8e5ce7d4dbbb3aca54d288fbf05d062563108925eb69b77c1f4a786000e9"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b74d082b015fcab1e440158d5c5fb5253eb1da0e4309fbd982ce4f67ce11db81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "408cd8a6a4df2a824dcb4a85a0ed72b114e375306a8ef3545db4d50b516b79a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d40ea6885f01e6cf842ec17c6ef00bbd6c16900bc12818938283b2f7ec7ce510"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf0ff2edffff104cd692b715568d1dc83daa1243d4509497c6210e9625f7eba4"
    sha256 cellar: :any_skip_relocation, ventura:       "12c2ff68c0da211fda08ae1e1b0e039f2cae040b37daa88355d4b1bfda685de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67ba88d898b27292536a7f529f7c42e020f5b6c784e35a8e88b2d4c817efe68d"
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

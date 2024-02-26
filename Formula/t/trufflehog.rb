class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.68.2.tar.gz"
  sha256 "f3dd504742cbe1730cca28be858a1b77c85077c67c3599be3b8a466825413c72"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "615c0b72326db7abd65e5ed3bdb215b4cc8f4c277697af541d44548d524cf14e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "added3aa5af19b6681a134d18d95349c62bd08f80a070207a243be92a188c9b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4fd62ad3944dad97ba22bcd4aee957392908a2555d010579d3b01fd7ba86f59"
    sha256 cellar: :any_skip_relocation, sonoma:         "a969ce154c721b776a9a12dfad0956baaf7f47d62c1c82d93bddeb9213bf4f35"
    sha256 cellar: :any_skip_relocation, ventura:        "bdf06fa6ce7b33be6492a02cdae3b4f9073d4291fb0aec593c8d0d5a29be30e7"
    sha256 cellar: :any_skip_relocation, monterey:       "abb9e8e2b4b87b6f09f38d5da8860ee96359dbad30fb62f76227e503457ffa6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e194c58b9daa0ef4370c7016ced5695c79ee333dcc4e0d01654a46e776b59312"
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

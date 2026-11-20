class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.100.0.tar.gz"
  sha256 "e93728ffd0e9eeecca15ec72f3420810c705b17f15e68cf8940a39e156a99206"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dff0262477c97847aa457bf9f12aa562eae3ff0718b06a74915e30a5269dd9cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a68ef62a7dde5f855edcef5895f616a329ce08ba3c2bb8ebaadf40ef7e13f373"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dfe8f22bca1f0faddf91c68901999dc9dc6071d0d9416db0bfddb2533a9cceb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1573153331f2a978bdd660ae2027134365ff8238e2a6471eaaca1388234d5742"
    sha256 cellar: :any,                 x86_64_linux:      "14029eae9d8782c73a27e12bc20e0e5dcc60c8241a4b4632d8a83e61cf3ab047"
  end

  depends_on "go" => :build

  # `test do` block scans a GitHub repository
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/man/trufflehog.1"
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end

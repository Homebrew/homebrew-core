class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.54.3.tar.gz"
  sha256 "0c42fa716182543e9ee0a784d43fa37d1033b922acbd28feeb25704d3d070170"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4250b539a3be1572a67e27a86041766a246d4e0c9e7e7f70f6e078211aa6ac14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83197d7f356e0d13cebbb9c6caac3d190a6e07dd4d902b0621b2cbea41e126e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6689dd3de5c5e034cd73580bbdb311912e87c9121fb291070f3cc992f9f1b24c"
    sha256 cellar: :any_skip_relocation, ventura:        "97a1f68d2820eb77ceaba3cdae88476eaeb21f05673c6c024661c052f14b70e8"
    sha256 cellar: :any_skip_relocation, monterey:       "7db7c7b86f43b2c3d316ff96d047a81fbf73a5e375cf7833f6104b8c44997596"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a371b871aa32eeccf4c634366b83741a6b872b46549dc1d8cab795f31f9c8d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad8e0acef9198c0d01a57df4d5088eb2922f77c9eb483da02bc2e8622da6a900"
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

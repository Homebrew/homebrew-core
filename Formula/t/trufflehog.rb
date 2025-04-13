class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.88.23.tar.gz"
  sha256 "15c98bf4925ad54da92625b5503b3e1e9d3903f56713877768da8137cb07ac2b"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "991cb612fc39dae95f513a0063466062459b34002c8701c1458103596200a228"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "671c890a683a3672ad4a4e83b76d357ab39c4b49bb1ca98e3f77e37bb8b2ec1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8691b6a52583ccad409b02a67f68939f55b84a47864cd70b1816d2b7b7979e29"
    sha256 cellar: :any_skip_relocation, sonoma:        "02f445678abf13d46161ff0ca0a4c65d3b42359981ca74dee331b99620fcbe89"
    sha256 cellar: :any_skip_relocation, ventura:       "fa97f5a7fb5dfc0bd0f334c3e57dd16b3d81830e4dbf87debee6e246b6b3f4e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26e4d5d190f79b3658c305111cb9b750b073166d07a7a948ed7112b7f39891c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fba919c90b4f83ea06f039a042e19abfe4960aedbf8bab77ba779836dc3a3a35"
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

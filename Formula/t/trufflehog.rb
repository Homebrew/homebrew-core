class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.82.7.tar.gz"
  sha256 "bf2214d6a7cc49cd4fc0b6dbafe534fb7b0e5e947a43ed70290750b95ee9a2ac"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef058300bac72fa0651b80105455e51d9ecb6c81b27b27ea5f8a3b1167751b31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a4476240e7722573e6338e776091e07efe06ad8d7a3e4a93840cc90be69202e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dac07df36c0c886bdfc0dacfc2b7c69b18a43406dc7def93bfa46af99ceecaa8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7158acf2a1878ddd37cf2fa6644389bce1223ff49eeac8a1efd26c25eda48f56"
    sha256 cellar: :any_skip_relocation, ventura:       "e3b5ac2897ab8d8061904006215f68f3ae675aabf97dab81ccf3a994c3b2d48f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca92e9b542ac5f73415fe6365af309582d088126cc85585b4d3a379d0564e3d7"
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

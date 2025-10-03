class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.90.8.tar.gz"
  sha256 "8426a99077fb4b2753755e33328ad9d6690b82ae45c974bd0b02b5a42219605a"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e28d2c8cf293f96f0c0ac747f08d481cf45db4f4312373307707d73307dc808"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8e7b523c0df8328c69f69d13d9c269a231933d9a9b97e3691db65955d5d6261"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0bf073502c1945b29ced2a7d18589f0b1606274be9f692e58784afc95f4825f"
    sha256 cellar: :any_skip_relocation, sonoma:        "625230fbc55e87d9a2048f49b45fce8c14b40644d827ff91888a9187a316662d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1449564d2c79b8602975c324f8e9f3a7ffeb0b75d2c6e6783fb7093501161994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa207cbc72c5771b720ad6885e743d4d2041d75e336c36104a0d4886790315ea"
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

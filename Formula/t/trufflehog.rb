class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.82.8.tar.gz"
  sha256 "9976fadc60a67d1b12c90c2a84e0b212b5cb0db8172eb14fe6ad768aee2e1bcd"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18a3c4a839721671f7a74828ae36746137b2a4cc40ada5da10307f76451859d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59c1902dab315af65ee6ef14bdfa4bb95dad6dd82ce10ad6695aed7e845ce094"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87d0095caf147dc5f83350071ade6094d4fed6ff5ecc9b0842017e8820ec98a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8ca1199e19e8badbdbb0da5edbaf0013c5e022fff95dca74994a39ec61ec855"
    sha256 cellar: :any_skip_relocation, ventura:       "f1fe6bd26a0ca5f06b602aca1dffb94a53e90f72842ef539628be43db5153f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cad61432bac7d6c70b6e02e29cb1702328baed18b9c663207b2776db6f582bd"
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

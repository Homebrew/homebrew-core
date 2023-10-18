class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.60.0.tar.gz"
  sha256 "a38b2932f2f255f80e5c403f48dab453f96bcc280fdcd8c49c878fcad89bc739"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43d97041e249feabaa27c1c1b787ac1ebff722381260d6fd6c0863ba84244087"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4804429d64ab605008de7abb1db6486a336b00dc5c99f993eaa6145a17afaef7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "128fc2f95c895f48dcdef3db34f842dd582d313f4617c477e189542c7ed8fbbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0bf4a1b2cdab41fb700064744e6723796c6630b9b3d71f8f768de6f1ab5a119"
    sha256 cellar: :any_skip_relocation, ventura:        "05a11f8a3a2301f318ad6bc2cda646060e4c1221172c1edb41750a04cb1157df"
    sha256 cellar: :any_skip_relocation, monterey:       "3836d82bc98c450a0150c3018eb0ce3195904a2fbdbf2941fb7c8654bafbdd40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac9aa275a326db6a025074c36a14917231a19bbae7e2a47b9ca474680afc126d"
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

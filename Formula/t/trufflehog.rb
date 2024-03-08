class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.69.0.tar.gz"
  sha256 "e28205d82643cac5525d41b5531292f6a2fdb4b48b96d22e2b5acccb5b567fb3"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4ebc92c6d0de9e72530fb0a147c65fd0f1a89eeb1276111914222c894d1dbea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d9a7fea03e14574b1551cba9613da08d4a32bc9fbd90d4e8a62778b8f508ca1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57e652c5bb45e8070f22b0c5a0fdf7dc737d1927830d64f493b5cc8df47af591"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8dd3d0acab43b7e9420e8e385ad13dc2bf1126598d2288dab90d53c4210b5a4"
    sha256 cellar: :any_skip_relocation, ventura:        "850e2fb9868c832de9b987adef47ba7951b933a0ea237a5a597ce4fbac5e6d67"
    sha256 cellar: :any_skip_relocation, monterey:       "6b5eff4a8979b955cceb0182dba8f6fda854e4f7c68fad0ec7bec13a38646cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4888f0db092d7f582bec5cca09ea85972af9eb7b92888d55a4c59587e99e0600"
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

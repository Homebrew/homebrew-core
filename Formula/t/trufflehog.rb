class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.82.11.tar.gz"
  sha256 "6286a4b08d4fdcfe53ca64fda95e79472dbc76c98db80eb745d11efd32c6a59c"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c01fa673f815f54c6aea4d6af98ebe64a7ffa7ada15c0154213f07e56a0eb44f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94878e466d54fd418a1f39d3d4f291464985b1d522639bfa8aaf023f5750283f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ebdb091ddb235eee0b3977e9d02cfec28fa9002eef9d9e10829d00cad5e990d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd23a7cb88ed2552b8c91e27272797f489d1a52630b004a6576b4b18c408d373"
    sha256 cellar: :any_skip_relocation, ventura:       "0603a137c1343d56a5e16ab24d76975bf58ab74780e8b0faa3ebd1dd4cccc49f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5508d5d18d4a65ecf3f458cd9105116c81ea6ea4e646f1323f6b2a89dedbf78d"
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

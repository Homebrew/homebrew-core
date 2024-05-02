class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.74.0.tar.gz"
  sha256 "975f261a0449224f21bb1556978e45b42fd0aabfda6188318fe0fc5ca24a360e"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c9e4624cf442a95f5fab884c3a749836f276af2457ce93ed81b1b968ba9e934"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bed2e27247065c3b43d79d06aa5ddf05361ae6376e6637fa7645b8523e6fdb7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7d7ba38b4148b25280147359e49572eb29007579cd9e987d4a98b645d5266e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "9de0cb4fae67d63e53a51feb692d6c922e29f15a83a95ff82c1c78dc6f4e2b04"
    sha256 cellar: :any_skip_relocation, ventura:        "d9b02c168606484bdf3b9e755be885056fbfaf698869ca00844e059167a01010"
    sha256 cellar: :any_skip_relocation, monterey:       "7d0fe935ee43e8ead0d9e6ed8fd32eadeb014b056bc0602de12647eadd25bbe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87d75101a39c53178f8367bdae8d8f6175a03aa96c24fafb7f81030cf98e73f4"
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

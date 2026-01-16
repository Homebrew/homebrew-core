class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.92.4.tar.gz"
  sha256 "c99089ee4a0a91155a4fa4c585a95f897492f3580edeb4df2379a2c1695a4f50"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcc91d3886768db1427afa7b201f486007cff9b5422ad7269d351df1db0d0e44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95552c5cce74b568ba731156e11ac009b6542b10b7e0434c8daa56aa79b65904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "786b170dfc89db678b5ffeb4b3d4c5869b621c186345fc86dcdfb45d62cfc2a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "564dd095c8f2bfde8505b7dc7aaf943602048a0540031a0a34f8d314d2e39871"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5915ba0806ea0bc7e36e7759c6e1ecb6fa5aa70119ae86b15a06df176e317c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0a0f6a5cff81002ec96033e01950892fafb136625b6652c05c06800e33eb2bb"
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

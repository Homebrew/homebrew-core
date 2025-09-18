class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.90.6.tar.gz"
  sha256 "ff6ad5db40220f109d86a2840a7c91c59c3342fb4c17fdfedf69b51c611fe7e8"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75a291301b6684c3ea1798ded55a68441beb3b66112043ae9eca69ec36b878df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c2bfcab4509cd4f11e697841ed88ad5a633aafae1b8d9f68af2d1f3730826a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "361932250d3163498173f040e3a4516b9f946dac52515f4d6f3a953ea74b7e2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10a4f225551d7bec6e48ed22c0182654f6fb6ab4ea58c5ab112e8e3f517d9ae2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6658ce293f4e62ff7751398a1ee375634999356cc12e8a85436f283a033e95a2"
    sha256 cellar: :any_skip_relocation, ventura:       "09f0921316b95607c0eb31dbe2d7199691c9f05c8daab02c9071e0d74c607d81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25034df38fa91f49afeee4ddb33f38ce2288e667ff027e35b14ddf1dc1f83f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f217254bc495d0a4af7f3280db7845bcc973153667c477850dd9f57135976b9a"
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

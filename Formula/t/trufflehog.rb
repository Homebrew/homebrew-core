class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.94.0.tar.gz"
  sha256 "92fe798bdde552f289845d146f5083321faa6755ee001d26f981780e79e0ad77"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74f715192837dd06e97ef5e32455f34443dc55564d0c03da4a3f50b009d4c8ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddf8fee328ff01f0295542044835b699060fcc150144190213bc8256f3119b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2443c738e050929d89cd95b7f110cc4cb77453cc17e62213062c5b91275382a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f43bfd24d573f4c876ae1df94f5583cbbe6beca057d52193673c3e864a7d8e5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a1fcf2232c64ada3773f00af1190c4d2da43509cac516dac29518fb99586aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c84bc2110371ca6ebfbcb20f1acdab1d8ba0b92ea7bf9adc726a3633a556a6c"
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

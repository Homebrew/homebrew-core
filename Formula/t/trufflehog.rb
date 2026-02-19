class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.93.3.tar.gz"
  sha256 "58abb20aaab9cbf0a3bb64ef96a1d19c842b87bd10adcff7192dc2440634166d"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68a3d8ff45cb207505f449f27f6cf29e88cfd03641d67fde4013cdda2d02585c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b9a990e61e323ff9256dc7fbbf7aab4a6d8b91f70b9cc51fe2ea74a1d863095"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67a5d76b3bb130fb65c8fa432ee10738d8f51236ba7735f252bed4b25bb078a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbe738f9d2ccf04f624ddfe7e2a9ffbbfbea0d5897a793e0d414b48a86c66e5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e894fec3b286368db660324be50ac75da4973f7b1ef13fadf945d003da54ad02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f77e1ae282e0d18f21a3f7dc0a98b194f50f7f5765ef952153bab7b1418b1801"
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

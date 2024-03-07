class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.68.5.tar.gz"
  sha256 "23c6b4db6afce42a44e3443c137b658610da9ec1c7259c42f602c2eca9816bd1"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc60fc7467014f529b1102671f04d47538066884377824cfc309db0169e4595f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "629c6ececd83ef2983bc114a88665faa9f57cd4474c9e9aa8329418a9cbe2b6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a4e5a26c90e45c788cc067c540d4281e420201f669483bed2406e63bf980ea1"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a841bafe5e6f7b19fdfe2dbad01f81d439daf0b8704113ae0cc4ae2658a09ea"
    sha256 cellar: :any_skip_relocation, ventura:        "1ce1ca4181b2d50bd72a0ba71e8f9e77d216e0d5b961f51e16884672350f400d"
    sha256 cellar: :any_skip_relocation, monterey:       "57a1a4fc0579fcb7a67b54a0b5b5f7f22fea53d0253e9027cc0a7ce964a2a854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86170f42e7774aa9ab81f8278953cdb954e16c2763b0f0db771ef5da4aa7ad6e"
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

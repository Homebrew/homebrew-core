class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.88.25.tar.gz"
  sha256 "84e2d002c7c0f096a2e1e46999b6a71aeda432ad8c58382b681647b937cd402a"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a475cddb2f6e8b93ecffc8fca0f6cc3a0897623fe6e9501bdf15ae1b845a751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da528401846fb4660ba762f95224c425b177dbd891ad11333bb047582b9b2d0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac0c99afe1b0753383739ddd94c698efa929a0e025fce9b44d33f39122e1a7e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "69ee1026ba59c779d8cd58585af1fde494e8f183e774b7cc97ea5d62a7bc06ab"
    sha256 cellar: :any_skip_relocation, ventura:       "f8d18824f503d4b91fe0768963212b9ff2bdcaf096e9d33b5c1f7643a5e8b3f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7582e25de1848e3cfae2356998f38c5466a2f94c3d7549613cb5fdb11cef4be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca6b87d86ffa4cc5039be3783651f9ac5e82d8af1ff13add48bb296e90503dcb"
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

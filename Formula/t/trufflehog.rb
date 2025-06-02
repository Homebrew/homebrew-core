class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.88.35.tar.gz"
  sha256 "8bb9fd4616e13a165f9a881aaea844c3053b565b46b5c59c71e24836e69faab4"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59c8ba7b828d7282b1097350e1be8f386f6fa21453e05f26944d8743e9b94b6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f3415b3f1887f48015bb4e957a8b1a30a23349a4c5d56d30446c629a57ac346"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9758dd5e14e0ccb686f2a31486853c35221f85267ad27988bbb72f6b88edadaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3f0d048c7bda29dde0b3b823aa50b741c453095958af642fbfd482c9e97e5fe"
    sha256 cellar: :any_skip_relocation, ventura:       "cf40dbb9504e10b23f5d09cde79211c570908f81519be5eee304bf06306c3ddd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53d573fcd3f5e589976cd5a276ff165524cfc26fe1d340acdab0040e0a9f4c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89626d4f7ee13de7e62bfdd56aade3f83c6804b5b4fd0a1dc74d924551fa5454"
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

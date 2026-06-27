class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.95.6.tar.gz"
  sha256 "ab9d39c95439b698937aeb5d91427833c9f10424b4cd6174d2af461bcf534414"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2460e5f558f125b42bdbfa9c91d699c6ddd3e6f41bffc71a6cf4a74fa54c80d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "694c75b486ed35995c8bdb22ad279c3f61661ab7a138805b382e020b08cf3ebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96a2bdd426e5c5642244695f37a7563a8a8f726fe05192701182b2a9e6566a0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "479b443400ba8e420d66fb8ef78409f7e5abda5de6c09f8d638c285f06ecb944"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ed6f6b3b207eca249cf2f7993ef4c54be612cbd9846ea19249143d53d1a1a8f"
    sha256 cellar: :any,                 x86_64_linux:  "d69691710caf488d03b066dbfca93f60ffe334108f9aaa75bc651e9f47bebf82"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/man/trufflehog.1"
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end

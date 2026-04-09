class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.94.3.tar.gz"
  sha256 "82858e6d0651e17c5593dc49085d17a519b4cd2aded688314fc20fb7e46c1a69"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "312c658d3e0b0877e4bbd7eb50bf5b06dab467e31706b1b2c19af7c1821d0e4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "831b339c3d66bfb377876fc0bd3f2efb9c31d2a4af9040b4f28e1df202730be3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "135dc04f15152c365a217b832546d5b7b6b9332ed9e1716c7702b16f252fc8aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "49d7158d166b3b2b9f55867df9fe0ce3ecda6366f22870095abea8aa09e1b977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c82167b6e35ca26f385bc6c054feff1518c380e2b249182001de03cb5cc28c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "660d0f673359f4f0b5ee2babb06d233f73eadda97b0cf6b2c0e906f7345b7c11"
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

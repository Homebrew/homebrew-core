class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.78.0.tar.gz"
  sha256 "9fb099d4141b2e5871af4a3857cf05532923e3e24503287c4cfc747dd8cae6a6"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "535c89e25d793526b96e1ddaa5f810c7413fc65bc42ed911e868f8519ad43e4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75c5d6f8caddfb425d0ee8d9168c186a303e5c45fffdcda8d24e638fd61c3a93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4883c76a92872ee8e6379193286994fe709efb0b171b1259e0897e482ca79159"
    sha256 cellar: :any_skip_relocation, sonoma:         "a06e75388c0293e076d506362af7daa546955eaa5d4850928d75aa7508edab42"
    sha256 cellar: :any_skip_relocation, ventura:        "64dae896476a2c3585797916f1494e5186f04c58297c7a9f652e69f98872b3b0"
    sha256 cellar: :any_skip_relocation, monterey:       "5bbf9554877bd91ac3023587970810254a8e9fe375efae9a1bca0a40cca6b38c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1115815707e2fc24e95a3a6a4a2ba3f1c317725b4dc9c351fb7aab1182c94233"
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

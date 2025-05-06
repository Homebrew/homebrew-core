class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.88.28.tar.gz"
  sha256 "b3d6d0d49d9145743b50c56cad7376192e94e9d4a523aa5decb0c84c13faa3bb"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7216a3749eb0b7f89958981fc72f2892afe743e58d36c1193b441d24ceff13d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89369f52f0b833147b9a06b49f2a7f372b0627d1f7ae72c29c5bb320e41d23f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e81976b50f2945b90fae4418266449fceb6fc8f47ee3397f48db78d07558444c"
    sha256 cellar: :any_skip_relocation, sonoma:        "008855b7ef83a653e888e18ac785da6966ad518dc51ba0dc3ec562f2e723e905"
    sha256 cellar: :any_skip_relocation, ventura:       "9b9d2852220ac51123adab0663e0601b1a3f348f2bc3e50416893ff034f65116"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fd9c3c90443b7b5fdbecab633089bad640c5b1d16667981d1f2e11f20e40344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "441bbfc73f7287253a6413c05ccea5fd65d445e89ee45f16982df2876cce7ab8"
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

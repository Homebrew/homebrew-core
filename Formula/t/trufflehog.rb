class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.70.0.tar.gz"
  sha256 "e1ee1791de7891b97c90ebfab4cfd6df86de589f6884f6c662c3768a2ca3c396"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0d7b790f614bfee087a9311f94fe92bf70e225859072a682c24ac865fb576a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2af4d0895a9b0db85a784d26b911871927754ea2751513df36fd6d08c75fcbef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bfbe5ef4b5bd19e97fa1eab060b22aa5d0f168648c9c6f8c6eec21b3d884683"
    sha256 cellar: :any_skip_relocation, sonoma:         "b105231b24cc1d648616a357f4bd96fe4001ab12e547ad0dff652ce4fba9a03b"
    sha256 cellar: :any_skip_relocation, ventura:        "3707c926f11e29d49c9f1c9768945062166e5489fb8d3b9b577062e989ec7906"
    sha256 cellar: :any_skip_relocation, monterey:       "eb7362cc9682a7d362e839a5ccfb743f9593bb93768c20441faa6778cdeb293a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb1e77bb1f8adbb5112fe6471a5a72258ec87f091539422aa2b0ca91ce84c0fc"
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

class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.54.4.tar.gz"
  sha256 "24adc4b491e2ba4f9ec404b66abae9cfa9bf4617451d95d443e6b36b89484e02"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "653dc4cd6334a58c71c181cefedd0d3977c2c4c343115e36e00fb2537613dea2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaa1a116fc75e3cfeaa1a7a7dc3f287fe90e929097a167916fd552abc39624fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd7dd8dfe12ddf4548e14466ebdd5f60416f668b6b4cd945b59c27f1c1fc910c"
    sha256 cellar: :any_skip_relocation, ventura:        "297505638450c5b119104480f4db9982b3bb176fc5e4223047b0b732e6b21129"
    sha256 cellar: :any_skip_relocation, monterey:       "3bd2d8df8dec37532b0082c9df9361fb3fd7828d5617a95e8a3df4d3b08a9c84"
    sha256 cellar: :any_skip_relocation, big_sur:        "722153fec166d47244f138b0a910031c3ff9ba52a98afedb06d102c40fa7912b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ab9ebb747d49e925128b1decacbf29edca57d4639ef8b7b181aa1972f529520"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end

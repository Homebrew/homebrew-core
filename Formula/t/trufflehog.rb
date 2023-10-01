class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.57.0.tar.gz"
  sha256 "3c0882642a11b9e37cd7cdcb76a1e5ac55c29bafb6b256f5654b9941fbeb24d4"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de12e478a0c5049b48ffe34a1ce177eca9d569362c66d687d39459bcdc5cab64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b128973e5c9d0632ad87f7739dd07dc24a57c2573a09fa3390601141bb9464ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7a1a354375db967078d9fdb143fe44e5588392903cc4a78b750e7317e6e6a22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8577cc96b1770c0eede06453d2beabd91b8ae48a87dbde1ee45e55a6820ee3a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "e46ec6b79744aa578be7df476d1670add1a8ca269038baf52943eb486e07c405"
    sha256 cellar: :any_skip_relocation, ventura:        "865803054e9d57ce6b3df0f4a0417d8dc973d1c44bbd3a87a17a365651923cd3"
    sha256 cellar: :any_skip_relocation, monterey:       "bbc68e13745ef893fa529ce830e5eb700aa066878dd8e0781fd3587ff86f9737"
    sha256 cellar: :any_skip_relocation, big_sur:        "0209990609a89eca70ae7b21b92779c84fc1f6d88c1a83fb5317951012d7f3db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2772cfa05a64b299aaee01cba83d3d364e786b5f9ea7df6b1ca7a514f4d4a33b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
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

class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.71.1.tar.gz"
  sha256 "a105ff5bff78f14249281cf88e793127bcb76798455e38a63df07d4b58d723f1"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e5e75acb62ee3219e2ed6e70c73c02aece93c9dc86d1fe4619c830789aa059f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07161271da56d3b637c243e9b94f492229d452ae29dc65df13231f159cc388ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "742659c5df45815d21e5c02d541ffc2a3193b4cb409761f22191a305c7235856"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe1a10b38542d3d11edac354330539e0a10d285530afb8aa11e99bd5b4fb0691"
    sha256 cellar: :any_skip_relocation, ventura:        "13ec1f57640ff614030bb25bf50bff1788552771b494e298cd5b5e19003b9435"
    sha256 cellar: :any_skip_relocation, monterey:       "2537c69438aa13f9442d1a59f03b7b91cab12f1ee66414860e75407b647b323b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bf73d706714d1c12749443cf54910bf23d2482ffdfa6fae67ba67e9c976cacf"
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

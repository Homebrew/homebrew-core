class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.78.1.tar.gz"
  sha256 "23c47401ddf60e0bc9d44291fa741ae71f27471dd9283ae567d804992995954c"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0449233ec5e528a2b434469ed977c3120dbe48eeb132955b472f7e3a23ade7c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c069260cc3ec323f3401f3643952fb308137de8226974169ed56d465645c981"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cda061718f7532058bd2d8420de7c208c682517fee8cb9ced4b3662c55c1b75"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4ddf3a626955a8875722d2906a233f51b05fbfe949294e3a35c6c7fde077253"
    sha256 cellar: :any_skip_relocation, ventura:        "f3fcf54c6eddda1ec718c9c0b4c1ba9aa43da89b2f3d3f20300827f12755fd88"
    sha256 cellar: :any_skip_relocation, monterey:       "6b31cd7e141483eee0c5f03f4233697215e4b47bfc802953f8d0386879cd7bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "518c0d0b8e6787cdb2df4a40e2063e940234514bf3ffb70bb80f2f4ffb5b99d8"
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

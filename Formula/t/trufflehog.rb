class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.81.9.tar.gz"
  sha256 "0f03dcc35a2c89c7a10f55033fb05097bf87b4738ea9e92603e453a38ddb2035"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a1a391ac4997f82e7d044c747b0d3432e7262a07b04e844506cd4ce9761f1b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32e184a1f013225818688e6acfdb693c3fa5dad496ce4f78dcee1701cb6e814b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a39e9f47a725ab200041afc843fb99504567d3fee0e150c7acb045e490274b88"
    sha256 cellar: :any_skip_relocation, sonoma:         "33b3ce197113cb4caff4b89c0186b98ab788aec5ff8514db4a106ecd17c7de53"
    sha256 cellar: :any_skip_relocation, ventura:        "9c3f156e9367cefd103933c65e45189c1968d7f2667eb1d80edc93d1c98005c9"
    sha256 cellar: :any_skip_relocation, monterey:       "c79b07c0dab6038cd7923e060a72980ac892279213235da026469ae51e003493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a484e449e6f810b46fcb56c182db3fc0da42b1506824dff017f25fb609e6748"
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

class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.96.0.tar.gz"
  sha256 "f5b01224d4f43a5b3e5614d1fb3d53b3286fe5481b076bb059c42db0dec5adf8"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a3ef092a849a8a8f5b988c18df0b585945d439d00ca105410cf48b17a71b718"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0478eee3ff8b704fa514990ffb6a0d43cfe4d2e089b949cc5dd290589c272c49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c2322d1e505db50b993b7517a2b8489025cee4ffec20d0d4e85105a89c4b9e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8630c028cbf5375448d1d092ecae988dc6c630db4f32b7677ae6569dfa0069de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33406011f44d928a8f3f3df830a2821018cf46d0565f401e0f6e8643ef6b5297"
    sha256 cellar: :any,                 x86_64_linux:  "c388a7093d8ad347bf62ef29fcb67023000917472731d178950802c471af20a9"
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

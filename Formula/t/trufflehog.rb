class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.70.1.tar.gz"
  sha256 "910b95cf8db124dd70e7ded6da8f145e2ad10c3bb7b00f5968465e8510cb8566"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19ed65eb92357d0f205e84aa5849479e7f5542a3955466c06c8ca1d44a04950b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c15ddaa60cbdf4a82b4da2d06bf889768a8ae7cd284b8ad46d49c99d788298e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d5912ef64da12423bc781fd1a4c520716abcc3b56d5d72e6d8f7bf97bd30b6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2161bf08422009bddd93a739884ea91e7bb3fef5e452ff4368ec14de912ef52"
    sha256 cellar: :any_skip_relocation, ventura:        "1951939a81d484cbb3038a65eb2c0977f7f72ad096b624d5d3bb54ad6d907c34"
    sha256 cellar: :any_skip_relocation, monterey:       "1754cb49218dfd45af1b757542544070d5e8e4ed106fead5fe0f4d95bbd2454d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beb866c277d4b24df6f2b9345c07ded431cf7ae20f2b41ecb565b09c1f44bbb0"
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

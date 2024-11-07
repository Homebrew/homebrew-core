class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.83.4.tar.gz"
  sha256 "3d51364dee5cadee68268e221d123b29d57c06ca5b7450bcf3c5624325516501"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb49b6e577d8ea1246399b3e493b42cdebaedcea559e66d553d133703aacde91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e19ba0ace91e0d875b9d188bd8ed984864b261391b67e74af08ddffeab67c22e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27623a87bee20fb4855f5f4d02cfbdcc5fa68b7f3626095f16d1833cfd959f84"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d1245683b138cec9ebe43affbec89c958e81a483f52b0b0f606afa1121b2d8b"
    sha256 cellar: :any_skip_relocation, ventura:       "c84df20e406c60063c15572f36e41716dd881bee390af1bf0e91fd8e29c0db88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "394941198147e2e27cbfe40c6bb9d53829673191b6331d0ebb4a83d1889926ca"
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

class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.73.0.tar.gz"
  sha256 "e389d90df6a58cdac71258a5c1348e50d4340ba13ec9ca486d9a168b0edee10c"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0481eead589307186843dc8145f491b40c19e213ca4e8414feff51c5f5a05916"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63bb948028c6e1331853fb89d40058a769d7a38a4e2a963a6ee9c9e841d3ed77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee07cf152550923a5b8f1a4cd2af02f9db8b61f1010b853c01b16f4a8396b20c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1d484e384523f113effa66f6c6c184cd20678b89fa9a469a92c123527b6615f"
    sha256 cellar: :any_skip_relocation, ventura:        "5f3f7acc2fec3aea3eb15f974d346f7e9dda8729b64705163b06ecfc49d4eee3"
    sha256 cellar: :any_skip_relocation, monterey:       "18e60cb70f1671aa8bd6b8b0f5f57aa33c68c5a42d0b2a4fb890812f1afe86a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34dd402d032c594e77e09103b71f11a32ab88b4e1bd89747463a091d5f6f5bbc"
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

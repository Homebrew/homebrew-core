class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.89.2.tar.gz"
  sha256 "2971a31e08c28bbaf7eb4b511cd516a452a179f0eb356ff574dc2cc8d474fba8"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42cbcefb6de3addc28f956cc6747e70f656155f48ae2a82eb5b782ea163aa804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45cbf178238541ca678f4165217a3d3f4a36039a89c917dd21da7bf9374e58d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12719776429952090fd0d7e3c7d6d3c5de7b996d39313fdcaf4915b347ce155a"
    sha256 cellar: :any_skip_relocation, sonoma:        "139dc6ff8aca35f1d5bb1e9bc78f72f543bca02fbf2e2b134c8c9d2c7eb8e14d"
    sha256 cellar: :any_skip_relocation, ventura:       "ccf765ae3d97b6baa3c40b609967ff3ced40be1b691d410583b353767c58c96e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb8474f1d11d53cdc3e393bc803b76b4d586fcd3465cd0be33f8e3c6e80ce5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d73a309a105dcf61188415efbd9a32d9827c40f820ebb2408366d97cef34fa5"
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

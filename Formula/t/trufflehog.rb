class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.62.1.tar.gz"
  sha256 "4c19fc53e3351a2b4bd1559c087cf951862d11ce5c89b0b748e75d7594da3f62"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d67d7476864cedaa95505c7b12e68da7d0f2ff568db505df5dbdb2bb36067001"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73b651107a1ec9b259667e4f5cf7cdc7b2663f1c41760bc5d01ad80147e8ab0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88863212341b4ee432822eaf308f8853e137024126c01cc70a6a817c5f26db1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e185226afbec64a1cafcba1163ac65f9d58f824649f30452fd2a1698d2a9f29"
    sha256 cellar: :any_skip_relocation, ventura:        "d8d6dc0109e6bb4ba8be36a0ac49526e8389fa54737cbb39058a7bcbe3f18af1"
    sha256 cellar: :any_skip_relocation, monterey:       "db0678367a05cbb259844620cafcdc926cb3e94bd4d3d2e9d1759d9268411c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd9bfaec526f661272991ce3e25570c3bf309db18a12d15ce1985570f4dd4d23"
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

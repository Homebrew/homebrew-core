class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.99.8.tar.gz"
  sha256 "c6b7ca37d8ce7fe03baeb129b2ab75021c44ab65a80241860a2872e0f232ccfe"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c054097aa945f98ddd0c2424a5a117b79ea24425770242813fd28a676bc96c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dbdfe34ec2afa4b801eb6334c02a82889cf06dedaaf1e5c8b213d3ec076d88b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fcdf09f4f7f60e352bd24648cf3ce86455afcf7542bd14de9de015ba262226c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2a9164653750435443884c0e861413cc566dedc41232e12398228dd584ec812d"
    sha256 cellar: :any,                 x86_64_linux:      "c310f2301be79197294fe2b3931ffa530e92e1a3a997161132f4b48ae1e0fb2d"
  end

  depends_on "go" => :build

  # `test do` block scans a GitHub repository
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
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

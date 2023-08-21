class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.52.1.tar.gz"
  sha256 "a8a872942d483e1ca31cee83c2426dc9080216c2089d2b0fe5a1d77e0e11f7d8"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98049053efc505db4ef485509c694576d8201b1d6203f6b7fc1d764bd2555437"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba655bd3ffe1107848795a1bf4cbcc28e80d099580ee7c1fda8bfff9ed5b1814"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "372f17635d5eca566208062e09e15849ac8eb435a5c59bef706e161666900e60"
    sha256 cellar: :any_skip_relocation, ventura:        "9245db68f517d2c014af295eb515707b097025a981e0d07bd3baf8c32675c813"
    sha256 cellar: :any_skip_relocation, monterey:       "48ce8dc5123d31a287e24c8c02776d5e97fabc54bb4d224a04b29c9e48962a73"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac722d3515d015d10795c3c94a38420e99417387b93d35c82dd80ec07094eea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80b8376e967f810f4da6e245e075e3dcd002f1ca3af23e252cd58d55602a8b99"
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

class Rdap < Formula
  desc "Command-line client for the Registration Data Access Protocol"
  homepage "https://www.openrdap.org"
  url "https://github.com/openrdap/rdap/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "e2a41901fb1497412e0391338af5b7673fac24127fe5080c0e60c8bb5cae961e"
  license "MIT"
  head "https://github.com/openrdap/rdap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "838b7368aa323d4403817a7a0ce1b2004cf9b570f6f49ba7cdf11bae5b676d65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "838b7368aa323d4403817a7a0ce1b2004cf9b570f6f49ba7cdf11bae5b676d65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "838b7368aa323d4403817a7a0ce1b2004cf9b570f6f49ba7cdf11bae5b676d65"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c3ebbdfa3cd18f97b1f22fec61750713bf960c1cd6000b1ca14703b6e2ef6c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6cd3491a383d171f2bbc3652f6b78d2fb2667d014c4a6762e336d36ebf2aa49"
    sha256 cellar: :any,                 x86_64_linux:  "76ac14d767a573a2b6afe0315a20b21eb22f1486982c5243bc454277d52f8efc"
  end

  depends_on "go" => :build

  conflicts_with "icann-rdap", because: "icann-rdap also ships a rdap binary"

  def install
    ldflags = %W[
      -s -w
      -X github.com/openrdap/rdap.releaseVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/rdap"
  end

  test do
    # check version
    assert_match version.to_s, shell_output("#{bin}/rdap --help 2>&1", 1)

    # no localhost rdap server
    assert_match "No RDAP servers found for", shell_output("#{bin}/rdap -t ip 127.0.0.1 2>&1", 1)

    # check github.com domain on rdap
    output = shell_output("#{bin}/rdap github.com")
    assert_match "Domain Name: GITHUB.COM", output
    assert_match "Nameserver:", output
  end
end

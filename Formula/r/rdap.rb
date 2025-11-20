class Rdap < Formula
  desc "Command-line client for the Registration Data Access Protocol"
  homepage "https://www.openrdap.org"
  url "https://github.com/openrdap/rdap/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "06a330a9e7d87d89274a0bcedc5852b9f6a4df81baec438fdb6156f49068996d"
  license "MIT"
  head "https://github.com/openrdap/rdap.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82be0fc5e32749b77743087bf6b5b6a62a61454b1891316e419242bcfaf9e6dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a73abdb1f73b15293ec718621dc35982af08454db08a899d6ddcf2f279eac55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a73abdb1f73b15293ec718621dc35982af08454db08a899d6ddcf2f279eac55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a73abdb1f73b15293ec718621dc35982af08454db08a899d6ddcf2f279eac55"
    sha256 cellar: :any_skip_relocation, sonoma:        "6941798ba46a5391886ce266bfb1c4b5bfeb9db8eb9cf11c33741256f0405784"
    sha256 cellar: :any_skip_relocation, ventura:       "6941798ba46a5391886ce266bfb1c4b5bfeb9db8eb9cf11c33741256f0405784"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b7d525df05bcaa24b18f462587052208ff5456170bc1d45f405f0b0667649a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d791f01848f4e8c654a1174e55a1118d8f0ac743962bba87ec7350c81e027f58"
  end

  depends_on "go" => :build

  conflicts_with "icann-rdap", because: "icann-rdap also ships a rdap binary"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/rdap"
  end

  test do
    # check version
    assert_match "OpenRDAP v#{version}", shell_output("#{bin}/rdap --help 2>&1", 1)

    # no localhost rdap server
    assert_match "No RDAP servers found for", shell_output("#{bin}/rdap -t ip 127.0.0.1 2>&1", 1)

    # check github.com domain on rdap
    output = shell_output("#{bin}/rdap github.com")
    assert_match "Domain Name: GITHUB.COM", output
    assert_match "Nameserver:", output
  end
end

class Range2cidr < Formula
  desc "Converts IP ranges to CIDRs"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/refs/tags/range2cidr-3.3.4.tar.gz"
  sha256 "003fccb293c9ff8ee42494e7ab07f3be8f9f7e4745ab848e529cac9f89cf3a71"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^range2cidr[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf311bec29e8f58692a4b1dd01ebb667fddc281f00d4b0974836f4e6d787d7fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf311bec29e8f58692a4b1dd01ebb667fddc281f00d4b0974836f4e6d787d7fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf311bec29e8f58692a4b1dd01ebb667fddc281f00d4b0974836f4e6d787d7fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2c26d810c4f6d078b0d0bef07c25acf5949ba5ffc09f3da5ae9e86a49c19f65f"
    sha256 cellar: :any,                 x86_64_linux:      "67939934e2d010c9cf51e3d682052b9cc717b1d2d710268f67b4e4fcbaec0eb9"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args, "./range2cidr"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/range2cidr --version").chomp
    assert_equal "1.1.1.0/30", shell_output("#{bin}/range2cidr 1.1.1.0-1.1.1.3").chomp
    assert_equal "0.0.0.0/0", shell_output("#{bin}/range2cidr 0.0.0.0-255.255.255.255").chomp
    assert_equal "1.1.1.0/31\n1.1.1.2/32", shell_output("#{bin}/range2cidr 1.1.1.0-1.1.1.2").chomp
  end
end

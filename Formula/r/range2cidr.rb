class Range2cidr < Formula
  desc "Converts IP ranges to CIDRs"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/refs/tags/range2cidr-3.3.3.tar.gz"
  sha256 "bcf717e779d72f5b1ee01d808d6c86dfa5d9431ab786391c103a19cf3753948d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^range2cidr[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "194205c3710533b5bd5313166172d32f749325d1bcd2551c5bf4d9d341594051"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "194205c3710533b5bd5313166172d32f749325d1bcd2551c5bf4d9d341594051"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "194205c3710533b5bd5313166172d32f749325d1bcd2551c5bf4d9d341594051"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b2eba04f51dc44309e0bba1d2948149a22187902322c37cad670ea8e26c991e1"
    sha256 cellar: :any,                 x86_64_linux:      "a0012abfebcd97ec4e4900fbda3bb10b007a392dce1ff09c61d4da17a3c28f55"
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

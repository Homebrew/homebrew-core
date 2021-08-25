class Range2cidr < Formula
  desc "Converts IP ranges to CIDRs"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/range2cidr-1.1.0.tar.gz"
  sha256 "f6c675a43e356aecdd9c7ddc80a5515b7faa3f350d392b283e556f14e042e552"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^range2cidr[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "84f804ee0e273b43a2ab5f5ddfdf784d0d40adf70cd5e2e2a54c078367d4c988"
    sha256 cellar: :any_skip_relocation, big_sur:       "d0929cb100f4231eccecbcfd4fca28ca4d33b5a3716fc189f324d0d18ef15577"
    sha256 cellar: :any_skip_relocation, catalina:      "9c66fd4205c37c095c6b6bc210a05e0e12e26d9ba5109ece1c582f45fcfbc498"
    sha256 cellar: :any_skip_relocation, mojave:        "41474eee16220c65d5e0242212d83eb7465d5b82216fb524a1cda3af51657e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ff0dd89076375bbc222e400eeeddff9a50c7f3c5d36ada8bba0c5a76bb6aacb"
  end

  depends_on "go" => :build

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

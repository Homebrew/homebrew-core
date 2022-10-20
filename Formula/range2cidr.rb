class Range2cidr < Formula
  desc "Converts IP ranges to CIDRs"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/range2cidr-1.3.0.tar.gz"
  sha256 "562f130483c8c7b2d376f8b0325392136f53e74912c879fae0677ffe46299738"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^range2cidr[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb9471b5f9b4ea6abefb2a8a3b0ee68125098c66565efb77385e5a5e1a46bbbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5514b7e035bfdde163594f595f5e776ac8dd998dbdf548d892be91abf06a0ddd"
    sha256 cellar: :any_skip_relocation, monterey:       "7559ea0525e6feaecdc50a741185765d4991dbc34c4c57d4a7b0121a4c9f9647"
    sha256 cellar: :any_skip_relocation, big_sur:        "2103581c5d4bdbac9d5c4e046f2f4344afa65ec6320151a2af2606d4a7a3e617"
    sha256 cellar: :any_skip_relocation, catalina:       "41ed80ac028658ced43c8973c7c29c81fe159347ce885c24384df915157d91e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "738f9617ee60fef2ec1f30930b45dfc633d4f65ccdb97659d9d311aa52eb9c2a"
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

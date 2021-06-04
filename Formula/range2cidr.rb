class Range2cidr < Formula
  desc "Converts IP ranges to CIDRs"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/range2cidr-1.0.0.tar.gz"
  sha256 "caf6627b361ce690a884ccbb98c229d07dcf73e453af625638b7508113e1b0df"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^range2cidr[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5afa2bd9b03bf007db38f7dca0b129b0d2094a4309ce983aeb855e0a784119c7"
    sha256 cellar: :any_skip_relocation, big_sur:       "543dde8b3d0ef72d2884e13891a46dda2a9492dc601159efb41380960ebcc054"
    sha256 cellar: :any_skip_relocation, catalina:      "2c506624fce0d1edf09071016fa5ad6f3860e8e9673f6d4145edcfee7e5c72f5"
    sha256 cellar: :any_skip_relocation, mojave:        "80bc3497649b621d76f27936cf58b33be3371efbf3f38dbff8ccaeff76c5e3dc"
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

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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e127a68304f8b8e208737c8ef97bdf2e2dce5d5b3ea5d4301062af1e22469a34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "024a1c6bd1d92485294167841f2a759e81cebe9b8fa01bfeda80f0bdc67cb2d9"
    sha256 cellar: :any_skip_relocation, monterey:       "0b98f35120292388621f6eb0624f29737b7d7a2dcff69f55237a20a0e0528c8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d41f8110dfa793fcf9153189b0b17378c3f1d1642368dada9f4e24664ea4f091"
    sha256 cellar: :any_skip_relocation, catalina:       "3fac741b33aa88ade3a7c70079ff37d39f5c4b92805ecd9788f90a825dba477a"
    sha256 cellar: :any_skip_relocation, mojave:         "f2921d9d6d951805a393ef75579f592a7c3045f7ebc97ec705b5050237a34d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46cb996a59e10f7324b40eb822b8adf0e8113f85180b7769fc62a3b828d2f4d7"
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

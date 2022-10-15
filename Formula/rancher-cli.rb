class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.6.9.tar.gz"
  sha256 "96117167845c00808332ad770ea5eba8859b13d947f925ff93af2cd4026288c2"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5234d5c89f6d7bb2fa71df0eb108039f7de1b4a90a7b991f8162c79dc4655e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aef23a2a61faadbc9573f9ae21464a1f41f05a4521d2adb61d82a053834c3b47"
    sha256 cellar: :any_skip_relocation, monterey:       "19e66a2574024cdbfde0f95a5d5504792af9a29c8a85c5e9f5ce5e951c59cad1"
    sha256 cellar: :any_skip_relocation, big_sur:        "628f687b0f414a52655760df091ffb5db1b15a6e06fbff2258b6716958ede882"
    sha256 cellar: :any_skip_relocation, catalina:       "6c6788da6e3f2dda04d4f2360f76d917bf4a999ff1941cad3fc893c21ab8ea33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95a3142a03597d384770ded51547b63f8ad908275c26b306323fe4fa41204f31"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "-o", bin/"rancher"
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end

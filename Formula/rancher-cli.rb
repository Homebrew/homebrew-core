class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.6.4.tar.gz"
  sha256 "9b9eaeabcfdad7b4f47dd558f104db3cc50407743a87ffa57233091ccb759278"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b397d2ad74522057780cc9b13ff34a659f88be1cbdc3cf317f6525412d6844c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26fa0a39de61895d4cd5605115d13cdf107d50b295c66389d0677b65d86c82d9"
    sha256 cellar: :any_skip_relocation, monterey:       "8d9e68b84185c5d84dc29f08e6abbe8634211376008105e538b7cc19c994d9f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "33a3f0c8a3ec2c4afc7214a8e8436af6d8359a503892935b4f57b60fce49b49a"
    sha256 cellar: :any_skip_relocation, catalina:       "409f6e114c3dcabbe8a02fac709ece676537419a4327c7cfb8734a87ad57814c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74f4ad722b06ee9209a9a8304cc941de7ad7452cc32dc99a338114fbe8a94414"
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

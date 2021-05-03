class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.4.11.tar.gz"
  sha256 "c16d552bf07d45c3eaf3d3290fcca2e6c5aaacf4aaa82491a01832b5ea2506ea"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c622dca7979bbed7ab4213d794200a8aa9eac0bd8ae6991b08e2636f5c974b4a"
    sha256 cellar: :any_skip_relocation, big_sur:       "9573b4250d11f974d15afc78deabc07d8516d053a77d3311411c46f3ef648ab1"
    sha256 cellar: :any_skip_relocation, catalina:      "7892f574ed7975505315c87cbffb13101f3da5a4763a1e9ac2fcc7fc951e8f1b"
    sha256 cellar: :any_skip_relocation, mojave:        "c5cbcad2b1f0ec6f179d23b3e4bb5dda5beb6868091ee702ce0ae8ce57400888"
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

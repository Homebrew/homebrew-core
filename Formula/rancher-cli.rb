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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd57269ac33e17ddbf907d18ef7ef177800689bf4790c48e83d56d6652d9104e"
    sha256 cellar: :any_skip_relocation, big_sur:       "edfa744550563d18207ef12d174131f7ba0486711bd7ccb252f12850efd2ae81"
    sha256 cellar: :any_skip_relocation, catalina:      "bfb880e1663556643a7d6c687e2d0d51fefe1ed36163d66d42274046d80f1862"
    sha256 cellar: :any_skip_relocation, mojave:        "ec162d2372ff7bbc244d2785e33b849fbd4773f37322b586bcc20f2aa9ad08a3"
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

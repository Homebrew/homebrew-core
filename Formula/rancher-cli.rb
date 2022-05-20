class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.6.5.tar.gz"
  sha256 "fd55429e52ffe645438347ba5b9fe6962bfedc1cd40285c7b365a0cad69f1fb5"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0225466c88e4867a729e322ee6a7a49f1da83c779dfe0b28eb51b15ae2e6aa5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d64d36c29eace79927b96420fab9661ce9fd2980ab0483c31064a1fc8f612a9"
    sha256 cellar: :any_skip_relocation, monterey:       "93c8b3e25e64ac2cda6077e370f48455f1c870b33ac24c20e9ee36a178bcb0d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a4e9b7ba18f350c72f60898bd1b1b58c4eaa8dc08adb0c2c15ff9a4c4260f3d"
    sha256 cellar: :any_skip_relocation, catalina:       "17e024d06a0db93557545eb45cdf9d7cb36c808b73ccdf069e61639395e5db31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "171d33bed64a5a17f0212c5a01d4454f8f217d13e46e7f65c3181f27bfcaec39"
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

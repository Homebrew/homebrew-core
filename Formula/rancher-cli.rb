class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.4.12.tar.gz"
  sha256 "7fb2fb7d8e210198b0829de169ccec1ba882c872ec8cd28ae905ab4460e94fc7"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81f0d67c3cc237d67246ed1e0b9f74c25365e907e45f272fa642d012170657df"
    sha256 cellar: :any_skip_relocation, big_sur:       "6579774482291cf6fc8bb1bdae68335e248e4ce2a35c858645f1d7e86164731e"
    sha256 cellar: :any_skip_relocation, catalina:      "02ad8e0cf289919361a10c7021d8b730d447753a2a2aa5ed2605da10047021ca"
    sha256 cellar: :any_skip_relocation, mojave:        "3241f896a3d9d31be2053ccbdfccb1d6e817318c65a6c17008dd0042f37de2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a7812410b2f76b8d5a9df9cefb53a8b0db2feb37de6fce3758416a6aab79d9e"
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

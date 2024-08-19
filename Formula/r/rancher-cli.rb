class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "67b92c0830af800932fbe14d9591b6e7ec21a50abfadadf998251b3535b75bfc"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a17f5922676ef886a3f1a764705f840e35c93a3a9850c133adc494c5ef884555"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44779f012d02a8ad86f341e5004e167578d2477e4b369e2e62933be2f22affea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c37309dab7c184b464acfed0a38a61f65690f8cc1850a048c9388db5bc70f67a"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf76783bbd939335685bc7862fbcc1f380fc9f5a5ee9e2fc1d9db17c52ea5bc1"
    sha256 cellar: :any_skip_relocation, ventura:        "aef58a007aae79c266ea8a1439250c06868f6192ade61c62642ac429a55e7d77"
    sha256 cellar: :any_skip_relocation, monterey:       "56f556a0467afff1b8bb431fb5d020e46c1a6c0c4579cf9796d9b9742352c072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ffc5534f3ca5f95737b04b666f20a71d79410c84cd7b7cd764281fc23ce4948"
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

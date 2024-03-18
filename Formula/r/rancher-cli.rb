class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "bb1e7f1eb43d90789a7330e88dbe39599f306ab97632e4dd2951bd107f96c9b2"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8459150bb607655eefdfa2e17f926292d5e58730846671d1121a2288948afc59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "679088ad53e86d16ab183157f49a1a62f5aa98db139745650c50f0d3543ca080"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c880e8970ad40292173048b68439443cd167c46a9aa638ddccab2d6ca47753b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a2f56cab84f343f0afa1a5692831a6e49eb2f094d7021dc77633681c788e0c7"
    sha256 cellar: :any_skip_relocation, ventura:        "5e2ea3106bb73ecc2e557b7a319516ac80de5edeba9cadfccd5c9d4ce38d783c"
    sha256 cellar: :any_skip_relocation, monterey:       "637fc787d54b0f1f8b3a9c25d1fe3ec93fe459d1d3810c8e4eea14ce7e4e21a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "223323e621d6ed474e94a774df32eef57d13d188a78d135490f28358e34440ee"
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

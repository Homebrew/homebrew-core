class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.4.6.tar.gz"
  sha256 "4dc8399c3cd5a10dfc89ca71b622308b7c03a268eae0a4da35d1f39988fbddc5"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git"

  livecheck do
    url "https://github.com/rancher/cli/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "949cbf3440dffdf14e161139aff69e2966d68719174e43a68b4c3e6e44d7df8b" => :catalina
    sha256 "1ca2b69dcd809539276bab69e5c90047450e93dcf96189aacaa440522d8041ff" => :mojave
    sha256 "ab95e21dde075606e7c519fac0501e990f762db03a55323654d5d86f046f5816" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags",
           "-w -X main.VERSION=#{version}",
           "-trimpath", "-o", bin/"rancher"
  end

  test do
    assert_match "Failed to parse SERVERURL", shell_output("#{bin}/rancher login localhost -t foo 2>&1", 1)
    assert_match "invalid token", shell_output("#{bin}/rancher login https://127.0.0.1 -t foo 2>&1", 1)
  end
end

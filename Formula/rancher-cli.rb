class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.4.8.tar.gz"
  sha256 "c5e73095a2eb6a485785a466e120697b3cc9071f2f2a695f6ebf1ce0a22de5da"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git"

  livecheck do
    url "https://github.com/rancher/cli/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9dcae93136d9f79a102ab1d7acd3da9d7ea51302150dfb63aecbc39a8232825e" => :catalina
    sha256 "cea838a7d939f24f60f98df61d58206385f944269bfebefac16cc046cf0537e2" => :mojave
    sha256 "c44ed170e389fe323966e95d25eff6adefdf3e44f3dff3656ec8e5511155bf2c" => :high_sierra
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

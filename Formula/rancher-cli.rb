class RancherCli < Formula
  desc "Unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.4.9.tar.gz"
  sha256 "db4d52b8dfa14961e5c42d040ef7dec8f45458f528eefdc1aa09ea303c8297d7"
  license "Apache-2.0"
  head "https://github.com/rancher/cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "609abe1ef0f570ca51daf2b22ec5fe0cfdd5ebe0e4eb61aae9a42a5ce53c5621" => :big_sur
    sha256 "56038ce98b25222f81b716240a56a3c9eb717d60b552e48c8443c7725327b5ee" => :catalina
    sha256 "f251b7191746fcc8312d7d87bb8bdb810da8b16e1c843bb7b49807d945c3014e" => :mojave
    sha256 "1508e3253e0d5f7f0e67bc16ee72cccf80d1072de115cc0e4a3d908d7aed0838" => :high_sierra
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

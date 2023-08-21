require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/v0.4.5.tar.gz"
  sha256 "c1559b31f21bbf0311713b2f2c8490c524183d1f0d3e46fc726d883385b6502a"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e0629457f0f5aeaf26ed7ff55f97b22849d0f738d2df5d96b38299916dd33e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11eb34dae3ab7b86e1fb4b09fb70b742778c4d52014b7d939e5f03ccbefccaf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0792e677adff40ea1cc7f5d0f1b20c03544cc0bec5773e6d8596c9427562608"
    sha256 cellar: :any_skip_relocation, ventura:        "e1dd90bf0c713c4e6d0a8ea835ce777d9904da5f8882bde68d94d2b6f2d04105"
    sha256 cellar: :any_skip_relocation, monterey:       "4ce019680c7f23d99d9bc2785276ec7f6dd09ad357d6feb556320b42f261dc0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a95f35c55e37d971a7eae88c0e3340ee74eabc934d608d74cd1996d6f5d5748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffa693187a96e0bc456cf687bd6a02212b5e266b92f7c19f1bafe6ed058e8bfc"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath/"ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    ldflags = ["-X github.com/openziti/zrok/build.Version=#{version}",
               "-X github.com/openziti/zrok/build.Hash=brew"]
    system "go", "build", *std_go_args(ldflags: ldflags), "github.com/openziti/zrok/cmd/zrok"
  end

  test do
    (testpath/"ctrl.yml").write <<~EOS
      v: 3
      maintenance:
        registration:
          expiration_timeout: 24h
    EOS

    version_output = shell_output("#{bin}/zrok version")
    assert_match(version.to_s, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end

require "language/node"

class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "e7d6da0949765bd86dc833a4a3585ae8a467c30e36d5a466829214bb38af8610"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "123712023f3f9ad39134138edd3b2fc9d6e564de67cc5174e5cf8ce614657ca3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eacb8e6ccbdc2a2afc078139cc04c83a8250e0181fea8b5dd8f54a45cdc7ad7d"
    sha256 cellar: :any_skip_relocation, monterey:       "5dc0ea32eb137dab71a5ebd44ff0b1b2a8543d163d3b9c66f01f08a8b3aee8df"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a536a6246ae9c1504e4ff212b5a530688fdec5e9c046f64f02369dd73715aa2"
    sha256 cellar: :any_skip_relocation, catalina:       "4fa05ad82b44dc0104aa9129cca90cbd7502d98078d45871ca2218b5ae26e1d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b3f22fcac2347e37debb6483131279c782c051c2ceb08792f5624988a9fbea1"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    chdir "pkg/web/ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")
  end

  test do
    system "rospo", "-v"
    system "rospo", "keygen", "-s"
    assert_predicate testpath/"identity", :exist?
    assert_predicate testpath/"identity.pub", :exist?
  end
end

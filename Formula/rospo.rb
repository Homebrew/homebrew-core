require "language/node"

class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "e7d6da0949765bd86dc833a4a3585ae8a467c30e36d5a466829214bb38af8610"
  license "MIT"

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

require "language/node"

class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "eb5bad62d6856f9efee695d45f77dd31937a671232aa1b69e1f204f8afc36bd9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8fe27f7491fbdf00a2648e4617c50fcade220fba94c58947dd9c63fb63c16da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8fe27f7491fbdf00a2648e4617c50fcade220fba94c58947dd9c63fb63c16da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8fe27f7491fbdf00a2648e4617c50fcade220fba94c58947dd9c63fb63c16da"
    sha256 cellar: :any_skip_relocation, ventura:        "4a365c3e2dc8832960a12abf4937ee2dda336e2ac38889e9ef9c672d125b695f"
    sha256 cellar: :any_skip_relocation, monterey:       "4a365c3e2dc8832960a12abf4937ee2dda336e2ac38889e9ef9c672d125b695f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a365c3e2dc8832960a12abf4937ee2dda336e2ac38889e9ef9c672d125b695f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dc97b4102f5f3b3001c94c60594aca2109ea52df9dba16941fa995dfc0d0df3"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    chdir "pkg/web/ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")

    generate_completions_from_executable(bin/"rospo", "completion")
  end

  test do
    system bin/"rospo", "-v"
    system bin/"rospo", "keygen", "-s"
    assert_predicate testpath/"identity", :exist?
    assert_predicate testpath/"identity.pub", :exist?
  end
end

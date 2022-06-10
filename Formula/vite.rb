require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.11.tgz"
  sha256 "d2a2a5002a83dbd77ac0ec780dfc92c312f98a6b9c950e4c98d30279e6ed5549"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97051113faca95fe62e2a70e3219966b4177e6fd1192f51bea024421e81e50ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97051113faca95fe62e2a70e3219966b4177e6fd1192f51bea024421e81e50ae"
    sha256 cellar: :any_skip_relocation, monterey:       "885f839f2719a8512a85bb0627dad5e005fd088892f19212a7cbad17eb3adf01"
    sha256 cellar: :any_skip_relocation, big_sur:        "885f839f2719a8512a85bb0627dad5e005fd088892f19212a7cbad17eb3adf01"
    sha256 cellar: :any_skip_relocation, catalina:       "885f839f2719a8512a85bb0627dad5e005fd088892f19212a7cbad17eb3adf01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2574f2fc02530e19625cd2d7af517e36667ff4397374682b205c02ebea9df4dd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      system bin/"vite", "preview", "--port", port
    end
    sleep 2
    assert_match "Cannot GET /", shell_output("curl -s localhost:#{port}")
  end
end

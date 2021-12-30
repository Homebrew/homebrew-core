require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.7.10.tgz"
  sha256 "1830eb886257d2e829ca45d79957ed4cbe4b739e9b6ae7dfa8fd83c14e0ca3f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bfae4f9a86380386a808c309a0fa8e76f23a37bdeb851b4bfb0a0ba2881bb41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bfae4f9a86380386a808c309a0fa8e76f23a37bdeb851b4bfb0a0ba2881bb41"
    sha256 cellar: :any_skip_relocation, monterey:       "c321a7316ba88aa492e2b9448fbb65773805e169aca73d61e142a7e92bf9e9f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c321a7316ba88aa492e2b9448fbb65773805e169aca73d61e142a7e92bf9e9f1"
    sha256 cellar: :any_skip_relocation, catalina:       "c321a7316ba88aa492e2b9448fbb65773805e169aca73d61e142a7e92bf9e9f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8d50e44192e2f3df06d98220d8c17cbbb8ee713a108df75f46d69974c5bbccd"
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

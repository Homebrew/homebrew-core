require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.1.2.tgz"
  sha256 "45703e9ec51bd2fe59d1430fbb670e3c9aa171d39259633dd77b1188d3405a12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7614a29b4404d13845becd4a32ba7e1a17b932427cd702b53bb0f021ab37e74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7614a29b4404d13845becd4a32ba7e1a17b932427cd702b53bb0f021ab37e74"
    sha256 cellar: :any_skip_relocation, monterey:       "7e409167d6972824f73603d5ad65be57028b2c174b5ad3cdb4c859f8f8f5d10b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e409167d6972824f73603d5ad65be57028b2c174b5ad3cdb4c859f8f8f5d10b"
    sha256 cellar: :any_skip_relocation, catalina:       "7e409167d6972824f73603d5ad65be57028b2c174b5ad3cdb4c859f8f8f5d10b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d09a57aa5224df014154b3a4d6317a08d8a69d60984a83c45352a281fdcc1c7"
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

require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://github.com/vitejs/vite/archive/refs/tags/v4.4.8.tar.gz"
  sha256 "34066558ac3288f0de75f8e5060367e6ac57f73b11988620c725627d082567b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53a7e1b2a260e3058b11abcae98844e32de7d7d089fbbec54efbab2e5cf9c4c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53a7e1b2a260e3058b11abcae98844e32de7d7d089fbbec54efbab2e5cf9c4c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53a7e1b2a260e3058b11abcae98844e32de7d7d089fbbec54efbab2e5cf9c4c8"
    sha256 cellar: :any_skip_relocation, ventura:        "280551cfc8826acbeeb1bc3926622aa2c63fb35639a62b95a18cfbdd43d66255"
    sha256 cellar: :any_skip_relocation, monterey:       "280551cfc8826acbeeb1bc3926622aa2c63fb35639a62b95a18cfbdd43d66255"
    sha256 cellar: :any_skip_relocation, big_sur:        "280551cfc8826acbeeb1bc3926622aa2c63fb35639a62b95a18cfbdd43d66255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0226375abfa5e4b281ffd369c1673eb1981843fc86f63909c769a96db7b23b3d"
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

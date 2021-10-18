require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.6.10.tgz"
  sha256 "2dd766bae0060eae0bd63bc5c853f611a0ba4cbd510d2b6b8774718659ede416"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf4b0178271be66de92c835d48e2e4b1dcc86177b61fb6abdc3c3b2e7c06d48c"
    sha256 cellar: :any_skip_relocation, big_sur:       "9120d77b380283ed6d3a539a2699925e31eaaf0469f5f6545b5cab9aaed4355a"
    sha256 cellar: :any_skip_relocation, catalina:      "9120d77b380283ed6d3a539a2699925e31eaaf0469f5f6545b5cab9aaed4355a"
    sha256 cellar: :any_skip_relocation, mojave:        "9120d77b380283ed6d3a539a2699925e31eaaf0469f5f6545b5cab9aaed4355a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a23c876fe84894f43586b86183e527098d37ad0680ffca97c950f82383100a1"
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

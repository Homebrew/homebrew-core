require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.2.2.tgz"
  sha256 "047e94ec68ab095748886eb151edd01262a485f9e175de831709d69801b04a46"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "903522b03a511f9305efac30c7b66101eea4d72fb3e8d3f517633b5a2a41aa5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "903522b03a511f9305efac30c7b66101eea4d72fb3e8d3f517633b5a2a41aa5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "903522b03a511f9305efac30c7b66101eea4d72fb3e8d3f517633b5a2a41aa5f"
    sha256 cellar: :any_skip_relocation, ventura:        "ae126fcb9883274d9dd2d18cb743544e6b115f7b761deaedadc1111e5b59bd8b"
    sha256 cellar: :any_skip_relocation, monterey:       "ae126fcb9883274d9dd2d18cb743544e6b115f7b761deaedadc1111e5b59bd8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae126fcb9883274d9dd2d18cb743544e6b115f7b761deaedadc1111e5b59bd8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfa0589284f13e47fc6fffed23af4c9fa2781ce5b221c86c44d4d1659a373100"
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

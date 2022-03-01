require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.8.5.tgz"
  sha256 "5acae2d43d4a566c1326008f278fa775270d364ba4b30fc835460928e221a024"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f321e49fd876a497789ea08bc1b50de63224cb34a84ebb8551cda10fe3644690"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f321e49fd876a497789ea08bc1b50de63224cb34a84ebb8551cda10fe3644690"
    sha256 cellar: :any_skip_relocation, monterey:       "d0a578da93c0ee1c76e91e70d8a80fa1fd0f6666992ffb78384012ee0c1a053e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0a578da93c0ee1c76e91e70d8a80fa1fd0f6666992ffb78384012ee0c1a053e"
    sha256 cellar: :any_skip_relocation, catalina:       "d0a578da93c0ee1c76e91e70d8a80fa1fd0f6666992ffb78384012ee0c1a053e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bd5054b6b04e989c2ef9677c03c73a804b34de15f1796683071da4ce88fd59e"
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

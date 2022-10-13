require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.1.8.tgz"
  sha256 "73fac18cdbbbde55c81ab60f8cb5a4b5e143d352b0985639156ab0175ea1524a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03ace02ce74914d99a10ba42d701c00ed0fd128e2a2e38cca7f86874e38e57ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03ace02ce74914d99a10ba42d701c00ed0fd128e2a2e38cca7f86874e38e57ee"
    sha256 cellar: :any_skip_relocation, monterey:       "3dae164b5c7834c35921ef7dda49ee0f180af431fe8268e02057a9d3e5b2753a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dae164b5c7834c35921ef7dda49ee0f180af431fe8268e02057a9d3e5b2753a"
    sha256 cellar: :any_skip_relocation, catalina:       "3dae164b5c7834c35921ef7dda49ee0f180af431fe8268e02057a9d3e5b2753a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "858aa20461ed415e249f80d849d19a74a1c5cd5e32a9be093e016fb017589709"
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

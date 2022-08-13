require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.0.7.tgz"
  sha256 "e02b41ac1d502c25e2c0fe67ef45045ac3aeed3e390bf614bdb690fa6791edee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "306ebfe4b5bbe4993229e7708766e478b489119f958315e66e3939d4825a34ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "306ebfe4b5bbe4993229e7708766e478b489119f958315e66e3939d4825a34ad"
    sha256 cellar: :any_skip_relocation, monterey:       "c040a5b017a64fd094faa9f0c9b445a2986fdf9df3b9e4d382d46810a54966df"
    sha256 cellar: :any_skip_relocation, big_sur:        "c040a5b017a64fd094faa9f0c9b445a2986fdf9df3b9e4d382d46810a54966df"
    sha256 cellar: :any_skip_relocation, catalina:       "c040a5b017a64fd094faa9f0c9b445a2986fdf9df3b9e4d382d46810a54966df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffd99933f36f63d2699c9a29305fad7a5665b8baaa395300414058671fe7f61f"
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

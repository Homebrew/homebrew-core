require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.1.3.tgz"
  sha256 "6ced5625fe67cda527aa9062c8770bb056aaae06bf375c93e121a4dc83792898"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91de19fcb2714566ca2e40f1f3d7793394973d36e4498bca7d0e36814b2a0458"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91de19fcb2714566ca2e40f1f3d7793394973d36e4498bca7d0e36814b2a0458"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91de19fcb2714566ca2e40f1f3d7793394973d36e4498bca7d0e36814b2a0458"
    sha256 cellar: :any_skip_relocation, ventura:        "68999eafd34908f4f95c7e8a157d6d38cfa836b11b831510b6c0c7db3b8acac7"
    sha256 cellar: :any_skip_relocation, monterey:       "68999eafd34908f4f95c7e8a157d6d38cfa836b11b831510b6c0c7db3b8acac7"
    sha256 cellar: :any_skip_relocation, big_sur:        "68999eafd34908f4f95c7e8a157d6d38cfa836b11b831510b6c0c7db3b8acac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa1f55e3c542ed549e160537e7c8b5932a452ded3fc8c1cb17364f6bea1ab768"
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

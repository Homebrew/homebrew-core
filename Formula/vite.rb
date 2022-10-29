require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.2.1.tgz"
  sha256 "1218014dfb4859d0925d9a9a5e6089ecfdaa50311ad47adeaa006cc6663f7905"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d12272a057acf4a1f043d2cfe5dd5155705e3b3dc10ed0fcc4dd6d745dae313e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d12272a057acf4a1f043d2cfe5dd5155705e3b3dc10ed0fcc4dd6d745dae313e"
    sha256 cellar: :any_skip_relocation, monterey:       "1332989fdb9203061c899273c570ea78bd682da0927d81de6007872713416fc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "1332989fdb9203061c899273c570ea78bd682da0927d81de6007872713416fc2"
    sha256 cellar: :any_skip_relocation, catalina:       "1332989fdb9203061c899273c570ea78bd682da0927d81de6007872713416fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b59514f411a64508e7df4f3c7c444fc13ff572341cb4c56ce9d5f03228a04def"
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

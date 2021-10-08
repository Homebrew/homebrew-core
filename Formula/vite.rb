require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.6.5.tgz"
  sha256 "4b9de5b098e49e091b6941148426f20aa541a2487f1edd719b5df16ac16ddaac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc43f33e90e8a2f4786c3459d9a288c7e22c9e8fd48408bc89315738350a4715"
    sha256 cellar: :any_skip_relocation, big_sur:       "512a81831a8030cbd2b1c8b01d9e3ddf6f4842a1c6e28eeb277f8593f5df0809"
    sha256 cellar: :any_skip_relocation, catalina:      "512a81831a8030cbd2b1c8b01d9e3ddf6f4842a1c6e28eeb277f8593f5df0809"
    sha256 cellar: :any_skip_relocation, mojave:        "512a81831a8030cbd2b1c8b01d9e3ddf6f4842a1c6e28eeb277f8593f5df0809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37d08f9d5c5690bf4378d0d322fb0e29241988c7a2c6e36fc596a001eca70f2e"
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

require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.2.2.tgz"
  sha256 "e252422cc0a564169134d179e194ca78d2ce6c701a0e83d41cadd3f283ce4e37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66d699e654c7502f6da6a4f72a27d0a204f7c9230c3a6a2bf80ecaba64305b76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66d699e654c7502f6da6a4f72a27d0a204f7c9230c3a6a2bf80ecaba64305b76"
    sha256 cellar: :any_skip_relocation, monterey:       "19ed8bd228c07ca173a66c321076322d4b7bfb27ef0df11fbe34f4d4cfdb3cb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "19ed8bd228c07ca173a66c321076322d4b7bfb27ef0df11fbe34f4d4cfdb3cb7"
    sha256 cellar: :any_skip_relocation, catalina:       "19ed8bd228c07ca173a66c321076322d4b7bfb27ef0df11fbe34f4d4cfdb3cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b19cbf8376750a0f7590ba894208f9bae6dd8abd617d8bbbd7e690be104d47fa"
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

require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.2.1.tgz"
  sha256 "1218014dfb4859d0925d9a9a5e6089ecfdaa50311ad47adeaa006cc6663f7905"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9256fa4d20395fbd8c0228eb679f8d31caac6a735210c47948ecc8cf8b1eda8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9256fa4d20395fbd8c0228eb679f8d31caac6a735210c47948ecc8cf8b1eda8"
    sha256 cellar: :any_skip_relocation, monterey:       "e281fba54f850faee808988774c368942d68e4bc6608ae6f9d095c3c02701206"
    sha256 cellar: :any_skip_relocation, big_sur:        "e281fba54f850faee808988774c368942d68e4bc6608ae6f9d095c3c02701206"
    sha256 cellar: :any_skip_relocation, catalina:       "e281fba54f850faee808988774c368942d68e4bc6608ae6f9d095c3c02701206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce4b245016f66139d1adbbf8cc5e654664262d028b3802306a6cbd53eb789ca6"
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

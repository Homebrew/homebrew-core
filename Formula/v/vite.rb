require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.5.0.tgz"
  sha256 "5341e86fd426dfcb0dda740c573a9fd0a22e2aeb364baa06ad5b715b5c5fc391"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e26bd794d2103a5717910360cf75e939b6700d370f57ad3baf0aee139618210"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e26bd794d2103a5717910360cf75e939b6700d370f57ad3baf0aee139618210"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e26bd794d2103a5717910360cf75e939b6700d370f57ad3baf0aee139618210"
    sha256 cellar: :any_skip_relocation, sonoma:         "08bcd01b0cdc26eb552f1a2831d2466b49a76175ba653b641e87f8a76c7330a5"
    sha256 cellar: :any_skip_relocation, ventura:        "08bcd01b0cdc26eb552f1a2831d2466b49a76175ba653b641e87f8a76c7330a5"
    sha256 cellar: :any_skip_relocation, monterey:       "08bcd01b0cdc26eb552f1a2831d2466b49a76175ba653b641e87f8a76c7330a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5136eee85cffe78dbc0b861ca8aca88afa43595a0cca230c4a01a5efd832723c"
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

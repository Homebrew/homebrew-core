require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.5.6.tgz"
  sha256 "c0e9318699acc678abb105bbc18f5deff3e88604ce5370dd61c5c7d8103a1b6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c0b6e8cae96546339485081696be39c88e104ec183929d0fef58552ffe6646fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9dd7d11656106fc49095189d032bb80cbb59dca1cd8ffee41e638b61d610afd"
    sha256 cellar: :any_skip_relocation, catalina:      "c9dd7d11656106fc49095189d032bb80cbb59dca1cd8ffee41e638b61d610afd"
    sha256 cellar: :any_skip_relocation, mojave:        "c9dd7d11656106fc49095189d032bb80cbb59dca1cd8ffee41e638b61d610afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0ed48424b8d4c034479ca6550e71cff6b2c8bcd2cd745a0b0933e9c1390d1a4"
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

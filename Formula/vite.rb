require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.7.6.tgz"
  sha256 "6b38cb75e81cd2ba50c55cb02644e4d87e2b6430b1dd23255b694fa548313ad6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "752dd19ca56f46aa5db87e8b353935d15664c46aa80d769051ce835da8931984"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "752dd19ca56f46aa5db87e8b353935d15664c46aa80d769051ce835da8931984"
    sha256 cellar: :any_skip_relocation, monterey:       "5c5965b31a7735407d5f14eeabae2a4e81357d8c35da3fef9fff015cb5b079cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c5965b31a7735407d5f14eeabae2a4e81357d8c35da3fef9fff015cb5b079cf"
    sha256 cellar: :any_skip_relocation, catalina:       "5c5965b31a7735407d5f14eeabae2a4e81357d8c35da3fef9fff015cb5b079cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2288b3b7f070b144a8331cc1a8ceaac03a8fc63133d415b217701c5b7ef86801"
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

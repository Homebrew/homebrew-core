require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.9.tgz"
  sha256 "85984e9d583ba45f624973d7b921607b0ac061b6675f80893c51e39699cfafc0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7f19749a51cc0d8bf78803c054bc3f23416399fc63cbb1f1427e3103f2e2d7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7f19749a51cc0d8bf78803c054bc3f23416399fc63cbb1f1427e3103f2e2d7e"
    sha256 cellar: :any_skip_relocation, monterey:       "cbd11da7638db29c0d973ddf4080b400531a400e461685b9d2659757d77390c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbd11da7638db29c0d973ddf4080b400531a400e461685b9d2659757d77390c4"
    sha256 cellar: :any_skip_relocation, catalina:       "cbd11da7638db29c0d973ddf4080b400531a400e461685b9d2659757d77390c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7037ca48e2502ec61a1f907c3570beb5f138f5d3de2902054172c44aa90e203b"
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

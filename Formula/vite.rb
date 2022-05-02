require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.7.tgz"
  sha256 "3117b478be9a66bbb4f7375a27357fef3fdebaad1e341b7bc57a45753fef8c86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "663ea267d154564e8b4491f3f2b7b160fcdfb7434fbe4e2a955cc32d6694c04e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "663ea267d154564e8b4491f3f2b7b160fcdfb7434fbe4e2a955cc32d6694c04e"
    sha256 cellar: :any_skip_relocation, monterey:       "f1b9c391851042d7024e5c49f446f6d8879ddb126c0002422532ed0bc834b96f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1b9c391851042d7024e5c49f446f6d8879ddb126c0002422532ed0bc834b96f"
    sha256 cellar: :any_skip_relocation, catalina:       "f1b9c391851042d7024e5c49f446f6d8879ddb126c0002422532ed0bc834b96f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22566426606ae6f08b3fb2337ea744be8790c012738ea44860d419d5f4c6c864"
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

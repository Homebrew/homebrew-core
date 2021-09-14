require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.5.7.tgz"
  sha256 "db60140997a73657e922306a345c6081aa2545030019f866d488b651a2909fb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18182eda193a884a21f9a61001d3e9782801d3305222e7710693051fc61dd077"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a6fe3e4496eb3ebfd48eb6f722e411eb5085434f6df75d16914aee7ef8fe9ef"
    sha256 cellar: :any_skip_relocation, catalina:      "8a6fe3e4496eb3ebfd48eb6f722e411eb5085434f6df75d16914aee7ef8fe9ef"
    sha256 cellar: :any_skip_relocation, mojave:        "8a6fe3e4496eb3ebfd48eb6f722e411eb5085434f6df75d16914aee7ef8fe9ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "693e63b460c6529b5fba8602b3683f4b9d1bbc6a50c0af5d4b69d36c19985bf6"
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

require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.1.tgz"
  sha256 "ad5d4715668441df761e91ee4aec57e4f97ee260f77c7d0879a648a04daf63f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b2100ab9596e66dd4e3b338bfb711acedb0a749f5346a9f74114bf099d34801"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b2100ab9596e66dd4e3b338bfb711acedb0a749f5346a9f74114bf099d34801"
    sha256 cellar: :any_skip_relocation, monterey:       "dac0edea7eef7bef75b06eced2bc3e0e80df8871eee3a3474a3ccad233a12526"
    sha256 cellar: :any_skip_relocation, big_sur:        "dac0edea7eef7bef75b06eced2bc3e0e80df8871eee3a3474a3ccad233a12526"
    sha256 cellar: :any_skip_relocation, catalina:       "dac0edea7eef7bef75b06eced2bc3e0e80df8871eee3a3474a3ccad233a12526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c68aa23220c2ff0c21d396dd0a6c42e94cb2c667ff8563f04d641badbc0b2cf"
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

require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.0.4.tgz"
  sha256 "f72a5f33438f02ce3d1537ea05caba38f699d762418732c3f2ab866a28a60718"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "013ce256b1a3efee6b24c423c74067e2987fe11d94e8779be5c6a6d3c0026973"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "013ce256b1a3efee6b24c423c74067e2987fe11d94e8779be5c6a6d3c0026973"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "013ce256b1a3efee6b24c423c74067e2987fe11d94e8779be5c6a6d3c0026973"
    sha256 cellar: :any_skip_relocation, ventura:        "310f7c36b561639a8d265b270d75e9050ed310a0729ed1f896db2455325913f6"
    sha256 cellar: :any_skip_relocation, monterey:       "310f7c36b561639a8d265b270d75e9050ed310a0729ed1f896db2455325913f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "310f7c36b561639a8d265b270d75e9050ed310a0729ed1f896db2455325913f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce61383383a7e4d5f68b9c785c8678c47c4c789bed29d406999a4d4f94ed90aa"
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

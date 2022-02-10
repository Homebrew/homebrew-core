require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.8.0.tgz"
  sha256 "3b54a8191481548cbc6aee586dfb29445bf6f01eba916d58ad0f599b510d3957"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77d0dbc3168f3bc8df931cb10e475a1de9264ac97527be54b286a2e0ea9f8cc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77d0dbc3168f3bc8df931cb10e475a1de9264ac97527be54b286a2e0ea9f8cc7"
    sha256 cellar: :any_skip_relocation, monterey:       "c16347f77f4b34e7efe3e4353adda2e54e56e70867a7abeeb15f28d3e7296e5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c16347f77f4b34e7efe3e4353adda2e54e56e70867a7abeeb15f28d3e7296e5c"
    sha256 cellar: :any_skip_relocation, catalina:       "c16347f77f4b34e7efe3e4353adda2e54e56e70867a7abeeb15f28d3e7296e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec4714e788587acc15b3ef7484b123d7c13894749907d98112ebaa43f9e09ea5"
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

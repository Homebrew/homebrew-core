require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.8.3.tgz"
  sha256 "4ec974208f75765f844dc55ca37f82bf721c2674a57b2498731fa06b333af70d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9e47cef6cb7b1c3a26328f5161001aa2b50d56311eb4380f94cc67bd7ce1a70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9e47cef6cb7b1c3a26328f5161001aa2b50d56311eb4380f94cc67bd7ce1a70"
    sha256 cellar: :any_skip_relocation, monterey:       "5e63a1bc116ecd59a7d2a0bb1fb071534ceaebb56ed586c899f2e5fcbf9c8409"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e63a1bc116ecd59a7d2a0bb1fb071534ceaebb56ed586c899f2e5fcbf9c8409"
    sha256 cellar: :any_skip_relocation, catalina:       "5e63a1bc116ecd59a7d2a0bb1fb071534ceaebb56ed586c899f2e5fcbf9c8409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c9e3a18d38d2ee910b9abdee195d2e7384e42821550344ea3ad79e56f58a5d5"
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

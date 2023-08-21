require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.4.9.tgz"
  sha256 "9b8223179ee7cadac78c5aef849a2526725f4924f138c5354375879fb546dfec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4f8c9a070cc334d81e77c5d6f7624a39501d1738a82d279a1cfc1a559dd3ec1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4f8c9a070cc334d81e77c5d6f7624a39501d1738a82d279a1cfc1a559dd3ec1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4f8c9a070cc334d81e77c5d6f7624a39501d1738a82d279a1cfc1a559dd3ec1"
    sha256 cellar: :any_skip_relocation, ventura:        "eaaa4aece89090dd6e8082fb99991b24109a9b049724d2e75eb9cbf9d5fc8998"
    sha256 cellar: :any_skip_relocation, monterey:       "eaaa4aece89090dd6e8082fb99991b24109a9b049724d2e75eb9cbf9d5fc8998"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaaa4aece89090dd6e8082fb99991b24109a9b049724d2e75eb9cbf9d5fc8998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43f6bdc6333261ba18a38dec69de2be0af6820679c8c84f38c2e2bd32852ede1"
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

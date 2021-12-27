require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.7.7.tgz"
  sha256 "1daa24df90f2e1660f8282670f46c36e98d2d7a08d8768a71d245a3eb5038478"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0a3d80699726ad29bd1e15e1765c80549fa56eca3e97be9971aa57dfd225695"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0a3d80699726ad29bd1e15e1765c80549fa56eca3e97be9971aa57dfd225695"
    sha256 cellar: :any_skip_relocation, monterey:       "b7d678641ad4db298a4053425e4ac426f246d760c086b08f05e28abdcd456baf"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7d678641ad4db298a4053425e4ac426f246d760c086b08f05e28abdcd456baf"
    sha256 cellar: :any_skip_relocation, catalina:       "b7d678641ad4db298a4053425e4ac426f246d760c086b08f05e28abdcd456baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "471885f9f8630c054d2b86805e370932c9b9f22d398d2724e9dee5c2d395035e"
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

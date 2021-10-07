require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.6.4.tgz"
  sha256 "26b45946f1946a5b235f5665866816966336aada5f3bdaf5087ae6785ba9734d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d6c301e37cdcae101d7f2a883ef688a96da148613000aaf880a9b00de23f2590"
    sha256 cellar: :any_skip_relocation, big_sur:       "537ef194d243baae563d8339f8ba543ca1973c96b7bbe3a2a093f5d7d77a4e10"
    sha256 cellar: :any_skip_relocation, catalina:      "537ef194d243baae563d8339f8ba543ca1973c96b7bbe3a2a093f5d7d77a4e10"
    sha256 cellar: :any_skip_relocation, mojave:        "537ef194d243baae563d8339f8ba543ca1973c96b7bbe3a2a093f5d7d77a4e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13c1247fbc1d391e4caaa067798be4d8e4f20a3e312decb8e5abaf05d7696ac3"
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

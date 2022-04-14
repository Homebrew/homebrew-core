require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.4.tgz"
  sha256 "00edb4a2b3165bbf9c5278506353837d1f226b6bde56b5255330a888f03912c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ee3951a0d19a7ec19d7bef20d5c06addcbd11e58404be0d4a61f794507acb85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ee3951a0d19a7ec19d7bef20d5c06addcbd11e58404be0d4a61f794507acb85"
    sha256 cellar: :any_skip_relocation, monterey:       "50e3a17e872e04102982df978b3ac7d6f8485adc85e076829b4aea8e3ded77c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "50e3a17e872e04102982df978b3ac7d6f8485adc85e076829b4aea8e3ded77c0"
    sha256 cellar: :any_skip_relocation, catalina:       "50e3a17e872e04102982df978b3ac7d6f8485adc85e076829b4aea8e3ded77c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d2e59e69196f597682ca95dd87368be39ea211a80384789e48107c1642ec6f3"
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

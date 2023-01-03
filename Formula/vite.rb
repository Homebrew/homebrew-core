require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.0.4.tgz"
  sha256 "f72a5f33438f02ce3d1537ea05caba38f699d762418732c3f2ab866a28a60718"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c7a5a2e59058281ad2e4c9ea6c17f6cbb7687a6f6de1ff41ee05ff41afcd4f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c7a5a2e59058281ad2e4c9ea6c17f6cbb7687a6f6de1ff41ee05ff41afcd4f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c7a5a2e59058281ad2e4c9ea6c17f6cbb7687a6f6de1ff41ee05ff41afcd4f0"
    sha256 cellar: :any_skip_relocation, ventura:        "04169e275eb1e0e36e71956dfb43313082c3a50295d8b5f40cc5dfefc079d49c"
    sha256 cellar: :any_skip_relocation, monterey:       "04169e275eb1e0e36e71956dfb43313082c3a50295d8b5f40cc5dfefc079d49c"
    sha256 cellar: :any_skip_relocation, big_sur:        "04169e275eb1e0e36e71956dfb43313082c3a50295d8b5f40cc5dfefc079d49c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95ec6dcb35f72ab98699251ea4866b1e0de2a1c113e0e37694296c168009c938"
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

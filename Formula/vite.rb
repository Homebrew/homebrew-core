require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.2.0.tgz"
  sha256 "5f2032c50fc7933027f7ca051a1e84e2f487b1a3cf34a96ed86bbb1f5106463b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3a9a649bc5247943b43c05f553a0e966f9e7ec35be07052e07cf40fb2c82148"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3a9a649bc5247943b43c05f553a0e966f9e7ec35be07052e07cf40fb2c82148"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3a9a649bc5247943b43c05f553a0e966f9e7ec35be07052e07cf40fb2c82148"
    sha256 cellar: :any_skip_relocation, ventura:        "215bff35103480b5e030154f88ef21e1009dca7d5f478117a727107abc2a5f9b"
    sha256 cellar: :any_skip_relocation, monterey:       "215bff35103480b5e030154f88ef21e1009dca7d5f478117a727107abc2a5f9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "215bff35103480b5e030154f88ef21e1009dca7d5f478117a727107abc2a5f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c7118a9973e6923eceffbe2877dc0eb18bc4fb274fd0c389d73a05eac49145f"
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

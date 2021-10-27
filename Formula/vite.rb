require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.6.12.tgz"
  sha256 "40a6fe8412703d7a6a4747447994c58af6043fb077f1ba30d68df3b1e773f0be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "469706d751c3c05f482ae4ead194638dd747b748f370e860c491800a4b3e5297"
    sha256 cellar: :any_skip_relocation, big_sur:       "473d9c34020ad9c13adbaa79ad18ef049a8677e73893db5c55c00f31deb47347"
    sha256 cellar: :any_skip_relocation, catalina:      "473d9c34020ad9c13adbaa79ad18ef049a8677e73893db5c55c00f31deb47347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6c2f417aa0cc71058dd5dc029f2a89fa3abc2fd6a65c5e2359e2f3d4aa206b"
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

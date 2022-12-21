require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.0.3.tgz"
  sha256 "10333fc8fb992d644c3743bcaa6084fc7c2036df95e25f43778632c5da8cd854"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfb173017cb6337c305a86ccc962e1cd06ba3c6b1803e98ca40b5c158f6b6ae9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfb173017cb6337c305a86ccc962e1cd06ba3c6b1803e98ca40b5c158f6b6ae9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfb173017cb6337c305a86ccc962e1cd06ba3c6b1803e98ca40b5c158f6b6ae9"
    sha256 cellar: :any_skip_relocation, ventura:        "ec92af9b68424f6402c938676c04d52326671c066d65c7b028007c68c0df1332"
    sha256 cellar: :any_skip_relocation, monterey:       "ec92af9b68424f6402c938676c04d52326671c066d65c7b028007c68c0df1332"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec92af9b68424f6402c938676c04d52326671c066d65c7b028007c68c0df1332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3625d3782ec3775b0528ef68eaa27d02ce05c69121c7ead3728a7be8473ec117"
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

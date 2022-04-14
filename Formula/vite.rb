require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.5.tgz"
  sha256 "18b59edb914df39222726ac85489dfb46fa312e675fc8a086e2e7ec3aadfa59f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9cbbf1ab06bc64d4e9e6a85a1de0cbb43fecc99fdbf6e6051144b9c32c360ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9cbbf1ab06bc64d4e9e6a85a1de0cbb43fecc99fdbf6e6051144b9c32c360ab"
    sha256 cellar: :any_skip_relocation, monterey:       "0abc95d96734eb2308defefe3255e9cdfcb38afecd83655b249c778632a98c14"
    sha256 cellar: :any_skip_relocation, big_sur:        "0abc95d96734eb2308defefe3255e9cdfcb38afecd83655b249c778632a98c14"
    sha256 cellar: :any_skip_relocation, catalina:       "0abc95d96734eb2308defefe3255e9cdfcb38afecd83655b249c778632a98c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc9a13d84cce8a022ac64a0c9ae3bed20712e197576adc0497b8e7ea8db4fda3"
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

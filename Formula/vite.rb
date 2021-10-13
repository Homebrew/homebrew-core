require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.6.7.tgz"
  sha256 "271bb34a8c9735e931792cb95addff0426e3d5e38c0c8dee454a0994a73ad0eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce14fe6656fce12eef12d255cb33f8c5b51bc102d1658f35d05810b5028d9e37"
    sha256 cellar: :any_skip_relocation, big_sur:       "b93ecebfa4538ead49dfde48676754e305477d2097a1c31b109398994933736d"
    sha256 cellar: :any_skip_relocation, catalina:      "b93ecebfa4538ead49dfde48676754e305477d2097a1c31b109398994933736d"
    sha256 cellar: :any_skip_relocation, mojave:        "b93ecebfa4538ead49dfde48676754e305477d2097a1c31b109398994933736d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a898ff8d1aa9351d0a650322d2eefc220a3003293105c65cc5e822b85d5713c"
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

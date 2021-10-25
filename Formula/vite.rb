require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.6.11.tgz"
  sha256 "8e95014829139da6c0899609f2b257604716ef3fbf4461303a3fed77c068bd7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7def7bf929ce9f2d922321a46c0f619d67a1e561849dac7a0ac9ad8f1182fc7a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c35ec2f361e1889b32bef82a01393b6316f7b60bfd5041e93d264c19d9f2e7f4"
    sha256 cellar: :any_skip_relocation, catalina:      "c35ec2f361e1889b32bef82a01393b6316f7b60bfd5041e93d264c19d9f2e7f4"
    sha256 cellar: :any_skip_relocation, mojave:        "c35ec2f361e1889b32bef82a01393b6316f7b60bfd5041e93d264c19d9f2e7f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc4f5ba446f4a000cd6d45b6e654b1127a30bb795c774a534ef2add07d4cc3a1"
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

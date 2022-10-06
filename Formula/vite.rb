require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.1.5.tgz"
  sha256 "737012f31f2a95d737354bc8f17964087d6294f563285cd749a6f7fd1fb57669"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4edc7113b018465b359bf80ccb2db883737da1312a46a0de82931186a816e135"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4edc7113b018465b359bf80ccb2db883737da1312a46a0de82931186a816e135"
    sha256 cellar: :any_skip_relocation, monterey:       "f7d0375faebcdbbffaf9927ab427d6a4eec277feebcfc9f52c7be73574d8494d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7d0375faebcdbbffaf9927ab427d6a4eec277feebcfc9f52c7be73574d8494d"
    sha256 cellar: :any_skip_relocation, catalina:       "f7d0375faebcdbbffaf9927ab427d6a4eec277feebcfc9f52c7be73574d8494d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "210ded57d314ffce6cae8fcc9f5c53bbed094e0830bde5b77e477c264daa6070"
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

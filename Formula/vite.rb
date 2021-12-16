require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.7.3.tgz"
  sha256 "61470085dc965c2bf3ca2b093eedc993480d1b3ba512c7e53a94bea4391c263a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89aa4424fd97f4cf05ec2906fd7c078b32dde70446c8ff3d04e09248241fe20c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89aa4424fd97f4cf05ec2906fd7c078b32dde70446c8ff3d04e09248241fe20c"
    sha256 cellar: :any_skip_relocation, monterey:       "b4f2fa3f8a36759114c1b41e50e9ad32cfea63bc9fbde0bcfb5de2a38a45f194"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4f2fa3f8a36759114c1b41e50e9ad32cfea63bc9fbde0bcfb5de2a38a45f194"
    sha256 cellar: :any_skip_relocation, catalina:       "b4f2fa3f8a36759114c1b41e50e9ad32cfea63bc9fbde0bcfb5de2a38a45f194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc33e81f7b43bc3ecd7a6d35c5c48113ba76527e2e89e227b187a391eb46a8b3"
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

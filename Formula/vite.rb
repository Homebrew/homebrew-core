require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.6.2.tgz"
  sha256 "21f6999bf09de2f433a8c950b06d9e26606f99003d54d853c0c1f71971c2e1f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eaadd452375b74ddf2b56e120ca7ed2386d274210f3aac1113c3e813a325efd0"
    sha256 cellar: :any_skip_relocation, big_sur:       "daf83fdbe268d6e2fa7e9f0e2ab570d4b59143ac7f6c83377489ef652c751e0c"
    sha256 cellar: :any_skip_relocation, catalina:      "daf83fdbe268d6e2fa7e9f0e2ab570d4b59143ac7f6c83377489ef652c751e0c"
    sha256 cellar: :any_skip_relocation, mojave:        "daf83fdbe268d6e2fa7e9f0e2ab570d4b59143ac7f6c83377489ef652c751e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f83d215bcc8ded370d7c975a2e8387682716deab7ccbedf1729d38aefd0b26"
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

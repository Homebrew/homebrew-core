require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.9.12.tgz"
  sha256 "f6f455e02bc7669a313ff89d1df9b9a4af26932f7523ffb06a653ad15613a53d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19e8aab0eea34a91a83da919a87575c890f46a48e6d85e9015fc92eec3234429"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19e8aab0eea34a91a83da919a87575c890f46a48e6d85e9015fc92eec3234429"
    sha256 cellar: :any_skip_relocation, monterey:       "dc1760f94f649da96d4443952c11bf5517a4c80febb99716652e9510dbb8e3f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc1760f94f649da96d4443952c11bf5517a4c80febb99716652e9510dbb8e3f7"
    sha256 cellar: :any_skip_relocation, catalina:       "dc1760f94f649da96d4443952c11bf5517a4c80febb99716652e9510dbb8e3f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c01cd6cf197d263bbf23743cc0e41b9681dda805a68b6c67c46f10b64e18b3e7"
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

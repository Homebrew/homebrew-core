require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.5.9.tgz"
  sha256 "5326e22aad54e7d873827410b6dd7988a71176d49d5023ebc89a54fc4c4f831f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cfa5ca4986518138f2dcef142ffe5b06b7245af18a6273b1f83a9ec0d1602f7b"
    sha256 cellar: :any_skip_relocation, big_sur:       "86ab1bc40e52f87dbe5df5f2e1e449366a0859465479d7420859f2f4d9c9ae4d"
    sha256 cellar: :any_skip_relocation, catalina:      "86ab1bc40e52f87dbe5df5f2e1e449366a0859465479d7420859f2f4d9c9ae4d"
    sha256 cellar: :any_skip_relocation, mojave:        "86ab1bc40e52f87dbe5df5f2e1e449366a0859465479d7420859f2f4d9c9ae4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09e543ab1962a5f809723d2a696df138f56920ee7b7954eaff038109d4245877"
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

require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.8.2.tgz"
  sha256 "bad727a14830212420ac75534cfc6905d96c2186afdcd68d4975560c6cc19ca8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04170f9ee61bf6281a8bcf290bf8572c57e509b8e023269e5af880eb21abf205"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04170f9ee61bf6281a8bcf290bf8572c57e509b8e023269e5af880eb21abf205"
    sha256 cellar: :any_skip_relocation, monterey:       "06b3aafad5270c228e8c2b4d81bc27471274782b98cef5ea95d604ae06e5b3f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "06b3aafad5270c228e8c2b4d81bc27471274782b98cef5ea95d604ae06e5b3f7"
    sha256 cellar: :any_skip_relocation, catalina:       "06b3aafad5270c228e8c2b4d81bc27471274782b98cef5ea95d604ae06e5b3f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abcd349dc549cfe117bfa5e34549eace84c993ad83ed146fdccb1b6b4367dc99"
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

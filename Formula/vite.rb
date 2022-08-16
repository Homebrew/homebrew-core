require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.0.8.tgz"
  sha256 "323f74d8e99e2c2d5b4712bdfe8d9a4f970fdb48ed4bba39eba325fe6db87e60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77546f5264dac00fc84cc6b189501a5913370de568d8b63bfa54d7686ad299e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77546f5264dac00fc84cc6b189501a5913370de568d8b63bfa54d7686ad299e9"
    sha256 cellar: :any_skip_relocation, monterey:       "08326994187c4fb187aef42f94adb3598ca0102d44d859b522b12467ec1d20b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "08326994187c4fb187aef42f94adb3598ca0102d44d859b522b12467ec1d20b1"
    sha256 cellar: :any_skip_relocation, catalina:       "08326994187c4fb187aef42f94adb3598ca0102d44d859b522b12467ec1d20b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70aba88046cf92507602d86b53814943d6d20d0eaf78b303af3448b90f59cc95"
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

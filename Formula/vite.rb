require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-3.0.8.tgz"
  sha256 "323f74d8e99e2c2d5b4712bdfe8d9a4f970fdb48ed4bba39eba325fe6db87e60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fde66a3fef486381480711f206c71b53879aa0d33b419620e492bff2e776a69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fde66a3fef486381480711f206c71b53879aa0d33b419620e492bff2e776a69"
    sha256 cellar: :any_skip_relocation, monterey:       "d1a95e17d679dad28537a59aefcd22175050a5f8354a1bf18eb0c084edaa2987"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1a95e17d679dad28537a59aefcd22175050a5f8354a1bf18eb0c084edaa2987"
    sha256 cellar: :any_skip_relocation, catalina:       "d1a95e17d679dad28537a59aefcd22175050a5f8354a1bf18eb0c084edaa2987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81235770192b56ebd539414a1bade1686987945b641af1f59fd39d30bae3e14f"
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

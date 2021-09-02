require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-2.5.3.tgz"
  sha256 "3af26eb8f2c3e978eaf1fd88d0bc878945827bd167eb0b51d25355b75f65a44a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "65036516be33babe1f445764473f75aa71ff2e52e520adc3619aae0694da5d64"
    sha256 cellar: :any_skip_relocation, big_sur:       "35850ab099a71ccd3882e67b8e6e671b9d83311ecec275c368a050860aac618b"
    sha256 cellar: :any_skip_relocation, catalina:      "35850ab099a71ccd3882e67b8e6e671b9d83311ecec275c368a050860aac618b"
    sha256 cellar: :any_skip_relocation, mojave:        "35850ab099a71ccd3882e67b8e6e671b9d83311ecec275c368a050860aac618b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c876400769fc6fb100a2607d436858b6104338cb62a433c621487f006f7170d"
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

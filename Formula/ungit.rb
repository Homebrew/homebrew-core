require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.23.tgz"
  sha256 "d868b06d0a160773799577d09bad528cf011c74f18d521356a332208c99aa991"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "393c22b95d686cab0afe17e408e076f9e4be666b5bdb4184c759dda63bd65e00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bc9e0f1d56b4ac32091c4f3fccfbedd4afadf82b7afe9e20e061afebed1aa30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bc9e0f1d56b4ac32091c4f3fccfbedd4afadf82b7afe9e20e061afebed1aa30"
    sha256 cellar: :any_skip_relocation, ventura:        "76f7134376f40cc9bbd47cfe009387f7279e9fac92103531efd4e254af66f1dd"
    sha256 cellar: :any_skip_relocation, monterey:       "b2e40ec003b25b08144d36acd844a9f4061b303a4007f076d4851d23efa83255"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2e40ec003b25b08144d36acd844a9f4061b303a4007f076d4851d23efa83255"
    sha256 cellar: :any_skip_relocation, catalina:       "b2e40ec003b25b08144d36acd844a9f4061b303a4007f076d4851d23efa83255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc9e0f1d56b4ac32091c4f3fccfbedd4afadf82b7afe9e20e061afebed1aa30"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port

    fork do
      exec bin/"ungit", "--no-launchBrowser", "--port=#{port}"
    end
    sleep 8

    assert_includes shell_output("curl -s 127.0.0.1:#{port}/"), "<title>ungit</title>"
  end
end

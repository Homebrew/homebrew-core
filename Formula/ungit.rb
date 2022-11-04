require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.22.tgz"
  sha256 "f1c0017fc3c2b9ea9158179223d1509ec1b0cc677642f1c3c5ba87d425b78f79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fbd45d11df1c57d30d8d5e7a18e08711b429fe7f96237822b6c97282ee3dfd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fbd45d11df1c57d30d8d5e7a18e08711b429fe7f96237822b6c97282ee3dfd7"
    sha256 cellar: :any_skip_relocation, monterey:       "b30195eb0fe0cab7e8e4bb1dcfe53c484647f2eebce8f49385a4e46523b4b4ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "b30195eb0fe0cab7e8e4bb1dcfe53c484647f2eebce8f49385a4e46523b4b4ef"
    sha256 cellar: :any_skip_relocation, catalina:       "b30195eb0fe0cab7e8e4bb1dcfe53c484647f2eebce8f49385a4e46523b4b4ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fbd45d11df1c57d30d8d5e7a18e08711b429fe7f96237822b6c97282ee3dfd7"
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

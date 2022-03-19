require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.20.tgz"
  sha256 "3a2f8cdf672442b4a833735e59b69b5b2892d377fa117f0c2249dc8e4e5e0e9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fd75bfa4be353e8b05e639e00bffa91521d27030212be9c0f13691aa62ae4fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fd75bfa4be353e8b05e639e00bffa91521d27030212be9c0f13691aa62ae4fa"
    sha256 cellar: :any_skip_relocation, monterey:       "22008f0f88a61de602088fa93d3961fabbd1bad657bb6c6625605aba0bb769ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "22008f0f88a61de602088fa93d3961fabbd1bad657bb6c6625605aba0bb769ea"
    sha256 cellar: :any_skip_relocation, catalina:       "22008f0f88a61de602088fa93d3961fabbd1bad657bb6c6625605aba0bb769ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd75bfa4be353e8b05e639e00bffa91521d27030212be9c0f13691aa62ae4fa"
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

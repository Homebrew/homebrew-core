require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.25.tgz"
  sha256 "a49928276034b8883f365100a52bf57c890b5bb4203f083d843b239f5d1355e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f04f11473752e6022c91c59b98e2991c68c54bd0d0aa9b513ab52ae658fbb83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f04f11473752e6022c91c59b98e2991c68c54bd0d0aa9b513ab52ae658fbb83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f04f11473752e6022c91c59b98e2991c68c54bd0d0aa9b513ab52ae658fbb83"
    sha256 cellar: :any_skip_relocation, sonoma:         "9adf0cc64eb52a30a4591cd46f4c162b188371f488081d5626a2d0fa33373071"
    sha256 cellar: :any_skip_relocation, ventura:        "9adf0cc64eb52a30a4591cd46f4c162b188371f488081d5626a2d0fa33373071"
    sha256 cellar: :any_skip_relocation, monterey:       "9adf0cc64eb52a30a4591cd46f4c162b188371f488081d5626a2d0fa33373071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f04f11473752e6022c91c59b98e2991c68c54bd0d0aa9b513ab52ae658fbb83"
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

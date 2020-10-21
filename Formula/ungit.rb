require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.12.tgz"
  sha256 "8a52eec719818d520d2e774cf032126b7a5edfc2bd80c777202100bb2049c4d8"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5a0ae95c279780e34b8ed8d020b16a12bb2e36fa9025752106c73b4152eb95d2" => :catalina
    sha256 "74b2dcbfa88409a1245d73714a28b3f3dc971ec9ff782a9c2b75fb6a1f6fb5a1" => :mojave
    sha256 "1497767027bbd94fccd041598063141e721365d0f92fa171542b3936ea0d2fa1" => :high_sierra
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

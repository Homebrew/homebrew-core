require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.15.tgz"
  sha256 "5c49e6e02f7ebd5280648ce483fd882f343d32a9c55d4df4eebf0e55e8e116e7"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8debb4cf923826e272d4380975a847058bc48f81481deaabb5c4c1136f91170b"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf2eb7938bb22d7248562aa729129ab51582164f80e0f7664a8ea9f292099b8d"
    sha256 cellar: :any_skip_relocation, catalina:      "a9b97a9899218d53bf8df215e63d26ddad4abea4a99d3f18e4508fd71f161223"
    sha256 cellar: :any_skip_relocation, mojave:        "fc1c5fb8dddb5b385036f962fe237d9de9a2f8ceb843f517f07a0067d87d034b"
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

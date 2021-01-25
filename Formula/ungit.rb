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
    cellar :any_skip_relocation
    sha256 "cf2eb7938bb22d7248562aa729129ab51582164f80e0f7664a8ea9f292099b8d" => :big_sur
    sha256 "8debb4cf923826e272d4380975a847058bc48f81481deaabb5c4c1136f91170b" => :arm64_big_sur
    sha256 "a9b97a9899218d53bf8df215e63d26ddad4abea4a99d3f18e4508fd71f161223" => :catalina
    sha256 "fc1c5fb8dddb5b385036f962fe237d9de9a2f8ceb843f517f07a0067d87d034b" => :mojave
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

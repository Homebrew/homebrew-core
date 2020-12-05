require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.14.tgz"
  sha256 "b1742503cf44ae662cf3eadb28db1423186d9d52ebf7af398a99df23a2525e57"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3ced4848318d45a0cda134de736985c0c5f951537e0b799eea21ec4e65948166" => :big_sur
    sha256 "4532b8cdcebb312719952234b74c131e33300764a32904c5e92d3ffac89064a4" => :catalina
    sha256 "48ed6d0ba522cf36e0e6ec25cc03fba0305d52f9200911242387061cbffe5a56" => :mojave
    sha256 "16fc839b21c419de4b446bb7df046b407fd70125fc3202af5c1ce31f34cac643" => :high_sierra
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

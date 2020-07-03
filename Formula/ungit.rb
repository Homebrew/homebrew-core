require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.8.tgz"
  sha256 "3e954d84d2e47ec249d00873ddac8e201e8fda118ad99330fc84bc9b60fb8bda"

  bottle do
    cellar :any_skip_relocation
    sha256 "71cb892909309d827058b5b50084495a72dc8275bb1e61a2508a0f34ed69f88d" => :catalina
    sha256 "94f1aefea5a373ad6ee29fc22f9ddf625cc0cbc648ffd854e081bb36b95b1f65" => :mojave
    sha256 "4486c6881bf6e5094a22549382cffd2130d737b89e6fd9d3b92fb60f06b8ac86" => :high_sierra
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
    sleep 5

    assert_includes shell_output("curl -s 127.0.0.1:#{port}/"), "<title>ungit</title>"
  end
end

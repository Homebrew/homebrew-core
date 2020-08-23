require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.9.tgz"
  sha256 "788102743a3766554d2a820d3aaf5cb7d88759199942e61e8ff7db6cb15e8dad"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7dd44ea62872b6b74da4a37c831226621642dae6c6df9fe22023541807efe4ba" => :catalina
    sha256 "de93814870e37281df7262938f7a7342d4af8fa587eec8e32dd154089d0bc418" => :mojave
    sha256 "71672f7b2e885d612d4590dafb8cc11b84a47e77e0d89de85879974b77c4a649" => :high_sierra
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

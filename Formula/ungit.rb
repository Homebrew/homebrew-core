require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.10.tgz"
  sha256 "766824a8322b2220a42ad64e9bfae80bba2631de1a5b5ad031bea351f32400c7"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "865ac7720ab246ab188b2ee8cde1002b05acff7433084fe1dc1fa82f3c9d9e08" => :catalina
    sha256 "f19d14b20496b7ac52dc9970030acc945627e06bc3b7bd4902abefae3059191b" => :mojave
    sha256 "48e2af2499f8e2aa6ee395caa28d69943f9aa41b36827728399fa8a2d76668ab" => :high_sierra
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

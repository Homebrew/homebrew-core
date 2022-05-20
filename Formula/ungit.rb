require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.20.tgz"
  sha256 "3a2f8cdf672442b4a833735e59b69b5b2892d377fa117f0c2249dc8e4e5e0e9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a36352a7822196ef8cb0d30dc071da7442462d550d1e92394e7caa9600a5960"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a36352a7822196ef8cb0d30dc071da7442462d550d1e92394e7caa9600a5960"
    sha256 cellar: :any_skip_relocation, monterey:       "3a45be1454281a8a30218e5ad8196ff8607b19d3321ab0e9fe7e085a77d8330c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a45be1454281a8a30218e5ad8196ff8607b19d3321ab0e9fe7e085a77d8330c"
    sha256 cellar: :any_skip_relocation, catalina:       "3a45be1454281a8a30218e5ad8196ff8607b19d3321ab0e9fe7e085a77d8330c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a36352a7822196ef8cb0d30dc071da7442462d550d1e92394e7caa9600a5960"
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

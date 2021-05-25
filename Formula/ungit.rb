require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.18.tgz"
  sha256 "7bc917ccbb9aa33773b8915400c4c7fbae375a346dba6613e5b0eaae7cad6fb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3e965990622c195784b91fd0ad01731265843cc512ae80f2d0f9f6d41ca9b4e3"
    sha256 cellar: :any_skip_relocation, big_sur:       "0d2ebcb0625e8ec112ba65e8f477ad9547b4b349611f3209d150892f21100acb"
    sha256 cellar: :any_skip_relocation, catalina:      "0d2ebcb0625e8ec112ba65e8f477ad9547b4b349611f3209d150892f21100acb"
    sha256 cellar: :any_skip_relocation, mojave:        "0d2ebcb0625e8ec112ba65e8f477ad9547b4b349611f3209d150892f21100acb"
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

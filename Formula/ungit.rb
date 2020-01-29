require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.2.tgz"
  sha256 "14d661cf610e18b8ed2c4a9b983919eb09e1a0e4d93f0ebf1ca8a3132d499ccb"

  bottle do
    cellar :any_skip_relocation
    sha256 "287bc7f94ff856dba56f6faf19700b3a973b28b9034796f378afe2e86c1429ad" => :catalina
    sha256 "2a8f82d9cb0e4be0f550b4239a6d9c927f2ea5be0a82fe3f3e79b244c624e1aa" => :mojave
    sha256 "d3379a71b3f4a89bb335b33fbe08f1b3618fdcc659d0e735227f9c73236a3946" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    ppid = fork do
      exec bin/"ungit", "--no-launchBrowser", "--port=#{port}", "--autoShutdownTimeout=6000"
    end
    sleep 5
    assert_includes shell_output("curl -s 127.0.0.1:#{port}/"), "<title>ungit</title>"
  ensure
    if ppid
      Process.kill("TERM", ppid)
      # ensure that there are no spawned child processes left
      child_p = shell_output("ps -o pid,ppid").scan(/^(\d+)\s+#{ppid}\s*$/).map { |p| p[0].to_i }
      child_p.each { |pid| Process.kill("TERM", pid) }
      Process.wait(ppid)
    end
  end
end

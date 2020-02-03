require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.3.tgz"
  sha256 "7c6308bd48b628f831c7c3f8579d2ece920dedb124fcf7390378256950e123a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "10c261fdc41e3d4e7b0a21f5d5ddd848120cac2d05b13256da3c13b325c771f9" => :catalina
    sha256 "efc23deb93844b74adf93de925bd2bfb9814886dda3deacb14623cd6c965f239" => :mojave
    sha256 "e77dd9feca873f2578f6dc4a647ba390461d1706adeef197b58cbf34adbeb0b5" => :high_sierra
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

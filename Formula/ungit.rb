require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.3.tgz"
  sha256 "7c6308bd48b628f831c7c3f8579d2ece920dedb124fcf7390378256950e123a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "87704d4be9d6df4f14fa2eb449a2afb1917f12556987feb039d31191134ebf30" => :catalina
    sha256 "0f87c8ecd8379a82da1e5f54f644265a23f51622fa1041ae798cda5e025ec118" => :mojave
    sha256 "5ae9f072f453bae45286eb8b2c59b871debeaa302422ac2287a3c4f9295bb457" => :high_sierra
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
      child_p = pipe_output("ps -o pid,ppid").scan(/^(\d+)\s+#{ppid}\s*$/).map { |p| p[0].to_i }
      child_p.each { |pid| Process.kill("TERM", pid) }
      Process.wait(ppid)
    end
  end
end

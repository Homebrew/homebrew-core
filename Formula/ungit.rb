require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.1.tgz"
  sha256 "8f045f6f606e3e89a8a053f86c9d403ba85df8d047e85a31a321fcce99cd9dee"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdbe64c67f0f71eed673c180e89ee49217bf3a668858fff4b0622c8107818366" => :catalina
    sha256 "032b92fc6515c3e52a2e54bf2acb7da99f53242847b4349f1a14d13763c216c5" => :mojave
    sha256 "d2c473a1cd2cccfd3b8ed5abf35c436aeb98c9c352534c114b1d4409e2f4c9c2" => :high_sierra
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

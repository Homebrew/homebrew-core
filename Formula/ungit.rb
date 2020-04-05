require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.6.tgz"
  sha256 "f105bcd9db7d498a7c472e807836820dca3a86ffc06ba5207e9c28f50761222b"

  bottle do
    cellar :any_skip_relocation
    sha256 "df95d903830745c30847bb392c132d1ae7f7153dc93fa0907ae0476b23259fdb" => :catalina
    sha256 "cdc3fb0e814a174f6638f89ea71883898256e08a10bd550fea0055046ec3fe19" => :mojave
    sha256 "5159c2c7cd97a7de351b8121c93b57a5cdebd59287cab7ff24ad668256ca180f" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port
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

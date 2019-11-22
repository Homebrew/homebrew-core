require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.0.tgz"
  sha256 "e41ec6128586f980140bb38393d4135710cb14d3ef3e4431720f1b3550ce6047"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed42ae8af033b52cb1048fc8d9915fb7633c4627e7ee0a7819251368cd45f2fc" => :catalina
    sha256 "341dde234a6a0e375f26c95b604bf964fec73d7f4ff50258ac1a9198bfb511d8" => :mojave
    sha256 "073a373648a944b4ea72184f5c1f7d4dcec932d998e239f83b9fbeb4f496ccce" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    require "nokogiri"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    ppid = fork do
      exec bin/"ungit", "--no-launchBrowser", "--port=#{port}", "--autoShutdownTimeout=6000"
    end
    sleep 5
    assert_match "ungit", Nokogiri::HTML(shell_output("curl -s 127.0.0.1:#{port}/")).at_css("title").text
  ensure
    Process.kill("TERM", ppid)
    # ensure that there are no spawned child processes left
    child_p = shell_output("ps -o pid,ppid").scan(/^(\d+)\s+#{ppid}\s*$/).map { |p| p[0].to_i }
    child_p.each { |pid| Process.kill("TERM", pid) }
    Process.wait(ppid)
  end
end

require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.0.tgz"
  sha256 "e41ec6128586f980140bb38393d4135710cb14d3ef3e4431720f1b3550ce6047"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce1ae47d981846075039727bf49cab48878d423b037826da80a00ca9947eb032" => :catalina
    sha256 "7d2353cd03d6e6c0a507f09ede57f6631ac970f03aac0b93f4b0e3cbe9341700" => :mojave
    sha256 "9ddae55fa2dc593690d08c3d661e87a1441c457d5505d411eef9dca0a23dcb33" => :high_sierra
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

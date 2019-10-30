require "language/node"

class Topshell < Formula
  desc "Purely functional, reactive scripting language"
  homepage "https://github.com/topshell-language/topshell"
  url "https://github.com/topshell-language/topshell/archive/v0.7.7.tar.gz"
  sha256 "a24c759b231fbd5aaed3409ed5d12e98ae2987cc27672fef27964a21017dccd6"

  depends_on "node" => :build
  depends_on "sbt" => :build

  def install
    system "sbt", "fullOptJS"
    cd "node" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "node_modules/.bin/pkg", "-t", "macos-x64", "package.json"
      bin.install "topshell"
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/topshell"
      end
      sleep 1
      output = shell_output("curl -o /dev/null -s -w '%{http_code}\\n' http://localhost:7070/topshell/index.html")
      assert_match(/200/m, output)
    ensure
      Process.kill("HUP", pid)
    end
  end
end

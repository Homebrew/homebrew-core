require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.4.40.tgz"
  sha256 "ef4067b13d8cbc596734e66445c08bd03ec59577734c741bf4a943d853f452da"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3c7afb82fb3c32af9a0fff94e04d9706be96e4b631a9880a42e161164f1e112" => :mojave
    sha256 "d639e5e39e74fc5cc06b23b35b4c69be33b74fa098f29552f7f781a434c89ffa" => :high_sierra
    sha256 "118ae206c3a4dd88bbd3ae08b856d6ae581532a0f3d0cf0723224b76dcdba455" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    begin
      require "nokogiri"

      pid = fork do
        exec bin/"ungit", "--no-launchBrowser", "--autoShutdownTimeout", "5000" # give it an idle timeout to make it exit
      end
      sleep 3
      assert_match "ungit", Nokogiri::HTML(shell_output("curl -s 127.0.0.1:8448/")).at_css("title").text
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

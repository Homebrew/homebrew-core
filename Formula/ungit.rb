require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.4.36.tgz"
  sha256 "3bb07b99e2616afd3059809768036eaefd92d1a62cfab9dc087b9405933ec7f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "002cb1b980124683c08a20ce48492eee37eb861f5606441678a7d694e3f99126" => :mojave
    sha256 "f6763612763f62ea554c4aba66340d7bfe6a1181729e1d72be28d1eda1175849" => :high_sierra
    sha256 "384dc56bc235de67cc8c97d465f8759f2d24eb54b2d65dc8abaf6a7213658293" => :sierra
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

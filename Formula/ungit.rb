require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.4.41.tgz"
  sha256 "d1940e8987ddd8bce93d2af8bb9d1a90c7ac450f0c06c08f672e93ba02d7d84a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e14591fb0397f4bc86bca9d39527bc35d33be7e3b1a5e3a086c62e81047b0e7" => :mojave
    sha256 "ad54bf1d8c04b1ca6915fb4174a4e47ff5d344d177e03341f3c820f663a29778" => :high_sierra
    sha256 "1ffaafb011f5aae300d267d0ecc039c249316894cb05cd627f3007f202f7cfdc" => :sierra
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

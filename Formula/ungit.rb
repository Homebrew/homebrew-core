require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.4.43.tgz"
  sha256 "571ab330193a142dc60a630ca5bfdcac79c46eaf2deab71e76c708c08f6989c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d5eb23138d38e0568495dfdde0b82b27a112ddfd5c8d0f23ae492f3dfee57d2" => :mojave
    sha256 "27aa59d9bb0f5c1d0cc2e4f7db89eeb9b7da106b87d3b487873e48295ce53a88" => :high_sierra
    sha256 "9a818f694c16da122a2617a50fd8ac85c16b800261c2b270a98cca6ae5c66c66" => :sierra
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

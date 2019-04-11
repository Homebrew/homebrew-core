require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.4.43.tgz"
  sha256 "571ab330193a142dc60a630ca5bfdcac79c46eaf2deab71e76c708c08f6989c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "4408c2c23f037c8f22eac9fc7f41aff88dd1b59a8d00189c19767ff97ccec65e" => :mojave
    sha256 "0b33c5431743a6a0b2acee98cd7c8b1c718aacda56ebc2232cec1974a4ba7708" => :high_sierra
    sha256 "5bd29f9ca120a2262f35fd8e1d95cff95288c87e215214311205fa70289e7dd5" => :sierra
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

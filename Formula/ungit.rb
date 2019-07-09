require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.4.45.tgz"
  sha256 "bc6a9dd55937ffc46f46be60a58abc4db085115ba69e7cf39e5aa762651999d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "fca14afa690a8043d27510e0f1cd95422aa80ae055aa339b7cd413e3e2eeeee3" => :mojave
    sha256 "4d79139bff631c948679ab2cfbd504a358f589e8b3753b2d31f2737c9066f1db" => :high_sierra
    sha256 "bdd2e7e34dd3f6d8fec678df5f07b4bc6f8523eae752c08d95e61fd8fc4ffbad" => :sierra
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

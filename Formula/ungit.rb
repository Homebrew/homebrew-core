require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.4.45.tgz"
  sha256 "bc6a9dd55937ffc46f46be60a58abc4db085115ba69e7cf39e5aa762651999d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c6e00aef5a25f4c9749bcc2448aee9f7b14726f55bc6a57dc708660e029b923" => :mojave
    sha256 "01c84b92d9b28e98e4ed1a842eeece5698283a394b9ee0d12acbae42b829843b" => :high_sierra
    sha256 "cb7474b30a4c5bce09262eade9a8cd3434bfc9cf770c49f4b5828c4ad63e3e27" => :sierra
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

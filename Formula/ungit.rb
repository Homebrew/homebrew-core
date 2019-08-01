require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.4.46.tgz"
  sha256 "cbb177f1f45276894daa1d2580535c29b8adeaedc5c0dfc2af9ec3e9cd2813f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "309b81a817280d6219cdaa460c2919deb3163faed9f42c3500280f020397a613" => :mojave
    sha256 "07f0ba12becf748cdd02a64c5d2059f4e130f24452b45963c59234fc8ad257bc" => :high_sierra
    sha256 "ee792bbbc4ac5ed8508e0c75ccd1be5cc3c6647e3a6194f2bc0dd997139b2686" => :sierra
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
      sleep 5
      assert_match "ungit", Nokogiri::HTML(shell_output("curl -s 127.0.0.1:8448/")).at_css("title").text
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.4.46.tgz"
  sha256 "cbb177f1f45276894daa1d2580535c29b8adeaedc5c0dfc2af9ec3e9cd2813f7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "107c230eec3615678b6640184c5156236850de4ff3b82b19ca559f92f65a54d9" => :mojave
    sha256 "a7e0c6abeb515541ef76cdeea81e516f628be258cc1cc55876f25f07566c0aa1" => :high_sierra
    sha256 "773b35dec90a13ba957acad35b882321e2e747e4671006fc81f63c5a8c7af163" => :sierra
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

require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.4.47.tgz"
  sha256 "be09b1210dbd221e2df1545ba6f3f90607609dcd4f816acd10128f7b97142f24"

  bottle do
    cellar :any_skip_relocation
    sha256 "e233e8cb64931db8e7e2619c17caa5ea9312b13c527bf6c615266a56b88114a1" => :mojave
    sha256 "29a874ac4d0ece018d37992264a3b0e58d8782ebcbb1d9593f07341d1a77e52d" => :high_sierra
    sha256 "55a92e5decc65e32fe6db750d4152680a65e013fd47ce727e1ef034650c479d5" => :sierra
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

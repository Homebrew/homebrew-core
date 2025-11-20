class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-19.1.0.tgz"
  sha256 "5045fcd5863d424123dfd83132f70814c8278591a177931e9b472bd1e590d805"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fcf11b3dd4b724f6e6885c2050927e6f5913c76b165fd605582a94e2722c2bfb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    config_file = testpath/".wikibase-cli.json"
    config_file.write "{\"instance\":\"https://www.wikidata.org\"}"

    ENV["WB_CONFIG"] = config_file

    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip

    assert_match version.to_s, shell_output("#{bin}/wd --version")
  end
end

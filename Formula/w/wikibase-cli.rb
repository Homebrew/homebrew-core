class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-19.3.0.tgz"
  sha256 "84cc76f230276451d3450c2562bbb3843b13bc7685d347ef8e16f1d849fd5736"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "683ee4ca75ddbf118f9d3fbeec52c39937c109196027cbae316585a021db6208"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    config_file = testpath/".wikibase-cli.json"
    config_file.write "{\"instance\":\"https://www.wikidata.org\"}"

    ENV["WB_CONFIG"] = config_file

    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip

    assert_match version.to_s, shell_output("#{bin}/wd --version")
  end
end

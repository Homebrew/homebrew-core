class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://codeberg.org/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-21.0.0.tgz"
  sha256 "1bb26390675f758abb89cea5f29167f52eae3c5f29314fae505d02b910148754"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c8a7b804fd0857838ee8c47c4ad3101608d21981a5cfaaf6f65604e0715aa03"
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

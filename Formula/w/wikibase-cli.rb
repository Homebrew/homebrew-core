class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-18.3.3.tgz"
  sha256 "3bfd8433eaae7ff56b5ca76b0411183a7436e2710374135bf3879a3fc0ebf259"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14997de71a2e553b377832162fc2f923d087c5a8425d82f4c7ad00a6adbdc2e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14997de71a2e553b377832162fc2f923d087c5a8425d82f4c7ad00a6adbdc2e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14997de71a2e553b377832162fc2f923d087c5a8425d82f4c7ad00a6adbdc2e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1ffc6a93fd0efd0f44a502d3ebafbaeac50224b89675966dc21da0076934930"
    sha256 cellar: :any_skip_relocation, ventura:       "b1ffc6a93fd0efd0f44a502d3ebafbaeac50224b89675966dc21da0076934930"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3411fce69763b1fa6c69aa74990f1de717ec0d06553896f44147eec581b9082f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14997de71a2e553b377832162fc2f923d087c5a8425d82f4c7ad00a6adbdc2e5"
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

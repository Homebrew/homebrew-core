class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-18.3.1.tgz"
  sha256 "529ff19bb2793ffd8b1d55327ed1588fd9762e399a0d077fbdf80afd9b399145"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3221188c36ef90ad126d3bed698aa4ce3d9782d2f9ed97770e5f1fc1c6f21653"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3221188c36ef90ad126d3bed698aa4ce3d9782d2f9ed97770e5f1fc1c6f21653"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3221188c36ef90ad126d3bed698aa4ce3d9782d2f9ed97770e5f1fc1c6f21653"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5a49052d63ac443fad865a22a3774031d1ac4df1b6a30c731452a5969756ae3"
    sha256 cellar: :any_skip_relocation, ventura:       "a5a49052d63ac443fad865a22a3774031d1ac4df1b6a30c731452a5969756ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3221188c36ef90ad126d3bed698aa4ce3d9782d2f9ed97770e5f1fc1c6f21653"
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

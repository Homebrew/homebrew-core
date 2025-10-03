class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-19.0.1.tgz"
  sha256 "9d6a39874c34e3f2893900df8a83b8cd2582748c64afe3dc285216c5b42da93f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ee8d4320500f0bfadaf7fd3e19cd10f3e30f0b435cb749054f2742a81871bed"
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

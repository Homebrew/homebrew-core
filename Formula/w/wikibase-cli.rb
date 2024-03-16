require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli#readme"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-18.0.1.tgz"
  sha256 "c6bd5ccdc0d1273b81951f715ea2b2c5c0049b83c23080e10cb59f5990c4ceaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99dd57cfb7418cc44faa5859467a3e79360efa5d37ad48b30792ab8060faefe2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99dd57cfb7418cc44faa5859467a3e79360efa5d37ad48b30792ab8060faefe2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99dd57cfb7418cc44faa5859467a3e79360efa5d37ad48b30792ab8060faefe2"
    sha256 cellar: :any_skip_relocation, sonoma:         "eefc8ac14b5a19ddc5601f11f0eb45bb5ca9343be34e2bf8bfee2f1e98a45a10"
    sha256 cellar: :any_skip_relocation, ventura:        "eefc8ac14b5a19ddc5601f11f0eb45bb5ca9343be34e2bf8bfee2f1e98a45a10"
    sha256 cellar: :any_skip_relocation, monterey:       "eefc8ac14b5a19ddc5601f11f0eb45bb5ca9343be34e2bf8bfee2f1e98a45a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99dd57cfb7418cc44faa5859467a3e79360efa5d37ad48b30792ab8060faefe2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip
  end
end

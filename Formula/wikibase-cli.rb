require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli#readme"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-16.3.1.tgz"
  sha256 "d0e86661a44fffac6995dfebad9dacb58e930b06cd962e93911697966351a261"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c188b14b9da086097207f7325b99d1948aa87ed920d6e6b96cf1972fe711d88d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c188b14b9da086097207f7325b99d1948aa87ed920d6e6b96cf1972fe711d88d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c188b14b9da086097207f7325b99d1948aa87ed920d6e6b96cf1972fe711d88d"
    sha256 cellar: :any_skip_relocation, ventura:        "d9c256d851bd335acea7a843ef9614e3cec0f08b2357bdc68fcdc5a45e0cd3ac"
    sha256 cellar: :any_skip_relocation, monterey:       "d9c256d851bd335acea7a843ef9614e3cec0f08b2357bdc68fcdc5a45e0cd3ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9c256d851bd335acea7a843ef9614e3cec0f08b2357bdc68fcdc5a45e0cd3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c188b14b9da086097207f7325b99d1948aa87ed920d6e6b96cf1972fe711d88d"
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

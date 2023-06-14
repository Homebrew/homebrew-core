require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli#readme"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-16.3.3.tgz"
  sha256 "e1b4ac584b12ac4a26fcb1c07f3c24a6362605eab94b4e27a0ca96ba0fd406a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53eccf447a9261e6aeda07e2201556701dcb15c3539ff9055463bd8b13a12a01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53eccf447a9261e6aeda07e2201556701dcb15c3539ff9055463bd8b13a12a01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53eccf447a9261e6aeda07e2201556701dcb15c3539ff9055463bd8b13a12a01"
    sha256 cellar: :any_skip_relocation, ventura:        "112d5e043bc67d3c38c44c02702bd19245e3a5cdb3f9d913a9843166503a5ded"
    sha256 cellar: :any_skip_relocation, monterey:       "112d5e043bc67d3c38c44c02702bd19245e3a5cdb3f9d913a9843166503a5ded"
    sha256 cellar: :any_skip_relocation, big_sur:        "112d5e043bc67d3c38c44c02702bd19245e3a5cdb3f9d913a9843166503a5ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53eccf447a9261e6aeda07e2201556701dcb15c3539ff9055463bd8b13a12a01"
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

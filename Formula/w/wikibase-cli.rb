require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli#readme"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-17.0.3.tgz"
  sha256 "e955cba253631ef0627b2e2f047c4d777fbc3a00d8571554db062935c5ec9425"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68f46528fb69d6f521e99bd1404e425a14c0e0e7a31f7293196ba4be33ebdbc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68f46528fb69d6f521e99bd1404e425a14c0e0e7a31f7293196ba4be33ebdbc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68f46528fb69d6f521e99bd1404e425a14c0e0e7a31f7293196ba4be33ebdbc5"
    sha256 cellar: :any_skip_relocation, ventura:        "36924252e03742e4270d686b65ef314e3b8e90295a0d5dbf0a6510db299720e0"
    sha256 cellar: :any_skip_relocation, monterey:       "36924252e03742e4270d686b65ef314e3b8e90295a0d5dbf0a6510db299720e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "36924252e03742e4270d686b65ef314e3b8e90295a0d5dbf0a6510db299720e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98a12c40450495958b1613b54ad34830da9f7667e6823abb73b1190a47ce294b"
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

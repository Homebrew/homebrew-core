require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli#readme"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-18.0.2.tgz"
  sha256 "f74d919035444bafac6e667aa9f5332e4dbc87f09c0d92737667f6fe7188e42b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c5c0bd448b371201e9b3d17d62f8d5208e34c1826f4c962dc2c8127e1c0baf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c5c0bd448b371201e9b3d17d62f8d5208e34c1826f4c962dc2c8127e1c0baf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c5c0bd448b371201e9b3d17d62f8d5208e34c1826f4c962dc2c8127e1c0baf6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5e81d472edfffe7a891fbe7f532069aa17f5a120d9b75970a46c2043cb0b2b1"
    sha256 cellar: :any_skip_relocation, ventura:        "b5e81d472edfffe7a891fbe7f532069aa17f5a120d9b75970a46c2043cb0b2b1"
    sha256 cellar: :any_skip_relocation, monterey:       "b5e81d472edfffe7a891fbe7f532069aa17f5a120d9b75970a46c2043cb0b2b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c5c0bd448b371201e9b3d17d62f8d5208e34c1826f4c962dc2c8127e1c0baf6"
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

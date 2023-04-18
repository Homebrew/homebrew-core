require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli#readme"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-16.3.2.tgz"
  sha256 "fb37f93eb5a08352fd9b6a0b1643532d52b85517e0d20073bf084b6969cf79f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afb9733a63ff3044aecd917d89847a92ff774cc7b320e22b5a2c55814a84383b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afb9733a63ff3044aecd917d89847a92ff774cc7b320e22b5a2c55814a84383b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afb9733a63ff3044aecd917d89847a92ff774cc7b320e22b5a2c55814a84383b"
    sha256 cellar: :any_skip_relocation, ventura:        "9c7b1ab36fd1ad23fa0c508069ec061b498331b45c82135da681b10ba77c5211"
    sha256 cellar: :any_skip_relocation, monterey:       "9c7b1ab36fd1ad23fa0c508069ec061b498331b45c82135da681b10ba77c5211"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c7b1ab36fd1ad23fa0c508069ec061b498331b45c82135da681b10ba77c5211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afb9733a63ff3044aecd917d89847a92ff774cc7b320e22b5a2c55814a84383b"
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

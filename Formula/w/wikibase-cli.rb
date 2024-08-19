class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-18.1.0.tgz"
  sha256 "dec930f6581cf3aecfdb055c974ddec8f411cb4edeb5ec1d3fb49a3185ef7684"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbd47c1ec4b562aa06a4858e9ece97662b7876b58082db19fc7d4e03d93d9ea0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbd47c1ec4b562aa06a4858e9ece97662b7876b58082db19fc7d4e03d93d9ea0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbd47c1ec4b562aa06a4858e9ece97662b7876b58082db19fc7d4e03d93d9ea0"
    sha256 cellar: :any_skip_relocation, sonoma:         "846a45810762af1fb5dfacf998951f899fa0fb921fe3dd4bc8cb7f7a9d6e3847"
    sha256 cellar: :any_skip_relocation, ventura:        "846a45810762af1fb5dfacf998951f899fa0fb921fe3dd4bc8cb7f7a9d6e3847"
    sha256 cellar: :any_skip_relocation, monterey:       "846a45810762af1fb5dfacf998951f899fa0fb921fe3dd4bc8cb7f7a9d6e3847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbd47c1ec4b562aa06a4858e9ece97662b7876b58082db19fc7d4e03d93d9ea0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip
  end
end

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-18.0.4.tgz"
  sha256 "aa7c2fc83e6024d680ee5b334e451e01c17f22664c8880622699531269c1bcfa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43268910237dc658e9825b3ca57773b347b8034bd5e57643e8045d608d9af41a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43268910237dc658e9825b3ca57773b347b8034bd5e57643e8045d608d9af41a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43268910237dc658e9825b3ca57773b347b8034bd5e57643e8045d608d9af41a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a71aeeb739536ec6420ebf8df0aa29527b9bd80ab63bfbe5e321381ab4a65fc"
    sha256 cellar: :any_skip_relocation, ventura:        "3a71aeeb739536ec6420ebf8df0aa29527b9bd80ab63bfbe5e321381ab4a65fc"
    sha256 cellar: :any_skip_relocation, monterey:       "3a71aeeb739536ec6420ebf8df0aa29527b9bd80ab63bfbe5e321381ab4a65fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43268910237dc658e9825b3ca57773b347b8034bd5e57643e8045d608d9af41a"
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

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-18.2.1.tgz"
  sha256 "8371a5d4d5639bd0336d39a970fd902113ed9d52b0f7aaae6415914fe2d15906"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b5bf7e82c50dfc1811b24f27745e7176cede497b76417e6b791f29ded672a95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b5bf7e82c50dfc1811b24f27745e7176cede497b76417e6b791f29ded672a95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b5bf7e82c50dfc1811b24f27745e7176cede497b76417e6b791f29ded672a95"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f2407affb3594b812a51b642b54da829f70311f45da052ad93470ded69079ab"
    sha256 cellar: :any_skip_relocation, ventura:       "4f2407affb3594b812a51b642b54da829f70311f45da052ad93470ded69079ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b5bf7e82c50dfc1811b24f27745e7176cede497b76417e6b791f29ded672a95"
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

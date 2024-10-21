class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-18.2.2.tgz"
  sha256 "7745aa0e89506fe13502ee094dba848ccdf935df16e20a693a97162382e3fbeb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "225b195421259af7c9c695cac4a7c4339b09acfae183f7d6a8e6339ec85b4ebf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "225b195421259af7c9c695cac4a7c4339b09acfae183f7d6a8e6339ec85b4ebf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "225b195421259af7c9c695cac4a7c4339b09acfae183f7d6a8e6339ec85b4ebf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8712666f7e32801dd54cd048a6a131da04ff9f6420294a321011217ef7e3a43c"
    sha256 cellar: :any_skip_relocation, ventura:       "8712666f7e32801dd54cd048a6a131da04ff9f6420294a321011217ef7e3a43c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "225b195421259af7c9c695cac4a7c4339b09acfae183f7d6a8e6339ec85b4ebf"
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

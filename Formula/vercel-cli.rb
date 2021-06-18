require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-23.0.1.tgz"
  sha256 "4249cdb58fb3b2d843f9f9758c8e201b6f10b7773d30e13bddadab0e1b555d14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b9d7b56e18752c0e3284da811ea7a35513e1ee7f1cefe42b00f8ed91b91062e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "3b47d2258aba8af3e60262c104010d847de3874cd6f0f203b17291975b1ad3ac"
    sha256 cellar: :any_skip_relocation, catalina:      "3b47d2258aba8af3e60262c104010d847de3874cd6f0f203b17291975b1ad3ac"
    sha256 cellar: :any_skip_relocation, mojave:        "3b47d2258aba8af3e60262c104010d847de3874cd6f0f203b17291975b1ad3ac"
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "exports.default = getUpdateCommand",
                               "exports.default = async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
